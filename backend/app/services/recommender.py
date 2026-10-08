import uuid
from datetime import datetime, timezone
from typing import Any, List, Optional, Sequence, Set, Tuple

from app.repositories.catalog_repository import CatalogRepository
from app.schemas.enums import Availability
from app.schemas.recommendation import (
    Product as ProductSchema,
    RecommendationRequest,
    RecommendationResponse,
    RecommendedCategory,
)


def build_category_reason(
    matched_interests: List[str],
    occasion_matched: bool,
    occasion_name: str,
    relationship_matched: bool,
    relationship_name: str,
    matched_styles: List[str],
) -> str:
    """Builds a human-readable reason sentence without exposing numeric scores."""
    cleaned_interests = [i.replace("_", " ") for i in matched_interests]
    cleaned_occasion = occasion_name.replace("_", " ")
    cleaned_relationship = relationship_name.replace("_", " ")

    if cleaned_interests and occasion_matched:
        if len(cleaned_interests) == 1:
            int_str = f"the {cleaned_interests[0]} interest"
        elif len(cleaned_interests) == 2:
            int_str = f"the {cleaned_interests[0]} and {cleaned_interests[1]} interests"
        else:
            int_str = f"the {', '.join(cleaned_interests[:-1])}, and {cleaned_interests[-1]} interests"
        return f"Matches {int_str} and {cleaned_occasion} occasion."

    if cleaned_interests and relationship_matched:
        int_str = " and ".join(cleaned_interests)
        plural = "interests" if len(cleaned_interests) > 1 else "interest"
        return f"Matches the {int_str} {plural} and is a great gift for {cleaned_relationship}."

    if cleaned_interests and matched_styles:
        int_str = " and ".join(cleaned_interests)
        plural = "interests" if len(cleaned_interests) > 1 else "interest"
        style_str = " and ".join([s.replace("_", " ") for s in matched_styles[:2]])
        return f"Matches the {int_str} {plural} with {style_str} style."

    if cleaned_interests:
        int_str = " and ".join(cleaned_interests)
        plural = "interests" if len(cleaned_interests) > 1 else "interest"
        return f"Matches the {int_str} {plural}."

    if occasion_matched and relationship_matched:
        return f"Popular gift choice for {cleaned_relationship} on {cleaned_occasion}."

    if occasion_matched:
        return f"Matches the {cleaned_occasion} occasion."

    if relationship_matched:
        return f"A thoughtful gift category for {cleaned_relationship}."

    if matched_styles:
        style_str = " and ".join([s.replace("_", " ") for s in matched_styles[:2]])
        return f"Curated {style_str} gift options within your budget."

    return "Curated gift recommendations matching your request."


def _to_product_schema(p: Any) -> ProductSchema:
    """Transforms database or in-memory product object into API Product schema."""
    avail_val = getattr(p, "availability", "in_stock")
    if hasattr(avail_val, "value"):
        avail_enum = avail_val
    else:
        try:
            avail_enum = Availability(str(avail_val))
        except ValueError:
            avail_enum = Availability.unknown

    last_up = getattr(p, "last_updated", None)
    if not last_up:
        last_up = datetime.now(timezone.utc)

    return ProductSchema(
        id=str(getattr(p, "id", "")),
        name=getattr(p, "name", ""),
        description=getattr(p, "description", None),
        price=int(getattr(p, "price", 0)),
        currency=getattr(p, "currency", "PKR") or "PKR",
        image_url=getattr(p, "image_url", None),
        store_name=getattr(p, "store_name", "Daraz"),
        store_url=getattr(p, "store_url", ""),
        category_id=getattr(p, "category_id", ""),
        tags=list(getattr(p, "tags", []) or []),
        availability=avail_enum,
        source=getattr(p, "source", "curated") or "curated",
        last_updated=last_up,
    )


