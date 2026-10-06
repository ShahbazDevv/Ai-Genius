from fastapi import APIRouter
from app.core.database import check_db_health
from app.schemas.health import HealthResponse

router = APIRouter(tags=["health"])


@router.get("/health", response_model=HealthResponse)
def get_health() -> HealthResponse:
    db_healthy = check_db_health()
    return HealthResponse(
        status="ok" if db_healthy else "degraded",
        version="1.0.0",
        database="ok" if db_healthy else "down",
    )
