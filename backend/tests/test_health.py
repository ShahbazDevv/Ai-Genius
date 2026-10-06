from unittest.mock import patch
from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health_ok():
    with patch("app.api.health.check_db_health", return_value=True):
        response = client.get("/health")
        assert response.status_code == 200
        assert response.json() == {
            "status": "ok",
            "version": "1.0.0",
            "database": "ok",
        }


def test_health_degraded():
    with patch("app.api.health.check_db_health", return_value=False):
        response = client.get("/health")
        assert response.status_code == 200
        assert response.json() == {
            "status": "degraded",
            "version": "1.0.0",
            "database": "down",
        }
