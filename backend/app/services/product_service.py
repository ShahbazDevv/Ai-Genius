import uuid
from typing import Optional

from app.core.errors import NotFoundError
from app.repositories.catalog_repository import CatalogRepository
from app.schemas.recommendation import Product as ProductSchema
from app.services.recommender import _to_product_schema


class ProductService:
    """Service handling product retrieval logic."""

    def __init__(self, repository: CatalogRepository):
        self.repository = repository

    def get_product(self, product_id: str) -> ProductSchema:
        """Retrieves a single active product by ID or raises NotFoundError (404)."""
        try:
            uuid.UUID(str(product_id).strip())
        except (ValueError, TypeError, AttributeError):
            raise NotFoundError(message="Product not found")

        product = self.repository.get_product_by_id(product_id)
        if not product:
            raise NotFoundError(message="Product not found")

        return _to_product_schema(product)

