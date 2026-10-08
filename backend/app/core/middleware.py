import json
import logging
import time
import uuid
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse, Response

from app.schemas.enums import ErrorCode

logger = logging.getLogger("ai_genius")

MAX_BODY_SIZE = 64 * 1024  # 64 KB


class SecurityAndLoggingMiddleware(BaseHTTPMiddleware):
    """Middleware enforcing body size limits, request ID tracking, and safe logging."""

    async def dispatch(self, request: Request, call_next) -> Response:
        # 1. Attach Request ID (UUID)
        # Only accept client X-Request-ID if it is a valid UUID; otherwise generate a new UUID.
        # Never write raw client-supplied header values into logs.
        raw_header = request.headers.get("x-request-id")
        req_id = None
        if raw_header:
            try:
                parsed_uuid = uuid.UUID(raw_header.strip())
                req_id = str(parsed_uuid)
            except (ValueError, TypeError, AttributeError):
                req_id = None

        if not req_id:
            req_id = str(uuid.uuid4())

        request.state.request_id = req_id

        # 2. Check Content-Length header against size limit (HTTP 413)
        content_length = request.headers.get("content-length")
        if content_length:
            try:
                if int(content_length) > MAX_BODY_SIZE:
                    logger.warning(
                        f"[{req_id}] Content-Length {content_length} exceeds limit {MAX_BODY_SIZE}"
                    )
                    return JSONResponse(
                        status_code=413,
                        content={
                            "error": {
                                "code": ErrorCode.VALIDATION_ERROR.value,
                                "message": "Request is too large",
                            }
                        },
                        headers={"X-Request-ID": req_id},
                    )
            except ValueError:
                pass

        # 3. Read body safely if write method to enforce size and safe logging
        if request.method in ("POST", "PUT", "PATCH"):
            body = await request.body()
            if len(body) > MAX_BODY_SIZE:
                logger.warning(
                    f"[{req_id}] Body length {len(body)} exceeds limit {MAX_BODY_SIZE}"
                )
                return JSONResponse(
                    status_code=413,
                    content={
                        "error": {
                            "code": ErrorCode.VALIDATION_ERROR.value,
                            "message": "Request is too large",
                        }
                    },
                    headers={"X-Request-ID": req_id},
                )

            # Security rule: Do not log request bodies containing additional_details
            has_additional_details = False
            try:
                if body:
                    data = json.loads(body.decode("utf-8"))
                    if isinstance(data, dict) and "additional_details" in data:
                        has_additional_details = True
            except Exception:
                pass

            if has_additional_details:
                logger.info(
                    f"[{req_id}] {request.method} {request.url.path} (request body logging omitted: contains additional_details)"
                )
            else:
                body_preview = body.decode("utf-8", errors="ignore")
                logger.info(
                    f"[{req_id}] {request.method} {request.url.path} body: {body_preview}"
                )
        else:
            logger.info(f"[{req_id}] {request.method} {request.url.path}")

        # 4. Execute request
        start_time = time.time()
        try:
            response = await call_next(request)
        except Exception:
            raise

        duration_ms = (time.time() - start_time) * 1000
        logger.info(
            f"[{req_id}] Completed {response.status_code} in {duration_ms:.2f}ms"
        )
        response.headers["X-Request-ID"] = req_id
        return response
