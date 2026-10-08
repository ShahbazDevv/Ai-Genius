import uuid
from unittest.mock import MagicMock, patch
import pytest
from fastapi.testclient import TestClient
from sqlalchemy.exc import OperationalError

from app.main import app

client = TestClient(app)


# ==============================================================================
# 1. Valid Recommendations Request & CORS
# ==============================================================================
def test_recommendations_valid_request():
    payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "gender": "female",
        "occasion": "birthday",
        "budget": 3500,
        "interests": ["beauty", "skincare"],
        "gift_styles": ["elegant", "practical"],
        "additional_details": "She likes simple skincare products.",
    }
    response = client.post("/api/v1/recommendations", json=payload)
    assert response.status_code == 200
    data = response.json()

    assert "request_id" in data
    assert uuid.UUID(data["request_id"])  # Valid UUID
    assert data["budget"] == 3500
    assert data["currency"] == "PKR"
    assert isinstance(data["categories"], list)
    assert len(data["categories"]) > 0

    # Header check
    assert "x-request-id" in response.headers
    assert response.headers["x-request-id"] == data["request_id"]

    for cat in data["categories"]:
        assert "id" in cat
        assert "name" in cat
        assert "reason" in cat
        assert "products" in cat
        for p in cat["products"]:
            assert p["price"] <= 3500


def test_cors_credentials_false():
    """Confirms CORS header has allow_credentials=False."""
    response = client.options(
        "/api/v1/recommendations",
        headers={
            "Origin": "http://localhost:3000",
            "Access-Control-Request-Method": "POST",
        },
    )
    # allow_credentials=False means access-control-allow-credentials is not 'true'
    assert response.headers.get("access-control-allow-credentials") != "true"


# ==============================================================================
# 2. Request ID Validation (Valid UUID vs Invalid UUID)
# ==============================================================================
def test_request_id_accepted_when_valid_uuid():
    client_uuid = str(uuid.uuid4())
    payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "occasion": "birthday",
        "budget": 3500,
        "interests": ["beauty"],
    }
    response = client.post(
        "/api/v1/recommendations",
        json=payload,
        headers={"X-Request-ID": client_uuid},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["request_id"] == client_uuid
    assert response.headers["x-request-id"] == client_uuid


def test_request_id_regenerated_when_invalid_uuid():
    raw_invalid_id = "malicious_or_non_uuid_string_12345"
    payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "occasion": "birthday",
        "budget": 3500,
        "interests": ["beauty"],
    }
    response = client.post(
        "/api/v1/recommendations",
        json=payload,
        headers={"X-Request-ID": raw_invalid_id},
    )
    assert response.status_code == 200
    data = response.json()
    # Must NOT echo back the raw client string
    assert data["request_id"] != raw_invalid_id
    assert response.headers["x-request-id"] != raw_invalid_id
    # Must be a freshly generated valid UUID
    assert uuid.UUID(data["request_id"])
    assert uuid.UUID(response.headers["x-request-id"])


# ==============================================================================
# 3. GET /api/v1/products/{product_id}
# ==============================================================================
def test_get_product_by_id_success():
    rec_resp = client.post(
        "/api/v1/recommendations",
        json={
            "relationship": "friend",
            "age_group": "20_24",
            "occasion": "eid",
            "budget": 5000,
            "interests": ["gaming"],
        },
    )
    assert rec_resp.status_code == 200
    categories = rec_resp.json()["categories"]
    assert len(categories) > 0
    first_product = categories[0]["products"][0]
    prod_id = first_product["id"]

    prod_resp = client.get(f"/api/v1/products/{prod_id}")
    assert prod_resp.status_code == 200
    prod_data = prod_resp.json()

    assert prod_data["id"] == prod_id
    assert prod_data["name"] == first_product["name"]
    assert prod_data["price"] == first_product["price"]
    assert prod_data["store_url"] == first_product["store_url"]
    assert "x-request-id" in prod_resp.headers


def test_get_product_by_id_invalid_uuid_returns_404_contract_format():
    """Non-UUID product_id must return 404 with NOT_FOUND format, never 500 or detail."""
    response = client.get("/api/v1/products/not-a-valid-uuid-12345")
    assert response.status_code == 404
    data = response.json()

    assert "detail" not in data
    assert "error" in data
    assert data["error"]["code"] == "NOT_FOUND"
    assert data["error"]["message"] == "Product not found"


def test_get_product_by_id_not_found_valid_uuid():
    random_uuid = str(uuid.uuid4())
    response = client.get(f"/api/v1/products/{random_uuid}")
    assert response.status_code == 404
    data = response.json()

    assert "detail" not in data
    assert "error" in data
    assert data["error"]["code"] == "NOT_FOUND"
    assert data["error"]["message"] == "Product not found"


# ==============================================================================
# 4. Request Body Size Limit (> 64 KB) -> HTTP 413
# ==============================================================================
def test_recommendations_body_size_limit_returns_413():
    """Bodies > 64 KB return HTTP 413 with VALIDATION_ERROR and 'Request is too large'."""
    large_payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "occasion": "birthday",
        "budget": 3500,
        "interests": ["beauty"],
        "extra_padding": "X" * (70 * 1024),  # > 64 KB
    }
    response = client.post("/api/v1/recommendations", json=large_payload)
    assert response.status_code == 413
    data = response.json()

    assert "detail" not in data
    assert "error" in data
    assert data["error"]["code"] == "VALIDATION_ERROR"
    assert data["error"]["message"] == "Request is too large"


