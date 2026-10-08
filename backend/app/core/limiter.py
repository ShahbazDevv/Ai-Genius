from slowapi import Limiter
from starlette.requests import Request


def get_real_client_ip(request: Request) -> str:
    """Extracts the real client IP address for rate limiting.

    Behind reverse proxies (such as Render), the incoming request arrives from
    the proxy's IP. The actual client's IP is transmitted in the X-Forwarded-For
    header (the leftmost IP in a comma-separated list).
    Falls back to request.client.host or 127.0.0.1 if not present.
    """
    forwarded_for = request.headers.get("x-forwarded-for")
    if forwarded_for:
        # Leftmost IP represents the original client
        client_ip = forwarded_for.split(",")[0].strip()
        if client_ip:
            return client_ip

    if request.client and request.client.host:
        return request.client.host

    return "127.0.0.1"


# Shared slowapi rate limiter instance keyed by real client IP
limiter = Limiter(key_func=get_real_client_ip)
