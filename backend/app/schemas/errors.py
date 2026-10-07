from typing import Any, List, Optional
from pydantic import BaseModel, ConfigDict

from app.schemas.enums import ErrorCode


class ErrorBody(BaseModel):
    code: ErrorCode
    message: str
    details: Optional[List[Any]] = None

    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)


class ErrorResponse(BaseModel):
    error: ErrorBody

    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)
