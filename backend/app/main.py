import logging
from fastapi import FastAPI, HTTPException
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from slowapi.middleware import SlowAPIMiddleware
from sqlalchemy.exc import SQLAlchemyError
from starlette.exceptions import HTTPException as StarletteHTTPException

from app.api.health import router as health_router
from app.api.v1 import api_v1_router
from app.core.config import settings
from app.core.errors import (
    AppException,
    app_exception_handler,
    database_exception_handler,
    rate_limit_exceeded_handler,
    starlette_http_exception_handler,
    unhandled_exception_handler,
    validation_exception_handler,
)
from app.core.limiter import limiter
from app.core.middleware import SecurityAndLoggingMiddleware

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)

app = FastAPI(
    title="AI Genius API",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# Attach slowapi limiter state
app.state.limiter = limiter

# Add slowapi middleware for rate limiting
app.add_middleware(SlowAPIMiddleware)

# Security and Logging middleware (body size limit, request_id, safe logging)
app.add_middleware(SecurityAndLoggingMiddleware)

# Configure CORS from ALLOWED_ORIGINS env (no credentials/cookies needed)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register global exception handlers strictly adhering to API contract error format
app.add_exception_handler(RequestValidationError, validation_exception_handler)
app.add_exception_handler(RateLimitExceeded, rate_limit_exceeded_handler)
app.add_exception_handler(AppException, app_exception_handler)
app.add_exception_handler(StarletteHTTPException, starlette_http_exception_handler)
app.add_exception_handler(HTTPException, starlette_http_exception_handler)
app.add_exception_handler(SQLAlchemyError, database_exception_handler)
app.add_exception_handler(500, unhandled_exception_handler)
app.add_exception_handler(Exception, unhandled_exception_handler)

# Include routers
# Health endpoint is outside /api/v1 per contract (/health)
app.include_router(health_router)
# All v1 endpoints under /api/v1
app.include_router(api_v1_router)
