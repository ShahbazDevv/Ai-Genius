import csv
import sys
import uuid
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Set, Tuple

# Set up paths
REPO_ROOT = Path(__file__).resolve().parent.parent
BACKEND_DIR = REPO_ROOT / "backend"
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

# Allowed values from docs/api_contract.md
ALLOWED_RELATIONSHIPS: Set[str] = {
    "mother", "father", "friend", "best_friend", "partner",
    "brother", "sister", "teacher", "colleague", "other"
}
ALLOWED_AGE_GROUPS: Set[str] = {
    "5_9", "10_19", "20_24", "25_29", "30_39", "40_49", "50_plus"
}
ALLOWED_GENDERS: Set[str] = {
    "male", "female", "unspecified"
}
ALLOWED_OCCASIONS: Set[str] = {
    "birthday", "wedding", "anniversary", "graduation", "engagement",
    "thank_you", "valentines_day", "eid", "christmas", "other"
}
ALLOWED_INTERESTS: Set[str] = {
    "beauty", "skincare", "makeup", "books", "technology",
    "computer_gadgets", "mobile_accessories", "sports", "cricket",
    "fitness", "fashion", "jewelry", "gaming", "travel",
    "home_lifestyle", "food", "art_crafts", "other"
}
ALLOWED_STYLES: Set[str] = {
    "practical", "elegant", "luxury", "budget_friendly",
    "personalized", "sentimental", "fun", "minimal",
    "self_care", "experience"
}
ALLOWED_AVAILABILITY: Set[str] = {
    "in_stock", "out_of_stock", "unknown"
}


def parse_pipe_separated(val: str) -> List[str]:
    """Split pipe-separated string into cleaned list of strings."""
    if not val or not val.strip():
        return []
    return [item.strip() for item in val.split("|") if item.strip()]


def validate_product_row(
    row: Dict[str, str], row_idx: int, valid_category_ids: Set[str]
) -> Tuple[bool, List[str]]:
    """Validate a single product row according to business rules and api contract."""
    errors: List[str] = []

    # 1. Name
    name = row.get("name", "").strip()
    if not name:
        errors.append("Product name is empty")

    # 2. Store URL
    store_url = row.get("store_url", "").strip()
    if not store_url:
        errors.append("store_url is empty")
    elif not store_url.startswith("https://"):
        errors.append(f"store_url must start with 'https://' (got: {store_url})")

    # 3. Price
    raw_price = row.get("price", "").strip()
    try:
        price = int(raw_price)
        if not (500 <= price <= 15000):
            errors.append(f"price {price} is outside allowed range 500 to 15000")
    except ValueError:
        errors.append(f"price '{raw_price}' is not a valid integer")

    # 4. Category existence
    cat_id = row.get("category_id", "").strip()
    if not cat_id:
        errors.append("category_id is empty")
    elif cat_id not in valid_category_ids:
        errors.append(f"category_id '{cat_id}' does not exist in categories")

    # 5. Availability
    avail = row.get("availability", "").strip()
    if avail not in ALLOWED_AVAILABILITY:
        errors.append(f"invalid availability '{avail}'. Allowed: {sorted(ALLOWED_AVAILABILITY)}")

    # 6. Interests
    interests = parse_pipe_separated(row.get("interests", ""))
    invalid_interests = [i for i in interests if i not in ALLOWED_INTERESTS]
    if invalid_interests:
        errors.append(f"invalid interests: {invalid_interests}")

    # 7. Occasions
    occasions = parse_pipe_separated(row.get("occasions", ""))
    invalid_occasions = [o for o in occasions if o not in ALLOWED_OCCASIONS]
    if invalid_occasions:
        errors.append(f"invalid occasions: {invalid_occasions}")

    # 8. Age groups
    age_groups = parse_pipe_separated(row.get("age_groups", ""))
    invalid_age_groups = [ag for ag in age_groups if ag not in ALLOWED_AGE_GROUPS]
    if invalid_age_groups:
        errors.append(f"invalid age_groups: {invalid_age_groups}")

    # 9. Genders
    genders = parse_pipe_separated(row.get("genders", ""))
    invalid_genders = [g for g in genders if g not in ALLOWED_GENDERS]
    if invalid_genders:
        errors.append(f"invalid genders: {invalid_genders}")

    # 10. Styles
    styles = parse_pipe_separated(row.get("styles", ""))
    invalid_styles = [s for s in styles if s not in ALLOWED_STYLES]
    if invalid_styles:
        errors.append(f"invalid styles: {invalid_styles}")

    return (len(errors) == 0, errors)


