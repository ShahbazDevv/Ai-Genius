from pydantic import BaseModel, ConfigDict


class HealthResponse(BaseModel):
    status: str
    version: str
    database: str

    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)
