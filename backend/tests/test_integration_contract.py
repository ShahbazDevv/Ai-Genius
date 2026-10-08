import uuid
from unittest.mock import patch
import pytest
from fastapi.testclient import TestClient
from sqlalchemy.exc import OperationalError

from app.core.limiter import limiter
from app.main import app

client = TestClient(app)

FORBIDDEN_WORDS = [
    "traceback",
    "sqlalchemy",
    "psycopg",
    "postgres",
    "supabase",
    "password",
    'file "',
    "database_url",
]


@pytest.fixture(autouse=True)
def reset_rate_limiter():
    """Ensure limiter is clean before and after every test."""
    limiter.reset()
    yield
    limiter.reset()


# ==============================================================================
# 1. Strict budget through the API
#    Budgets 500, 1000, 3500, 7000, 15000 with 4 different request profiles each.
# ==============================================================================
@pytest.mark.parametrize("budget", [500, 1000, 3500, 7000, 15000])
def test_strict_budget_through_api(budget):
    profiles = [
        # Profile 1: Mother, birthday, beauty + skincare
        {
            "relationship": "mother",
            "age_group": "40_49",
            "gender": "female",
            "occasion": "birthday",
            "interests": ["beauty", "skincare"],
            "gift_styles": ["elegant", "practical"],
        },
        # Profile 2: Friend, eid, gaming + technology
        {
            "relationship": "friend",
            "age_group": "20_24",
            "gender": "male",
            "occasion": "eid",
            "interests": ["gaming", "technology"],
            "gift_styles": ["fun", "practical"],
        },
        # Profile 3: Brother, graduation, cricket + sports
        {
            "relationship": "brother",
            "age_group": "20_24",
            "gender": "male",
            "occasion": "graduation",
            "interests": ["cricket", "sports"],
            "gift_styles": ["budget_friendly", "practical"],
        },
        # Profile 4: Teacher, thank you, books + art_crafts
        {
            "relationship": "teacher",
            "age_group": "40_49",
            "gender": "unspecified",
            "occasion": "thank_you",
            "interests": ["books", "art_crafts"],
            "gift_styles": ["sentimental", "minimal"],
        },
    ]

    for profile in profiles:
        limiter.reset()
        payload = {**profile, "budget": budget}
        response = client.post("/api/v1/recommendations", json=payload)
        assert response.status_code == 200, (
            f"Failed for profile {profile['relationship']} at budget {budget}: {response.text}"
        )
        data = response.json()
        categories = data["categories"]

        # Assert at most 4 categories
        assert len(categories) <= 4, f"Returned {len(categories)} categories (max 4 allowed)"

        for cat in categories:
            products = cat["products"]
            # Assert at most 12 products per category
            assert len(products) <= 12, (
                f"Category {cat['id']} returned {len(products)} products (max 12 allowed)"
            )
            # Assert no returned product price is above the request budget
            for p in products:
                assert p["price"] <= budget, (
                    f"Product '{p['name']}' price {p['price']} exceeds budget {budget}!"
                )
                assert p["price"] > 0, f"Product '{p['name']}' has invalid non-positive price {p['price']}"


# ==============================================================================
# 2. No leaks
#    Responses 404, 405, 413, 422, 429, 500, 503 must have {"error": {"code", "message"}}
#    and never leak any forbidden words: traceback, sqlalchemy, psycopg, postgres,
#    supabase, password, File ", DATABASE_URL.
# ==============================================================================
def assert_contract_error_shape_and_no_leaks(response, expected_status: int):
    assert response.status_code == expected_status, (
        f"Expected HTTP {expected_status}, got {response.status_code}: {response.text}"
    )
    data = response.json()

    # Assert contract shape {"error": {"code", "message"}}
    assert "error" in data, f"Response missing 'error' root: {data}"
    assert "code" in data["error"], f"Response missing 'error.code': {data}"
    assert "message" in data["error"], f"Response missing 'error.message': {data}"
    assert isinstance(data["error"]["code"], str)
    assert isinstance(data["error"]["message"], str)
    assert "detail" not in data, f"Response contains FastAPI default 'detail': {data}"

    # Assert response contains NONE of the forbidden leak words (case-insensitive)
    text_lower = response.text.lower()
    for word in FORBIDDEN_WORDS:
        assert word.lower() not in text_lower, (
            f"Status {expected_status} leaked forbidden word '{word}'!\nResponse text:\n{response.text}"
        )


def test_no_leaks_status_404():
    # 404 on nonexistent product UUID
    random_uuid = str(uuid.uuid4())
    resp = client.get(f"/api/v1/products/{random_uuid}")
    assert_contract_error_shape_and_no_leaks(resp, 404)

    # 404 on nonexistent URL path
    resp_path = client.get("/api/v1/unknown_endpoint_route")
    assert_contract_error_shape_and_no_leaks(resp_path, 404)


def test_no_leaks_status_405():
    # GET on recommendations endpoint (which only allows POST)
    resp = client.get("/api/v1/recommendations")
    assert_contract_error_shape_and_no_leaks(resp, 405)


