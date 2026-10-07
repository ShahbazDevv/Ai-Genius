import re
from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import List, Optional

import pytest

from app.schemas.enums import (
    AgeGroup,
    Gender,
    GiftStyle,
    Interest,
    Occasion,
    Relationship,
)
from app.schemas.recommendation import RecommendationRequest
from app.services.recommender import RecommendationService


@dataclass
class MockProduct:
    id: str
    name: str
    price: int
    category_id: str
    interests: List[str] = field(default_factory=list)
    tags: List[str] = field(default_factory=list)
    occasions: List[str] = field(default_factory=list)
    age_groups: List[str] = field(default_factory=list)
    genders: List[str] = field(default_factory=list)
    styles: List[str] = field(default_factory=list)
    description: Optional[str] = "Test product description"
    currency: str = "PKR"
    image_url: Optional[str] = "https://example.com/image.jpg"
    store_name: str = "Daraz"
    store_url: str = "https://example.com/product"
    availability: str = "in_stock"
    source: str = "curated"
    is_active: bool = True
    last_updated: datetime = field(default_factory=lambda: datetime.now(timezone.utc))


@dataclass
class MockCategory:
    id: str
    name: str
    related_interests: List[str] = field(default_factory=list)
    related_occasions: List[str] = field(default_factory=list)
    related_relationships: List[str] = field(default_factory=list)
    style_tags: List[str] = field(default_factory=list)
    icon: Optional[str] = "category_icon"
    is_active: bool = True
    products: List[MockProduct] = field(default_factory=list)


