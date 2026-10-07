from datetime import datetime
from typing import List, Optional, Union
from pydantic import BaseModel, ConfigDict, Field

from app.schemas.enums import (
    AgeGroup,
    Availability,
    Gender,
    GiftStyle,
    Interest,
    Occasion,
    Relationship,
)


class RecommendationRequest(BaseModel):
    relationship: Relationship
    age_group: AgeGroup
    gender: Optional[Gender] = None
    occasion: Occasion
    budget: int = Field(ge=500, le=15000, description="Budget in PKR between 500 and 15000")
    interests: List[Interest] = Field(
        min_length=1,
        max_length=6,
        description="List of 1 to 6 interests",
    )
    gift_styles: List[GiftStyle] = Field(
        default_factory=list,
        max_length=4,
        description="List of 0 to 4 gift styles",
    )
    additional_details: Optional[str] = Field(
        default=None,
        max_length=200,
        description="Optional additional details, max 200 characters",
    )

    model_config = ConfigDict(
        extra="forbid",
        str_strip_whitespace=True,
    )


class Product(BaseModel):
    id: str
    name: str
    description: Optional[str] = None
    price: int
    currency: str = "PKR"
    image_url: Optional[str] = None
    store_name: str
    store_url: str
    category_id: str
    tags: List[str] = Field(default_factory=list)
    availability: Availability
    source: str
    last_updated: Union[datetime, str]

    model_config = ConfigDict(
        extra="forbid",
        str_strip_whitespace=True,
        from_attributes=True,
    )


class RecommendedCategory(BaseModel):
    id: str
    name: str
    reason: str
    icon: Optional[str] = None
    product_count: int
    products: List[Product] = Field(default_factory=list)

    model_config = ConfigDict(
        extra="forbid",
        str_strip_whitespace=True,
        from_attributes=True,
    )


class RecommendationResponse(BaseModel):
    request_id: str
    budget: int
    currency: str = "PKR"
    categories: List[RecommendedCategory] = Field(default_factory=list)

    model_config = ConfigDict(
        extra="forbid",
        str_strip_whitespace=True,
    )