def test_no_leaks_status_413():
    # Payload exceeding 64 KB limit
    large_payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "occasion": "birthday",
        "budget": 3500,
        "interests": ["beauty"],
        "padding": "X" * (70 * 1024),
    }
    resp = client.post("/api/v1/recommendations", json=large_payload)
    assert_contract_error_shape_and_no_leaks(resp, 413)


def test_no_leaks_status_422():
    # Validation error: budget below minimum and unknown interest
    bad_payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "occasion": "birthday",
        "budget": 200,
        "interests": ["invalid_interest_value"],
    }
    resp = client.post("/api/v1/recommendations", json=bad_payload)
    assert_contract_error_shape_and_no_leaks(resp, 422)


def test_no_leaks_status_429():
    limiter.reset()
    payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "occasion": "birthday",
        "budget": 3500,
        "interests": ["beauty"],
    }
    resp_429 = None
    for _ in range(35):
        r = client.post("/api/v1/recommendations", json=payload)
        if r.status_code == 429:
            resp_429 = r
            break

    assert resp_429 is not None, "Expected rate limit 429 to trigger"
    assert_contract_error_shape_and_no_leaks(resp_429, 429)


def test_no_leaks_status_500():
    client_no_raise = TestClient(app, raise_server_exceptions=False)
    # Inject all forbidden words into internal error to prove zero leakage
    leak_exception = RuntimeError(
        "Traceback (most recent call last): in File \"server.py\", "
        "sqlalchemy psycopg postgres supabase password DATABASE_URL"
    )
    with patch(
        "app.api.v1.recommendations.RecommendationService.get_recommendations",
        side_effect=leak_exception,
    ):
        resp = client_no_raise.post(
            "/api/v1/recommendations",
            json={
                "relationship": "mother",
                "age_group": "40_49",
                "occasion": "birthday",
                "budget": 3500,
                "interests": ["beauty"],
            },
        )
        assert_contract_error_shape_and_no_leaks(resp, 500)


def test_no_leaks_status_503():
    client_no_raise = TestClient(app, raise_server_exceptions=False)
    # Inject all forbidden words into internal DB error to prove zero leakage
    leak_db_error = OperationalError(
        "Connection refused to postgres://admin:password@supabase.co:5432 "
        "File \"db.py\" psycopg sqlalchemy DATABASE_URL",
        params=None,
        orig=Exception("Database down"),
    )
    with patch(
        "app.repositories.catalog_repository.CatalogRepository.get_active_categories_and_products",
        side_effect=leak_db_error,
    ):
        resp = client_no_raise.post(
            "/api/v1/recommendations",
            json={
                "relationship": "mother",
                "age_group": "40_49",
                "occasion": "birthday",
                "budget": 3500,
                "interests": ["beauty"],
            },
        )
        assert_contract_error_shape_and_no_leaks(resp, 503)


# ==============================================================================
# 3. Contract shape
#    Exact fields from docs/api_contract.md:
#    Top-level: request_id, budget, currency, categories
#    Category: id, name, reason, icon, product_count, products
#    Product: id, name, description, price, currency, image_url, store_name,
#             store_url, category_id, tags, availability, source, last_updated
# ==============================================================================
def test_contract_shape_successful_recommendation():
    limiter.reset()
    payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "gender": "female",
        "occasion": "birthday",
        "budget": 3500,
        "interests": ["beauty", "skincare"],
        "gift_styles": ["elegant", "practical"],
        "additional_details": "Likes calming skincare routine.",
    }
    response = client.post("/api/v1/recommendations", json=payload)
    assert response.status_code == 200, f"Request failed: {response.text}"
    data = response.json()

    # Exact expected keys
    EXPECTED_RESPONSE_KEYS = {"request_id", "budget", "currency", "categories"}
    EXPECTED_CATEGORY_KEYS = {"id", "name", "reason", "icon", "product_count", "products"}
    EXPECTED_PRODUCT_KEYS = {
        "id",
        "name",
        "description",
        "price",
        "currency",
        "image_url",
        "store_name",
        "store_url",
        "category_id",
        "tags",
        "availability",
        "source",
        "last_updated",
    }

    assert set(data.keys()) == EXPECTED_RESPONSE_KEYS, (
        f"Top-level keys mismatch: got {set(data.keys())}, expected {EXPECTED_RESPONSE_KEYS}"
    )

    assert len(data["categories"]) > 0, "Expected at least 1 category for this request"

    for cat in data["categories"]:
        assert set(cat.keys()) == EXPECTED_CATEGORY_KEYS, (
            f"Category keys mismatch for '{cat.get('id')}': got {set(cat.keys())}, expected {EXPECTED_CATEGORY_KEYS}"
        )
        assert len(cat["products"]) > 0, f"Category '{cat.get('id')}' has no products"
        for prod in cat["products"]:
            assert set(prod.keys()) == EXPECTED_PRODUCT_KEYS, (
                f"Product keys mismatch for '{prod.get('id')}': got {set(prod.keys())}, expected {EXPECTED_PRODUCT_KEYS}"
            )