def import_catalog(
    categories_csv_path: Path,
    products_csv_path: Path
) -> None:
    """Imports categories and products CSV files into database safely with upsert."""
    from app.core.database import SessionLocal
    from app.models.gift_category import GiftCategory
    from app.models.product import Product

    if not categories_csv_path.exists():
        print(f"Error: Categories CSV not found at {categories_csv_path}")
        sys.exit(1)

    if not products_csv_path.exists():
        print(f"Error: Products CSV not found at {products_csv_path}")
        sys.exit(1)

    db = SessionLocal()
    now_utc = datetime.now(timezone.utc)

    print("==================================================")
    print("Catalog Import: Categories & Products")
    print("==================================================")

    # ----------------------------------------------------
    # Step 1: Import Categories (backend/data/categories_v1.csv)
    # ----------------------------------------------------
    print(f"\n1. Reading categories from: {categories_csv_path.name}")
    valid_category_ids: Set[str] = set()
    category_rows: List[Dict[str, str]] = []

    with open(categories_csv_path, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            category_rows.append(row)
            cid = row.get("id", "").strip()
            if cid:
                valid_category_ids.add(cid)

    categories_imported = 0
    categories_updated = 0

    try:
        for row in category_rows:
            cid = row.get("id", "").strip()
            if not cid:
                continue

            name = row.get("name", "").strip()
            desc = row.get("description", "").strip() or None
            icon = row.get("icon", "").strip() or None
            related_interests = parse_pipe_separated(row.get("related_interests", ""))
            related_occasions = parse_pipe_separated(row.get("related_occasions", ""))
            related_relationships = parse_pipe_separated(row.get("related_relationships", ""))
            style_tags = parse_pipe_separated(row.get("style_tags", ""))

            min_price = int(row["min_price"]) if row.get("min_price", "").strip() else None
            max_price = int(row["max_price"]) if row.get("max_price", "").strip() else None

            existing = db.query(GiftCategory).filter(GiftCategory.id == cid).first()
            if existing:
                existing.name = name
                existing.description = desc
                existing.icon = icon
                existing.related_interests = related_interests
                existing.related_occasions = related_occasions
                existing.related_relationships = related_relationships
                existing.style_tags = style_tags
                existing.min_price = min_price
                existing.max_price = max_price
                existing.is_active = True
                categories_updated += 1
            else:
                cat = GiftCategory(
                    id=cid,
                    name=name,
                    description=desc,
                    icon=icon,
                    related_interests=related_interests,
                    related_occasions=related_occasions,
                    related_relationships=related_relationships,
                    style_tags=style_tags,
                    min_price=min_price,
                    max_price=max_price,
                    is_active=True,
                )
                db.add(cat)
                categories_imported += 1

        db.commit()
        print(f"Categories successfully upserted: {categories_imported} inserted, {categories_updated} updated (Total: {len(category_rows)})")
    except Exception as e:
        db.rollback()
        print(f"Database error during category import: {e}")
        db.close()
        sys.exit(1)

    # ----------------------------------------------------
    # Step 2: Import Products (backend/data/products_v1.csv)
    # ----------------------------------------------------
    print(f"\n2. Reading products from: {products_csv_path.name}")
    products_inserted = 0
    products_updated = 0
    rejected_rows: List[Tuple[int, str, List[str]]] = []

    with open(products_csv_path, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        product_rows = list(reader)

    try:
        for idx, row in enumerate(product_rows, start=2):  # start=2 considering header as row 1
            is_valid, errors = validate_product_row(row, idx, valid_category_ids)
            if not is_valid:
                p_name = row.get("name", "Unknown")
                rejected_rows.append((idx, p_name, errors))
                continue

            name = row["name"].strip()
            desc = row.get("description", "").strip() or None
            price = int(row["price"].strip())
            currency = "PKR"
            image_url = row.get("image_url", "").strip() or None
            store_name = row.get("store_name", "").strip() or "Daraz"
            store_url = row["store_url"].strip()
            cat_id = row["category_id"].strip()
            tags = parse_pipe_separated(row.get("tags", ""))
            interests = parse_pipe_separated(row.get("interests", ""))
            occasions = parse_pipe_separated(row.get("occasions", ""))
            age_groups = parse_pipe_separated(row.get("age_groups", ""))
            genders = parse_pipe_separated(row.get("genders", ""))
            styles = parse_pipe_separated(row.get("styles", ""))
            avail = row["availability"].strip()
            source = row.get("source", "curated").strip() or "curated"

            existing = db.query(Product).filter(Product.store_url == store_url).first()
            if existing:
                existing.name = name
                existing.description = desc
                existing.price = price
                existing.currency = currency
                existing.image_url = image_url
                existing.store_name = store_name
                existing.category_id = cat_id
                existing.tags = tags
                existing.interests = interests
                existing.occasions = occasions
                existing.age_groups = age_groups
                existing.genders = genders
                existing.styles = styles
                existing.availability = avail
                existing.source = source
                existing.is_active = True
                existing.last_updated = now_utc
                products_updated += 1
            else:
                prod = Product(
                    id=uuid.uuid4(),
                    name=name,
                    description=desc,
                    price=price,
                    currency=currency,
                    image_url=image_url,
                    store_name=store_name,
                    store_url=store_url,
                    category_id=cat_id,
                    tags=tags,
                    interests=interests,
                    occasions=occasions,
                    age_groups=age_groups,
                    genders=genders,
                    styles=styles,
                    availability=avail,
                    source=source,
                    is_active=True,
                    last_updated=now_utc,
                )
                db.add(prod)
                products_inserted += 1

        db.commit()
    except Exception as e:
        db.rollback()
        print(f"Database error during product import: {e}")
        db.close()
        sys.exit(1)

    # ----------------------------------------------------
    # Step 3: Statistics and Verification Report
    # ----------------------------------------------------
    total_categories_in_db = db.query(GiftCategory).count()
    total_products_in_db = db.query(Product).count()

    from sqlalchemy import func
    cat_stats = (
        db.query(
            Product.category_id,
            func.count(Product.id).label("count"),
            func.min(Product.price).label("min_price"),
            func.max(Product.price).label("max_price"),
        )
        .filter(Product.is_active.is_(True))
        .group_by(Product.category_id)
        .order_by(Product.category_id)
        .all()
    )

    db.close()

    print("\n==================================================")
    print("IMPORT REPORT SUMMARY")
    print("==================================================")
    print(f"Number of Categories in Database : {total_categories_in_db}")
    print(f"Number of Products in Database   : {total_products_in_db}")
    print(f"Products Inserted this run       : {products_inserted}")
    print(f"Products Updated this run        : {products_updated}")
    print(f"Rejected Rows Count              : {len(rejected_rows)}")

    if rejected_rows:
        print("\n--- REJECTED ROWS ---")
        for r_idx, r_name, r_errs in rejected_rows:
            print(f"Row {r_idx}: '{r_name}'")
            for err in r_errs:
                print(f"   Reason: {err}")
    else:
        print("\nAll rows passed validation successfully with 0 rejected rows!")

    print("\n--- PRODUCTS PER CATEGORY & PRICE RANGES ---")
    print(f"{'Category ID':<30} | {'Count':<6} | {'Min Price (PKR)':<15} | {'Max Price (PKR)':<15}")
    print("-" * 75)
    for cat_id, count, min_p, max_p in cat_stats:
        print(f"{cat_id:<30} | {count:<6} | {min_p:<15} | {max_p:<15}")
    print("==================================================")


if __name__ == "__main__":
    cat_path = REPO_ROOT / "backend" / "data" / "categories_v1.csv"
    prod_path = REPO_ROOT / "backend" / "data" / "products_v1.csv"
    import_catalog(cat_path, prod_path)