class RecommendationService:
    """Deterministic, pure-logic recommendation service.

    Separated from database queries via repository dependency injection.
    """

    def __init__(self, repository: Optional[CatalogRepository] = None):
        self.repository = repository

    def get_recommendations(
        self,
        request: RecommendationRequest,
        categories_data: Optional[Sequence[Any]] = None,
        request_id: Optional[str] = None,
    ) -> RecommendationResponse:
        """Executes the recommendation pipeline with category qualification rule."""
        resp_id = request_id or str(uuid.uuid4())
        req_budget = request.budget
        req_relationship = (
            request.relationship.value
            if hasattr(request.relationship, "value")
            else str(request.relationship)
        )
        req_occasion = (
            request.occasion.value
            if hasattr(request.occasion, "value")
            else str(request.occasion)
        )
        req_interests = [
            i.value if hasattr(i, "value") else str(i) for i in request.interests
        ]
        req_styles = [
            s.value if hasattr(s, "value") else str(s)
            for s in (request.gift_styles or [])
        ]
        req_gender = (
            request.gender.value
            if (request.gender and hasattr(request.gender, "value"))
            else (str(request.gender) if request.gender else None)
        )
        req_age_group = (
            request.age_group.value
            if hasattr(request.age_group, "value")
            else str(request.age_group)
        )

        # ----------------------------------------------------
        # Step 1: Load active categories and products
        # ----------------------------------------------------
        if categories_data is not None:
            categories = list(categories_data)
        elif self.repository is not None:
            categories = self.repository.get_active_categories_and_products(
                max_budget=req_budget
            )
        else:
            categories = []

        # Check if the request's interests are ONLY "other"
        only_other_interests = len(req_interests) > 0 and all(
            i.lower() == "other" for i in req_interests
        )

        # ----------------------------------------------------
        # Step 2: STRICT BUDGET: Remove products > request budget
        # ----------------------------------------------------
        valid_candidates: List[Tuple[Any, List[Any], int, float, str]] = []

        for cat in categories:
            # Check active status of category
            if not getattr(cat, "is_active", True):
                continue

            raw_prods = getattr(cat, "products", []) or []
            # Double enforce strict budget: price <= budget
            in_budget_prods = [
                p
                for p in raw_prods
                if getattr(p, "is_active", True) and int(getattr(p, "price", 0)) <= req_budget
            ]

            # Remove categories with zero in-budget products
            if len(in_budget_prods) == 0:
                continue

            cat_interests = [
                str(i).lower() for i in (getattr(cat, "related_interests", []) or [])
            ]
            matched_interests = [
                i for i in req_interests if i.lower() in cat_interests
            ]

            # ----------------------------------------------------
            # QUALIFICATION RULE:
            # A category must QUALIFY first: it qualifies only if at least ONE
            # of the request's interests appears in the category's related_interests.
            # Exception: if the request's interests are only "other", skip this
            # qualification rule and use occasion, relationship and style instead.
            # Categories that do not qualify are removed, even if occasion or
            # relationship matches.
            # ----------------------------------------------------
            if not only_other_interests and len(matched_interests) == 0:
                continue

            # ----------------------------------------------------
            # Step 3: Score each QUALIFIED category
            # ----------------------------------------------------
            # +3 for each request interest in category's related_interests
            interest_points = len(matched_interests) * 3

            # +3 if request occasion in category's related_occasions
            cat_occasions = [
                str(o).lower() for o in (getattr(cat, "related_occasions", []) or [])
            ]
            occasion_matched = req_occasion.lower() in cat_occasions
            occasion_points = 3 if occasion_matched else 0

            # +1 if relationship in related_relationships
            cat_relationships = [
                str(r).lower()
                for r in (getattr(cat, "related_relationships", []) or [])
            ]
            relationship_matched = req_relationship.lower() in cat_relationships
            relationship_points = 1 if relationship_matched else 0

            # +1 for each requested gift style found in style_tags (max +2)
            cat_styles = [
                str(s).lower() for s in (getattr(cat, "style_tags", []) or [])
            ]
            matched_styles = [s for s in req_styles if s.lower() in cat_styles]
            style_points = min(len(matched_styles), 2)

            # Small bonus based on how many in-budget products the category has (max +2)
            # 1 product -> +1, >=2 products -> +2
            product_count_bonus = min(len(in_budget_prods), 2)

            total_score = (
                interest_points
                + occasion_points
                + relationship_points
                + style_points
                + product_count_bonus
            )

            # Filter zero score
            if total_score <= 0:
                continue

            # Focus calculation for tie-breaking:
            # (number of the request's interests found in the category's related_interests)
            # divided by (the number of interests in that category's related_interests)
            num_cat_interests = len(cat_interests)
            focus = (
                (len(matched_interests) / num_cat_interests)
                if num_cat_interests > 0
                else 0.0
            )

            # Build human-readable reason (Step 6)
            reason = build_category_reason(
                matched_interests=matched_interests,
                occasion_matched=occasion_matched,
                occasion_name=req_occasion,
                relationship_matched=relationship_matched,
                relationship_name=req_relationship,
                matched_styles=matched_styles,
            )

            valid_candidates.append(
                (cat, in_budget_prods, total_score, focus, reason)
            )

        # ----------------------------------------------------
        # Step 4: Take top 4 by score (ties broken first by focus, then by name)
        # ----------------------------------------------------
        valid_candidates.sort(
            key=lambda item: (-item[2], -item[3], getattr(item[0], "name", ""))
        )
        selected_categories = valid_candidates[:4]

        # Step 7: If no category qualifies, return empty categories list
        if not selected_categories:
            return RecommendationResponse(
                request_id=resp_id,
                budget=req_budget,
                currency="PKR",
                categories=[],
            )

        # ----------------------------------------------------
        # Step 5: Rank in-budget products for each category
        # ----------------------------------------------------
        recommended_categories: List[RecommendedCategory] = []

        for cat, in_budget_prods, _score, _focus, reason in selected_categories:
            def product_rank_key(p: Any) -> Tuple[int, int, str]:
                p_interests = [
                    str(i).lower() for i in (getattr(p, "interests", []) or [])
                ]
                p_tags = [str(t).lower() for t in (getattr(p, "tags", []) or [])]
                all_p_keywords = set(p_interests + p_tags)
                int_matches = sum(
                    1 for ri in req_interests if ri.lower() in all_p_keywords
                )

                p_occasions = [
                    str(o).lower() for o in (getattr(p, "occasions", []) or [])
                ]
                occ_match = 1 if req_occasion.lower() in p_occasions else 0

                p_styles = [
                    str(s).lower() for s in (getattr(p, "styles", []) or [])
                ]
                style_matches = sum(
                    1 for rs in req_styles if rs.lower() in p_styles
                )

                # Gender: only matters if product lists them; never exclude
                p_genders = [
                    str(g).lower() for g in (getattr(p, "genders", []) or [])
                ]
                gender_match = (
                    1
                    if (
                        req_gender
                        and p_genders
                        and req_gender.lower() in p_genders
                    )
                    else 0
                )

                # Age group: only matters if product lists them
                p_age_groups = [
                    str(ag).lower() for ag in (getattr(p, "age_groups", []) or [])
                ]
                age_match = (
                    1
                    if (p_age_groups and req_age_group.lower() in p_age_groups)
                    else 0
                )

                relevance = (
                    (int_matches * 3)
                    + (occ_match * 2)
                    + style_matches
                    + gender_match
                    + age_match
                )
                price = int(getattr(p, "price", 0))
                # Closeness to budget: since price <= budget, budget - price is >= 0
                price_distance = req_budget - price
                p_name = getattr(p, "name", "")

                return (-relevance, price_distance, p_name)

            sorted_prods = sorted(in_budget_prods, key=product_rank_key)
            # Max 12 products per category
            top_prods = sorted_prods[:12]
            serialized_prods = [_to_product_schema(p) for p in top_prods]

            cat_id = str(getattr(cat, "id", ""))
            cat_name = str(getattr(cat, "name", ""))
            cat_icon = getattr(cat, "icon", None)

            recommended_categories.append(
                RecommendedCategory(
                    id=cat_id,
                    name=cat_name,
                    reason=reason,
                    icon=cat_icon,
                    product_count=len(serialized_prods),
                    products=serialized_prods,
                )
            )

        return RecommendationResponse(
            request_id=resp_id,
            budget=req_budget,
            currency="PKR",
            categories=recommended_categories,
        )
