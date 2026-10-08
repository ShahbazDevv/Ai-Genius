import logging
import uuid
from typing import Any, List, Optional

from fastapi import Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from slowapi.errors import RateLimitExceeded
from sqlalchemy.exc import SQLAlchemyError
from starlette.exceptions import HTTPException as StarletteHTTPException

from app.schemas.enums import ErrorCode

logger = logging.getLogger("ai_genius")


class AppException(Exception):
    """Base application exception for business errors."""

    def __init__(self, message: str, code: ErrorCode, status_code: int):
        super().__init__(message)
        self.message = message
        self.code = code
        self.status_code = status_code


class NotFoundError(AppException):
    """Raised when a requested resource is not found."""

    def __init__(self, message: str = "Resource not found"):
        super().__init__(message=message, code=ErrorCode.NOT_FOUND, status_code=404)


class DatabaseError(AppException):
    """Raised when an explicit database failure occurs."""

    def __init__(
        self,
        message: str = "Database is temporarily unavailable. Please try again later.",
    ):
        super().__init__(message=message, code=ErrorCode.DATABASE_ERROR, status_code=503)


async def validation_exception_handler(
    request: Request, exc: RequestValidationError
) -> JSONResponse:
    """Returns standardized VALIDATION_ERROR 422 without internal details or stack traces."""
    req_id = getattr(request.state, "request_id", None) or str(uuid.uuid4())
    details: List[dict] = []
    for err in exc.errors():
        loc = err.get("loc", ())
        parts = [str(p) for p in loc if p != "body"]
        field = ".".join(parts) if parts else "body"
        msg = err.get("msg", "Invalid value")
        details.append({"field": field, "message": msg})

    # Short, human-readable message without exposing internal details
    message = (
        f"Validation failed for {details[0]['field']}: {details[0]['message']}"
        if details
        else "Invalid request parameters."
    )
    logger.warning(f"[{req_id}] Validation error: {message}")

    return JSONResponse(
        status_code=422,
        content={
            "error": {
                "code": ErrorCode.VALIDATION_ERROR.value,
                "message": message,
                "details": details,
            }
        },
        headers={"X-Request-ID": req_id},
    )


async def rate_limit_exceeded_handler(
    request: Request, exc: RateLimitExceeded
) -> JSONResponse:
    """Returns standardized RATE_LIMITED 429 when rate limit is exceeded."""
    req_id = getattr(request.state, "request_id", None) or str(uuid.uuid4())
    client_ip = request.client.host if request.client else "unknown"
    logger.warning(f"[{req_id}] Rate limit exceeded for IP: {client_ip}")

    return JSONResponse(
        status_code=429,
        content={
            "error": {
                "code": ErrorCode.RATE_LIMITED.value,
                "message": "Rate limit exceeded. Please try again later.",
            }
        },
        headers={"X-Request-ID": req_id},
    )


async def app_exception_handler(request: Request, exc: AppException) -> JSONResponse:
    """Handles custom domain application exceptions."""
    req_id = getattr(request.state, "request_id", None) or str(uuid.uuid4())
    logger.warning(f"[{req_id}] App exception ({exc.code.value}): {exc.message}")

    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": {
                "code": exc.code.value if hasattr(exc.code, "value") else str(exc.code),
                "message": exc.message,
            }
        },
        headers={"X-Request-ID": req_id},
    )


async def starlette_http_exception_handler(
    request: Request, exc: StarletteHTTPException
) -> JSONResponse:
    """Standardizes Starlette/FastAPI HTTP exceptions into contract error format."""
    req_id = getattr(request.state, "request_id", None) or str(uuid.uuid4())

    if exc.status_code == 404:
        code = ErrorCode.NOT_FOUND.value
        message = exc.detail or "Not Found"
    elif exc.status_code == 405:
        code = ErrorCode.METHOD_NOT_ALLOWED.value
        message = exc.detail or "Method Not Allowed"
    elif exc.status_code == 413:
        code = ErrorCode.VALIDATION_ERROR.value
        message = "Request is too large"
    elif exc.status_code == 422:
        code = ErrorCode.VALIDATION_ERROR.value
        message = exc.detail or "Validation failed."
    elif exc.status_code == 429:
        code = ErrorCode.RATE_LIMITED.value
        message = exc.detail or "Rate limit exceeded."
    elif exc.status_code == 503:
        code = ErrorCode.DATABASE_ERROR.value
        message = exc.detail or "Database service temporarily unavailable."
    else:
        code = ErrorCode.INTERNAL_ERROR.value
        message = (
            exc.detail if exc.status_code < 500 else "An internal server error occurred."
        )

    logger.warning(f"[{req_id}] HTTP {exc.status_code} ({code}): {message}")

    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": {
                "code": code,
                "message": message,
            }
        },
        headers={"X-Request-ID": req_id},
    )


async def database_exception_handler(
    request: Request, exc: SQLAlchemyError
) -> JSONResponse:
    """Handles SQLAlchemy database failures without exposing SQL, stack traces, or credentials."""
    req_id = getattr(request.state, "request_id", None) or str(uuid.uuid4())
    # Log full error with traceback on server only
    logger.error(f"[{req_id}] Database failure occurred: {exc}", exc_info=True)

    return JSONResponse(
        status_code=503,
        content={
            "error": {
                "code": ErrorCode.DATABASE_ERROR.value,
                "message": "Database is temporarily unavailable. Please try again later.",
            }
        },
        headers={"X-Request-ID": req_id},
    )


async def unhandled_exception_handler(
    request: Request, exc: Exception
) -> JSONResponse:
    """Catches all other unhandled exceptions and returns generic INTERNAL_ERROR 500."""
    req_id = getattr(request.state, "request_id", None) or str(uuid.uuid4())
    # Log real error on server only; never return stack traces, SQL or paths
    logger.error(f"[{req_id}] Unhandled internal server error: {exc}", exc_info=True)

    return JSONResponse(
        status_code=500,
        content={
            "error": {
                "code": ErrorCode.INTERNAL_ERROR.value,
                "message": "An internal server error occurred.",
            }
        },
        headers={"X-Request-ID": req_id},
    )
