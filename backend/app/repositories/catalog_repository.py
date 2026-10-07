from typing import Dict, List, Optional
from sqlalchemy.orm import Session

from app.models.gift_category import GiftCategory
from app.models.product import Product


class CatalogRepository:
    """Repository for querying catalog categories and products from the database."""

    def __init__(self, db: Session):
        self.db = db

    def get_active_categories_and_products(
        self, max_budget: Optional[int] = None
    ) -> List[GiftCategory]:
        """Loads all active categories and their active in-budget products.

        STRICT BUDGET RULE: Products with price > max_budget are filtered out
        directly in the database query.
        """
        # 1. Fetch active categories ordered deterministically by name
        categories = (
            self.db.query(GiftCategory)
            .filter(GiftCategory.is_active.is_(True))
            .order_by(GiftCategory.name)
            .all()
        )

        # 2. Fetch active products with price <= max_budget
        prod_query = self.db.query(Product).filter(Product.is_active.is_(True))
        if max_budget is not None:
            prod_query = prod_query.filter(Product.price <= max_budget)

        products = prod_query.order_by(Product.name).all()

        # Group products by category_id
        products_by_category: Dict[str, List[Product]] = {}
        for p in products:
            products_by_category.setdefault(p.category_id, []).append(p)

        # Attach in-budget products to categories
        for cat in categories:
            cat.products = products_by_category.get(cat.id, [])

        return categories
