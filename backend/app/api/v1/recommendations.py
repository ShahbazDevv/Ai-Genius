import uuid
from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.limiter import limiter
from app.repositories.catalog_repository import CatalogRepository
from app.schemas.recommendation import (
    RecommendationRequest,
    RecommendationResponse,
)
from app.services.recommender import RecommendationService

router = APIRouter(tags=["recommendations"])


@router.post("/recommendations", response_model=RecommendationResponse)
@limiter.limit("30/minute")
def create_recommendations(
    request: Request,
    payload: RecommendationRequest,
    db: Session = Depends(get_db),
) -> RecommendationResponse:
    """Generates deterministic gift category recommendations within budget."""
    request_id = getattr(request.state, "request_id", None) or str(uuid.uuid4())
    repository = CatalogRepository(db)
    service = RecommendationService(repository=repository)
    return service.get_recommendations(request=payload, request_id=request_id)