def build_mock_catalog() -> List[MockCategory]:
    """Generates a small in-memory catalog with varied categories and price bands."""
    return [
        MockCategory(
            id="skincare_gift_set",
            name="Skincare Gift Set",
            related_interests=["skincare", "beauty"],
            related_occasions=["birthday", "eid", "anniversary"],
            related_relationships=["mother", "sister", "partner"],
            style_tags=["self_care", "elegant", "practical"],
            icon="spa",
            products=[
                MockProduct(
                    id="skin-1",
                    name="Daily Foam Cleanser Duo",
                    price=850,
                    category_id="skincare_gift_set",
                    interests=["skincare", "beauty"],
                    occasions=["birthday", "eid"],
                    age_groups=["40_49", "30_39"],
                    genders=["female"],
                    styles=["practical", "self_care"],
                ),
                MockProduct(
                    id="skin-2",
                    name="4-Step Whitening Facial Kit",
                    price=2499,
                    category_id="skincare_gift_set",
                    interests=["skincare", "beauty"],
                    occasions=["birthday", "eid", "wedding"],
                    age_groups=["40_49", "25_29"],
                    genders=["female"],
                    styles=["elegant", "self_care"],
                ),
                MockProduct(
                    id="skin-3",
                    name="Vitamin C 6-Step Facial Kit",
                    price=4499,
                    category_id="skincare_gift_set",
                    interests=["skincare"],
                    occasions=["birthday", "anniversary"],
                    styles=["luxury", "self_care"],
                ),
                MockProduct(
                    id="skin-4",
                    name="Luxury Bird Nest Skincare Routine Set",
                    price=8211,
                    category_id="skincare_gift_set",
                    interests=["skincare", "beauty"],
                    occasions=["wedding", "anniversary"],
                    styles=["luxury"],
                ),
            ],
        ),
        MockCategory(
            id="beauty_gift_set",
            name="Beauty Gift Set",
            related_interests=["beauty", "makeup", "fashion"],
            related_occasions=["birthday", "wedding", "eid"],
            related_relationships=["sister", "partner", "friend"],
            style_tags=["elegant", "luxury", "fun"],
            icon="brush",
            products=[
                MockProduct(
                    id="beauty-1",
                    name="Bridal Makeup Set",
                    price=899,
                    category_id="beauty_gift_set",
                    interests=["beauty", "makeup"],
                    occasions=["birthday", "wedding"],
                    genders=["female"],
                    styles=["practical"],
                ),
                MockProduct(
                    id="beauty-2",
                    name="13-in-1 Complete Glam Vanity Kit",
                    price=2399,
                    category_id="beauty_gift_set",
                    interests=["beauty", "makeup"],
                    occasions=["birthday", "eid"],
                    genders=["female"],
                    styles=["elegant"],
                ),
                MockProduct(
                    id="beauty-3",
                    name="Pro 190 Color Palette Vanity Case",
                    price=6799,
                    category_id="beauty_gift_set",
                    interests=["beauty", "makeup"],
                    styles=["luxury"],
                ),
            ],
        ),
        MockCategory(
            id="self_care_hamper",
            name="Self Care Hamper",
            related_interests=["beauty", "skincare", "home_lifestyle"],
            related_occasions=["birthday", "thank_you", "anniversary"],
            related_relationships=["mother", "sister", "friend", "partner"],
            style_tags=["self_care", "sentimental", "practical"],
            icon="bath",
            products=[
                MockProduct(
                    id="selfcare-1",
                    name="Organic Lavender Bath & Body Box",
                    price=799,
                    category_id="self_care_hamper",
                    interests=["skincare", "beauty"],
                    occasions=["birthday", "thank_you"],
                    styles=["self_care", "practical"],
                ),
                MockProduct(
                    id="selfcare-2",
                    name="Royal Rose Oud Relaxation Gift Basket",
                    price=3411,
                    category_id="self_care_hamper",
                    interests=["beauty", "home_lifestyle"],
                    occasions=["birthday", "anniversary"],
                    styles=["self_care", "elegant"],
                ),
                MockProduct(
                    id="selfcare-3",
                    name="Grooming Self-Care Kit",
                    price=9000,
                    category_id="self_care_hamper",
                    interests=["home_lifestyle"],
                    styles=["practical"],
                ),
            ],
        ),
        MockCategory(
            id="tech_gadgets",
            name="Tech Gadgets",
            related_interests=["technology", "computer_gadgets", "gaming"],
            related_occasions=["birthday", "graduation", "eid"],
            related_relationships=["brother", "friend", "colleague"],
            style_tags=["practical", "fun", "minimal"],
            icon="devices",
            products=[
                MockProduct(
                    id="tech-1",
                    name="Portable Travel Cable Organizer",
                    price=729,
                    category_id="tech_gadgets",
                    interests=["technology"],
                    occasions=["birthday", "graduation"],
                    styles=["practical"],
                ),
                MockProduct(
                    id="tech-2",
                    name="JBL M3 Mini Bluetooth Speaker",
                    price=1450,
                    category_id="tech_gadgets",
                    interests=["technology", "computer_gadgets"],
                    occasions=["birthday", "eid"],
                    styles=["practical", "fun"],
                ),
                MockProduct(
                    id="tech-3",
                    name="Fast Wireless Charging Pad",
                    price=1500,
                    category_id="tech_gadgets",
                    interests=["technology"],
                    occasions=["birthday", "graduation"],
                    styles=["minimal", "practical"],
                ),
                MockProduct(
                    id="tech-4",
                    name="Stereo Headset with Mic",
                    price=4099,
                    category_id="tech_gadgets",
                    interests=["technology"],
                    styles=["practical"],
                ),
            ],
        ),
        MockCategory(
            id="mobile_accessories_bundle",
            name="Mobile Accessories Bundle",
            related_interests=["mobile_accessories", "technology"],
            related_occasions=["birthday", "graduation", "thank_you", "eid"],
            related_relationships=["brother", "sister", "friend", "colleague"],
            style_tags=["practical", "budget_friendly", "minimal"],
            icon="smartphone",
            products=[
                MockProduct(
                    id="mob-1",
                    name="45W Fast Charger with 4-in-1 Cable",
                    price=1145,
                    category_id="mobile_accessories_bundle",
                    interests=["mobile_accessories", "technology"],
                    occasions=["birthday", "thank_you"],
                    styles=["practical", "budget_friendly"],
                ),
                MockProduct(
                    id="mob-2",
                    name="Xiaomi 120W HyperCharge Fast Combo",
                    price=2545,
                    category_id="mobile_accessories_bundle",
                    interests=["mobile_accessories", "technology"],
                    occasions=["birthday", "graduation"],
                    styles=["practical"],
                ),
                MockProduct(
                    id="mob-3",
                    name="4-in-1 Tech Travel Organizer Pouch",
                    price=9190,
                    category_id="mobile_accessories_bundle",
                    interests=["mobile_accessories"],
                    styles=["practical"],
                ),
            ],
        ),
        MockCategory(
            id="book_bundle",
            name="Book Bundle",
            related_interests=["books", "art_crafts"],
            related_occasions=["birthday", "graduation", "thank_you"],
            related_relationships=["friend", "teacher", "partner"],
            style_tags=["sentimental", "practical", "minimal"],
            icon="menu_book",
            products=[
                MockProduct(
                    id="book-0",
                    name="Mini Pocket Poetry Booklet",
                    price=500,
                    category_id="book_bundle",
                    interests=["books"],
                    occasions=["thank_you", "birthday"],
                    styles=["minimal", "sentimental"],
                ),
                MockProduct(
                    id="book-1",
                    name="Pack of 6 Self Help Best Sellers",
                    price=799,
                    category_id="book_bundle",
                    interests=["books"],
                    occasions=["birthday", "graduation"],
                    styles=["practical"],
                ),
                MockProduct(
                    id="book-2",
                    name="Collector Manga Collection",
                    price=2999,
                    category_id="book_bundle",
                    interests=["books", "art_crafts"],
                    occasions=["birthday"],
                    styles=["fun"],
                ),
            ],
        ),
        MockCategory(
            id="cricket_gear",
            name="Cricket Gear",
            related_interests=["cricket", "sports"],
            related_occasions=["birthday", "eid", "graduation"],
            related_relationships=["brother", "father", "friend"],
            style_tags=["practical", "fun", "budget_friendly"],
            icon="sports_cricket",
            products=[
                MockProduct(
                    id="crick-1",
                    name="Saki Sports Tape Ball Cricket Bat",
                    price=1049,
                    category_id="cricket_gear",
                    interests=["cricket", "sports"],
                    occasions=["birthday", "eid"],
                    styles=["fun", "practical"],
                ),
                MockProduct(
                    id="crick-2",
                    name="Duffle Kit Bag with Bat Pocket",
                    price=1559,
                    category_id="cricket_gear",
                    interests=["cricket", "sports"],
                    occasions=["birthday"],
                    styles=["practical"],
                ),
            ],
        ),
        MockCategory(
            id="home_decor_gift",
            name="Home Decor Gift",
            related_interests=["home_lifestyle", "art_crafts"],
            related_occasions=["wedding", "anniversary", "eid", "thank_you"],
            related_relationships=["mother", "friend", "teacher", "colleague"],
            style_tags=["elegant", "sentimental", "minimal"],
            icon="home",
            products=[
                MockProduct(
                    id="decor-1",
                    name="Wooden Sweet Home Hanging Art",
                    price=599,
                    category_id="home_decor_gift",
                    interests=["home_lifestyle", "art_crafts"],
                    occasions=["wedding", "thank_you"],
                    styles=["sentimental"],
                ),
                MockProduct(
                    id="decor-2",
                    name="Hand-Painted Flower Wall Hanging",
                    price=2650,
                    category_id="home_decor_gift",
                    interests=["home_lifestyle"],
                    occasions=["wedding", "anniversary"],
                    styles=["elegant"],
                ),
            ],
        ),
        MockCategory(
            id="gaming_accessories",
            name="Gaming Accessories",
            related_interests=["gaming", "technology"],
            related_occasions=["birthday", "graduation", "eid"],
            related_relationships=["brother", "friend"],
            style_tags=["fun", "practical"],
            icon="sports_esports",
            products=[
                MockProduct(
                    id="game-1",
                    name="RGB 7-Color Gaming Mouse",
                    price=579,
                    category_id="gaming_accessories",
                    interests=["gaming"],
                    occasions=["birthday"],
                    styles=["fun"],
                ),
                MockProduct(
                    id="game-2",
                    name="Stereo Gaming Headphones",
                    price=1572,
                    category_id="gaming_accessories",
                    interests=["gaming", "technology"],
                    occasions=["birthday", "graduation"],
                    styles=["fun", "practical"],
                ),
            ],
        ),
    ]


