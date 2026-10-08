import sys
from pathlib import Path

# Set up paths
REPO_ROOT = Path(__file__).resolve().parent.parent
BACKEND_DIR = REPO_ROOT / "backend"
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from app.core.database import SessionLocal
from app.repositories.catalog_repository import CatalogRepository
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


def run_try_recommender():
    db = SessionLocal()
    repo = CatalogRepository(db)
    service = RecommendationService(repo)

    requests = [
        (
            "1. Mother Birthday (PKR 3500)",
            RecommendationRequest(
                relationship=Relationship.mother,
                age_group=AgeGroup.age_40_49,
                gender=Gender.female,
                occasion=Occasion.birthday,
                budget=3500,
                interests=[Interest.beauty, Interest.skincare],
                gift_styles=[GiftStyle.elegant, GiftStyle.practical],
            ),
        ),
        (
            "2. Friend Eid (PKR 5000)",
            RecommendationRequest(
                relationship=Relationship.friend,
                age_group=AgeGroup.age_20_24,
                occasion=Occasion.eid,
                budget=5000,
                interests=[Interest.gaming],
            ),
        ),
        (
            "3. Brother Graduation (PKR 8000)",
            RecommendationRequest(
                relationship=Relationship.brother,
                age_group=AgeGroup.age_20_24,
                occasion=Occasion.graduation,
                budget=8000,
                interests=[Interest.cricket],
            ),
        ),
        (
            "4. Teacher Thank You (PKR 3000)",
            RecommendationRequest(
                relationship=Relationship.teacher,
                age_group=AgeGroup.age_40_49,
                occasion=Occasion.thank_you,
                budget=3000,
                interests=[Interest.books],
            ),
        ),
        (
            "5. Partner Anniversary (PKR 10000)",
            RecommendationRequest(
                relationship=Relationship.partner,
                age_group=AgeGroup.age_25_29,
                gender=Gender.female,
                occasion=Occasion.anniversary,
                budget=10000,
                interests=[Interest.jewelry],
            ),
        ),
        (
            "6. Father Birthday (PKR 4000)",
            RecommendationRequest(
                relationship=Relationship.father,
                age_group=AgeGroup.age_50_plus,
                occasion=Occasion.birthday,
                budget=4000,
                interests=[Interest.technology],
            ),
        ),
        (
            "7. Mother Low Budget (PKR 500)",
            RecommendationRequest(
                relationship=Relationship.mother,
                age_group=AgeGroup.age_40_49,
                gender=Gender.female,
                occasion=Occasion.birthday,
                budget=500,
                interests=[Interest.beauty, Interest.skincare],
            ),
        ),
    ]

    print("================================================================================")
    print("RECOMMENDER LIVE DATABASE EVALUATION (7 REQUESTS)")
    print("================================================================================")

    for title, req in requests:
        print(f"\n--- {title} ---")
        
        # Format input in one line
        interests_str = ", ".join(i.value for i in req.interests)
        styles_str = ", ".join(s.value for s in req.gift_styles) if req.gift_styles else "none"
        gender_str = req.gender.value if req.gender else "unspecified"
        input_line = (
            f"Input: relationship={req.relationship.value}, age_group={req.age_group.value}, "
            f"gender={gender_str}, occasion={req.occasion.value}, budget=PKR {req.budget}, "
            f"interests=[{interests_str}], styles=[{styles_str}]"
        )
        print(input_line)

        # Call real recommender
        resp = service.get_recommendations(req)

        # Print categories and products
        if not resp.categories:
            print("Categories: None (no in-budget qualifying categories found)")
        else:
            print(f"Categories ({len(resp.categories)} returned):")
            for idx, cat in enumerate(resp.categories, start=1):
                print(f"  {idx}. {cat.name} (id: {cat.id})")
                print(f"     Reason: {cat.reason}")
                print(f"     Products ({cat.product_count}):")
                for p in cat.products:
                    print(f"       * {p.name} - PKR {p.price}")

        # Check budget strictness
        violations = []
        for cat in resp.categories:
            for p in cat.products:
                if p.price > req.budget:
                    violations.append(f"{p.name} (PKR {p.price} > {req.budget})")

        if violations:
            print(f"Check: BUDGET VIOLATION -> {', '.join(violations)}")
        else:
            print("Check: BUDGET OK")

    db.close()
    print("\n================================================================================")
    print("EVALUATION COMPLETE")
    print("================================================================================")


if __name__ == "__main__":
    run_try_recommender()
