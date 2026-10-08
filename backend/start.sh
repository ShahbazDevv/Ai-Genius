#!/usr/bin/env bash
# Start script for Render deployment
# Passes --proxy-headers and --forwarded-allow-ips="*" so Uvicorn forwards
# real client IPs from X-Forwarded-For to the slowapi rate limiter.
exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000} --proxy-headers --forwarded-allow-ips="*"