@pytest.fixture
def in_memory_catalog() -> List[MockCategory]:
    return build_mock_catalog()


# ==============================================================================
# (a) Mother, 40_49, birthday, PKR 3500, beauty+skincare returns only products <= 3500
# ==============================================================================
def test_a_mother_birthday_budget_strictness(in_memory_catalog):
    service = RecommendationService()
    req = RecommendationRequest(
        relationship=Relationship.mother,
        age_group=AgeGroup.age_40_49,
        gender=Gender.female,
        occasion=Occasion.birthday,
        budget=3500,
        interests=[Interest.beauty, Interest.skincare],
        gift_styles=[GiftStyle.elegant, GiftStyle.practical],
    )

    resp = service.get_recommendations(req, categories_data=in_memory_catalog)

    assert len(resp.categories) > 0
    assert resp.budget == 3500
    assert resp.currency == "PKR"

    # Strict budget assertion on every single product
    for cat in resp.categories:
        assert cat.product_count == len(cat.products)
        assert len(cat.products) > 0
        for p in cat.products:
            assert p.price <= 3500, f"Product {p.name} has price {p.price} > 3500"

        # Check reason is human readable and has NO numeric scores
        assert not re.search(r"\b\d+\b", cat.reason), f"Reason exposed numeric score: {cat.reason}"

    # Verify top category is relevant to skincare or beauty
    top_cat = resp.categories[0]
    assert top_cat.id in ["skincare_gift_set", "beauty_gift_set"]
    assert "skincare" in top_cat.reason.lower() or "beauty" in top_cat.reason.lower()


