from pathlib import Path
from typing import List
from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

BACKEND_DIR = Path(__file__).resolve().parent.parent.parent


class Settings(BaseSettings):
    ENVIRONMENT: str = "development"
    ALLOWED_ORIGINS: str = "*"
    DATABASE_URL: str = ""

    @field_validator("DATABASE_URL")
    @classmethod
    def check_database_url(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError(
                "DATABASE_URL is missing or empty. Please set DATABASE_URL in backend/.env or as an environment variable."
            )
        return v.strip()

    @property
    def cors_origins(self) -> List[str]:
        cleaned = self.ALLOWED_ORIGINS.strip()
        if cleaned == "*":
            return ["*"]
        return [origin.strip() for origin in cleaned.split(",") if origin.strip()]

    model_config = SettingsConfigDict(
        env_file=(BACKEND_DIR / ".env", ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )


try:
    settings = Settings()
    if not settings.DATABASE_URL or not settings.DATABASE_URL.strip():
        raise ValueError("DATABASE_URL is missing or empty.")
except Exception:
    raise RuntimeError(
        "Application startup failed: DATABASE_URL is missing or empty. "
        "Please provide a valid DATABASE_URL in backend/.env or your environment variables."
    ) from None