# ==============================================================================
# 5. Contract Error Format for All Standard HTTP Errors (404, 405, 429, 500)
# ==============================================================================
def test_error_format_404_unknown_route():
    """Unknown routes return 404 with contract error format, never FastAPI's default."""
    response = client.get("/api/v1/totally_unknown_route_404")
    assert response.status_code == 404
    data = response.json()

    assert "detail" not in data
    assert "error" in data
    assert data["error"]["code"] == "NOT_FOUND"
    assert data["error"]["message"] == "Not Found"


def test_error_format_405_wrong_method():
    """Wrong method returns 405 with contract error format, never FastAPI's default."""
    response = client.get("/api/v1/recommendations")
    assert response.status_code == 405
    data = response.json()

    assert "detail" not in data
    assert "error" in data
    assert data["error"]["code"] == "METHOD_NOT_ALLOWED"
    assert data["error"]["message"] == "Method Not Allowed"


def test_error_format_422_validation_error():
    """Validation errors return 422 with contract error format and clean message."""
    response = client.post(
        "/api/v1/recommendations",
        json={
            "relationship": "mother",
            "age_group": "40_49",
            "occasion": "birthday",
            "budget": 200,  # Below 500
            "interests": ["beauty"],
        },
    )
    assert response.status_code == 422
    data = response.json()

    assert "detail" not in data
    assert "error" in data
    assert data["error"]["code"] == "VALIDATION_ERROR"
    assert "budget" in data["error"]["message"]


def test_error_format_500_internal_error():
    """Unhandled server errors return 500 with generic message and no stack traces."""
    client_no_raise = TestClient(app, raise_server_exceptions=False)
    with patch(
        "app.api.v1.recommendations.RecommendationService.get_recommendations",
        side_effect=RuntimeError("Secret unexpected crash"),
    ):
        response = client_no_raise.post(
            "/api/v1/recommendations",
            json={
                "relationship": "mother",
                "age_group": "40_49",
                "occasion": "birthday",
                "budget": 3500,
                "interests": ["beauty"],
            },
        )
        assert response.status_code == 500
        data = response.json()

        assert "detail" not in data
        assert "error" in data
        assert data["error"]["code"] == "INTERNAL_ERROR"
        assert data["error"]["message"] == "An internal server error occurred."
        # Ensure secret crash info is not leaked to client
        assert "Secret unexpected crash" not in str(data)


def test_database_error_returns_503():
    with patch(
        "app.repositories.catalog_repository.CatalogRepository.get_active_categories_and_products",
        side_effect=OperationalError("connection failed", params=None, orig=Exception("DB down")),
    ):
        response = client.post(
            "/api/v1/recommendations",
            json={
                "relationship": "mother",
                "age_group": "40_49",
                "occasion": "birthday",
                "budget": 3500,
                "interests": ["beauty"],
            },
        )
        assert response.status_code == 503
        data = response.json()
        assert "detail" not in data
        assert "error" in data
        assert data["error"]["code"] == "DATABASE_ERROR"
        assert "Database is temporarily unavailable" in data["error"]["message"]
        # Ensure no SQL, connection string, or traceback is exposed
        assert "connection failed" not in data["error"]["message"]
        assert "DB down" not in data["error"]["message"]


# ==============================================================================
# 6. Rate Limiting Test (35 requests -> 31st+ returns 429 RATE_LIMITED)
# ==============================================================================
def test_rate_limiting_35_requests():
    """Sends 35 quick requests to POST /api/v1/recommendations, confirming 31st or later

    returns 429 RATE_LIMITED in contract format. Resets the limiter afterwards.
    """
    from app.core.limiter import limiter

    payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "occasion": "birthday",
        "budget": 3500,
        "interests": ["beauty"],
    }

    try:
        rate_limited_response = None
        for i in range(35):
            resp = client.post("/api/v1/recommendations", json=payload)
            if resp.status_code == 429:
                rate_limited_response = resp
                break

        assert rate_limited_response is not None, "Expected request 31+ to trigger 429"
        data = rate_limited_response.json()

        assert "detail" not in data
        assert "error" in data
        assert data["error"]["code"] == "RATE_LIMITED"
        assert "Rate limit exceeded" in data["error"]["message"]
    finally:
        limiter.reset()


def test_recommendations_matches_nothing():
    # Budget 500 where no qualifying items exist below PKR 500
    payload = {
        "relationship": "mother",
        "age_group": "40_49",
        "gender": "female",
        "occasion": "birthday",
        "budget": 500,
        "interests": ["beauty", "skincare"],
    }
    response = client.post("/api/v1/recommendations", json=payload)
    assert response.status_code == 200
    data = response.json()

    assert "request_id" in data
    assert data["budget"] == 500
    assert data["currency"] == "PKR"
    assert data["categories"] == []
