import pytest
from pydantic import ValidationError

from app.schemas import (
    AgeGroup,
    Gender,
    GiftStyle,
    Interest,
    Occasion,
    RecommendationRequest,
    Relationship,
)


def get_valid_payload() -> dict:
    return {
        "relationship": "mother",
        "age_group": "40_49",
        "gender": "female",
        "occasion": "birthday",
        "budget": 3500,
        "interests": ["beauty", "skincare"],
        "gift_styles": ["elegant", "practical"],
        "additional_details": "  She likes simple skincare products.  ",
    }


def test_valid_request():
    payload = get_valid_payload()
    req = RecommendationRequest(**payload)

    assert req.relationship == Relationship.mother
    assert req.age_group == AgeGroup.age_40_49
    assert req.gender == Gender.female
    assert req.occasion == Occasion.birthday
    assert req.budget == 3500
    assert req.interests == [Interest.beauty, Interest.skincare]
    assert req.gift_styles == [GiftStyle.elegant, GiftStyle.practical]
    # Verify whitespace stripping on text
    assert req.additional_details == "She likes simple skincare products."


def test_budget_too_low():
    payload = get_valid_payload()
    payload["budget"] = 499

    with pytest.raises(ValidationError) as exc_info:
        RecommendationRequest(**payload)

    errors = exc_info.value.errors()
    assert any(err["loc"] == ("budget",) for err in errors)


def test_budget_too_high():
    payload = get_valid_payload()
    payload["budget"] = 15001

    with pytest.raises(ValidationError) as exc_info:
        RecommendationRequest(**payload)

    errors = exc_info.value.errors()
    assert any(err["loc"] == ("budget",) for err in errors)


def test_unknown_interest():
    payload = get_valid_payload()
    payload["interests"] = ["beauty", "flying_cars"]

    with pytest.raises(ValidationError) as exc_info:
        RecommendationRequest(**payload)

    errors = exc_info.value.errors()
    assert any("interests" in err["loc"] for err in errors)


def test_empty_interests():
    payload = get_valid_payload()
    payload["interests"] = []

    with pytest.raises(ValidationError) as exc_info:
        RecommendationRequest(**payload)

    errors = exc_info.value.errors()
    assert any("interests" in err["loc"] for err in errors)


def test_reject_extra_fields():
    payload = get_valid_payload()
    payload["extra_unknown_field"] = "not_allowed"

    with pytest.raises(ValidationError) as exc_info:
        RecommendationRequest(**payload)

    errors = exc_info.value.errors()
    assert any(err["loc"] == ("extra_unknown_field",) for err in errors)


def test_gift_styles_max_items():
    payload = get_valid_payload()
    payload["gift_styles"] = ["practical", "elegant", "luxury", "fun", "minimal"]  # 5 items

    with pytest.raises(ValidationError) as exc_info:
        RecommendationRequest(**payload)

    errors = exc_info.value.errors()
    assert any("gift_styles" in err["loc"] for err in errors)


def test_additional_details_max_length():
    payload = get_valid_payload()
    payload["additional_details"] = "x" * 201

    with pytest.raises(ValidationError) as exc_info:
        RecommendationRequest(**payload)

    errors = exc_info.value.errors()
    assert any("additional_details" in err["loc"] for err in errors)