# ==============================================================================
# (b) PKR 500 returns only products <= 500 or an empty list
# ==============================================================================
def test_b_low_budget_returns_only_in_budget_or_empty(in_memory_catalog):
    service = RecommendationService()
    # Case 1: When products <= 500 exist, only products <= 500 are returned
    req1 = RecommendationRequest(
        relationship=Relationship.friend,
        age_group=AgeGroup.age_25_29,
        occasion=Occasion.birthday,
        budget=500,
        interests=[Interest.books],
    )
    resp1 = service.get_recommendations(req1, categories_data=in_memory_catalog)
    assert len(resp1.categories) > 0
    for cat in resp1.categories:
        assert len(cat.products) > 0
        for p in cat.products:
            assert p.price <= 500

    # Case 2: When no product <= 500 exists across eligible categories, empty list is returned
    catalog_no_cheap = [
        cat for cat in in_memory_catalog
        if not any(p.price <= 500 for p in cat.products)
    ]
    req2 = RecommendationRequest(
        relationship=Relationship.friend,
        age_group=AgeGroup.age_20_24,
        occasion=Occasion.birthday,
        budget=500,
        interests=[Interest.technology],
    )
    resp2 = service.get_recommendations(req2, categories_data=catalog_no_cheap)
    assert resp2.categories == []


# ==============================================================================
# (c) Different occasions give different category order for the same interests
# ==============================================================================
def test_c_different_occasions_produce_different_category_ranking(in_memory_catalog):
    service = RecommendationService()
    interests = [Interest.art_crafts]

    # Occasion: wedding -> home_decor_gift has wedding, book_bundle does not
    req_wedding = RecommendationRequest(
        relationship=Relationship.friend,
        age_group=AgeGroup.age_25_29,
        occasion=Occasion.wedding,
        budget=5000,
        interests=interests,
    )
    resp_wedding = service.get_recommendations(req_wedding, categories_data=in_memory_catalog)

    # Occasion: graduation -> book_bundle has graduation, home_decor_gift does not
    req_grad = RecommendationRequest(
        relationship=Relationship.friend,
        age_group=AgeGroup.age_25_29,
        occasion=Occasion.graduation,
        budget=5000,
        interests=interests,
    )
    resp_grad = service.get_recommendations(req_grad, categories_data=in_memory_catalog)

    wedding_cats = [c.id for c in resp_wedding.categories]
    grad_cats = [c.id for c in resp_grad.categories]

    assert wedding_cats != grad_cats
    assert wedding_cats[0] == "home_decor_gift"
    assert grad_cats[0] == "book_bundle"


# ==============================================================================
# (d) Different interests give different top categories
# ==============================================================================
def test_d_different_interests_produce_different_top_categories(in_memory_catalog):
    service = RecommendationService()

    # Interest 1: Technology + Gaming -> top is tech_gadgets
    req_tech = RecommendationRequest(
        relationship=Relationship.colleague,
        age_group=AgeGroup.age_30_39,
        occasion=Occasion.birthday,
        budget=3000,
        interests=[Interest.technology, Interest.computer_gadgets, Interest.gaming],
    )
    resp_tech = service.get_recommendations(req_tech, categories_data=in_memory_catalog)

    # Interest 2: Cricket + Sports -> top is cricket_gear
    req_cricket = RecommendationRequest(
        relationship=Relationship.brother,
        age_group=AgeGroup.age_20_24,
        occasion=Occasion.birthday,
        budget=3000,
        interests=[Interest.cricket, Interest.sports],
    )
    resp_cricket = service.get_recommendations(req_cricket, categories_data=in_memory_catalog)

    # Interest 3: Books -> top is book_bundle
    req_books = RecommendationRequest(
        relationship=Relationship.teacher,
        age_group=AgeGroup.age_40_49,
        occasion=Occasion.thank_you,
        budget=3000,
        interests=[Interest.books],
    )
    resp_books = service.get_recommendations(req_books, categories_data=in_memory_catalog)

    assert resp_tech.categories[0].id == "tech_gadgets"
    assert resp_cricket.categories[0].id == "cricket_gear"
    assert resp_books.categories[0].id == "book_bundle"


