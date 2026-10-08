from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.repositories.catalog_repository import CatalogRepository
from app.schemas.recommendation import Product as ProductSchema
from app.services.product_service import ProductService

router = APIRouter(tags=["products"])


@router.get("/products/{product_id}", response_model=ProductSchema)
def get_product_by_id(
    product_id: str,
    db: Session = Depends(get_db),
) -> ProductSchema:
    """Retrieves single product details by ID or raises 404 NOT_FOUND."""
    repository = CatalogRepository(db)
    service = ProductService(repository=repository)
    return service.get_product(product_id=product_id)