# ==============================================================================
# (e) Results are never the same 4 categories for every input (test 6 different inputs)
# ==============================================================================
def test_e_varied_inputs_never_return_same_categories(in_memory_catalog):
    service = RecommendationService()

    inputs = [
        RecommendationRequest(
            relationship=Relationship.mother,
            age_group=AgeGroup.age_40_49,
            occasion=Occasion.birthday,
            budget=3500,
            interests=[Interest.beauty, Interest.skincare],
        ),
        RecommendationRequest(
            relationship=Relationship.brother,
            age_group=AgeGroup.age_20_24,
            occasion=Occasion.birthday,
            budget=5000,
            interests=[Interest.gaming, Interest.technology],
        ),
        RecommendationRequest(
            relationship=Relationship.friend,
            age_group=AgeGroup.age_25_29,
            occasion=Occasion.graduation,
            budget=3000,
            interests=[Interest.books],
        ),
        RecommendationRequest(
            relationship=Relationship.father,
            age_group=AgeGroup.age_50_plus,
            occasion=Occasion.eid,
            budget=4000,
            interests=[Interest.cricket, Interest.sports],
        ),
        RecommendationRequest(
            relationship=Relationship.colleague,
            age_group=AgeGroup.age_30_39,
            occasion=Occasion.thank_you,
            budget=3000,
            interests=[Interest.mobile_accessories, Interest.technology],
        ),
        RecommendationRequest(
            relationship=Relationship.partner,
            age_group=AgeGroup.age_25_29,
            occasion=Occasion.anniversary,
            budget=5000,
            interests=[Interest.home_lifestyle],
        ),
    ]

    results = []
    for req in inputs:
        resp = service.get_recommendations(req, categories_data=in_memory_catalog)
        cat_ids = tuple(c.id for c in resp.categories)
        results.append(cat_ids)

    # Assert results are distinct across distinct inputs
    unique_category_sets = set(results)
    assert len(unique_category_sets) >= 5, f"Expected varied outputs, got {len(unique_category_sets)} unique sets"


# ==============================================================================
# (f) Results are stable and deterministic across repeated calls
# ==============================================================================
def test_f_deterministic_and_stable_across_repeated_calls(in_memory_catalog):
    service = RecommendationService()
    req = RecommendationRequest(
        relationship=Relationship.mother,
        age_group=AgeGroup.age_40_49,
        gender=Gender.female,
        occasion=Occasion.birthday,
        budget=3500,
        interests=[Interest.beauty, Interest.skincare],
        gift_styles=[GiftStyle.elegant, GiftStyle.practical],
    )

    baseline_resp = service.get_recommendations(req, categories_data=in_memory_catalog)

    for _ in range(5):
        repeat_resp = service.get_recommendations(req, categories_data=in_memory_catalog)
        assert len(repeat_resp.categories) == len(baseline_resp.categories)
        for cat_repeat, cat_base in zip(repeat_resp.categories, baseline_resp.categories):
            assert cat_repeat.id == cat_base.id
            assert cat_repeat.name == cat_base.name
            assert cat_repeat.reason == cat_base.reason
            assert cat_repeat.product_count == cat_base.product_count
            assert [p.id for p in cat_repeat.products] == [p.id for p in cat_base.products]
            assert [p.price for p in cat_repeat.products] == [p.price for p in cat_base.products]


# ==============================================================================
# New Rule Tests: Category Qualification, No Unmatched Interests, and "Other" Exception
# ==============================================================================
def test_mother_birthday_does_not_return_book_bundle(in_memory_catalog):
    """Mother, 40_49, birthday, PKR 3500, beauty+skincare must NOT return book_bundle.

    book_bundle has birthday in related_occasions, but does NOT have beauty or
    skincare in related_interests, so it must not qualify.
    """
    service = RecommendationService()
    req = RecommendationRequest(
        relationship=Relationship.mother,
        age_group=AgeGroup.age_40_49,
        gender=Gender.female,
        occasion=Occasion.birthday,
        budget=3500,
        interests=[Interest.beauty, Interest.skincare],
        gift_styles=[GiftStyle.elegant, GiftStyle.practical],
    )

    resp = service.get_recommendations(req, categories_data=in_memory_catalog)
    cat_ids = [c.id for c in resp.categories]

    assert "book_bundle" not in cat_ids
    # Only categories matching beauty or skincare should be returned
    assert len(cat_ids) > 0
    cat_lookup = {c.id: c for c in in_memory_catalog}
    for cid in cat_ids:
        cat_obj = cat_lookup[cid]
        assert any(
            i in cat_obj.related_interests for i in ["beauty", "skincare"]
        ), f"Category {cid} does not match beauty or skincare"


def test_no_returned_category_lacks_interest_match(in_memory_catalog):
    """Ensures that no returned category lacks an interest match across various inputs."""
    service = RecommendationService()
    test_cases = [
        [Interest.cricket],
        [Interest.books],
        [Interest.gaming, Interest.technology],
        [Interest.home_lifestyle],
    ]

    cat_lookup = {c.id: c for c in in_memory_catalog}

    for req_interests in test_cases:
        req = RecommendationRequest(
            relationship=Relationship.friend,
            age_group=AgeGroup.age_25_29,
            occasion=Occasion.birthday,
            budget=4000,
            interests=req_interests,
        )
        resp = service.get_recommendations(req, categories_data=in_memory_catalog)
        assert len(resp.categories) > 0

        req_interest_values = [i.value for i in req_interests]
        for cat in resp.categories:
            cat_obj = cat_lookup[cat.id]
            has_match = any(
                ri in cat_obj.related_interests for ri in req_interest_values
            )
            assert has_match, (
                f"Returned category {cat.id} lacks an interest match for {req_interest_values}. "
                f"Category interests: {cat_obj.related_interests}"
            )


def test_other_interest_exception_allows_occasion_and_relationship_matches(in_memory_catalog):
    """When interests are only 'other', the interest qualification rule is skipped.

    Categories should be scored and returned using occasion, relationship, style,
    and product count instead.
    """
    service = RecommendationService()
    req = RecommendationRequest(
        relationship=Relationship.mother,
        age_group=AgeGroup.age_40_49,
        gender=Gender.female,
        occasion=Occasion.birthday,
        budget=3500,
        interests=[Interest.other],
        gift_styles=[GiftStyle.self_care, GiftStyle.practical],
    )

    resp = service.get_recommendations(req, categories_data=in_memory_catalog)

    # Categories should qualify based on occasion=birthday, relationship=mother, style=self_care/practical
    assert len(resp.categories) > 0
    assert resp.budget == 3500

    # Strict budget must still hold
    for cat in resp.categories:
        assert len(cat.products) > 0
        for p in cat.products:
            assert p.price <= 3500

    # Check that categories were selected by occasion/relationship
    cat_ids = [c.id for c in resp.categories]
    assert any(
        cid in cat_ids for cid in ["skincare_gift_set", "self_care_hamper", "beauty_gift_set"]
    )


def test_focus_tie_break_skincare_over_selfcare_hamper(in_memory_catalog):
    """When skincare_gift_set and self_care_hamper both qualify and have equal scores,

    skincare_gift_set comes first because of higher focus:
    - skincare_gift_set: 2/2 = 1.0 focus
    - self_care_hamper: 2/3 = ~0.667 focus
    Without focus, 'Self Care Hamper' would precede 'Skincare Gift Set' alphabetically.
    """
    service = RecommendationService()
    req = RecommendationRequest(
        relationship=Relationship.mother,
        age_group=AgeGroup.age_40_49,
        gender=Gender.female,
        occasion=Occasion.birthday,
        budget=3500,
        interests=[Interest.beauty, Interest.skincare],
        gift_styles=[GiftStyle.self_care, GiftStyle.practical],
    )

    resp = service.get_recommendations(req, categories_data=in_memory_catalog)
    cat_ids = [c.id for c in resp.categories]

    # Both categories qualify
    assert "skincare_gift_set" in cat_ids
    assert "self_care_hamper" in cat_ids

    # skincare_gift_set must come first
    assert resp.categories[0].id == "skincare_gift_set"
    assert cat_ids.index("skincare_gift_set") < cat_ids.index("self_care_hamper")


