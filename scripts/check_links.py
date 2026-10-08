import sys
import time
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path
from typing import List, Tuple

# Set up paths
REPO_ROOT = Path(__file__).resolve().parent.parent
BACKEND_DIR = REPO_ROOT / "backend"
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))


def check_product_links() -> None:
    """Checks store_url for every active product in the database.

    Requirements:
    - Polite requests: 10 second timeout, 1 second delay between requests.
    - If a link returns an error (HTTP error, timeout, connection failure),
      sets availability to 'unknown' and updates last_updated.
    - NEVER deletes products.
    - NEVER prints database URL or secrets.
    """
    from app.core.database import SessionLocal
    from app.models.product import Product

    db = SessionLocal()
    products = db.query(Product).filter(Product.is_active.is_(True)).all()
    total_products = len(products)

    print("==================================================")
    print("Catalog Link Checker")
    print(f"Total active products to check: {total_products}")
    print("Settings: 10s timeout, 1s delay between requests")
    print("==================================================")

    now_utc = datetime.now(timezone.utc)
    success_count = 0
    error_count = 0
    results: List[Tuple[str, str, str, str]] = []  # (name, url, status, error_msg)

    user_agent = (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/120.0.0.0 Safari/537.36"
    )

    for idx, prod in enumerate(products, start=1):
        url = prod.store_url
        name = prod.name
        is_error = False
        error_reason = ""

        print(f"[{idx}/{total_products}] Checking: {name[:45]}...")

        try:
            req = urllib.request.Request(url, headers={"User-Agent": user_agent})
            with urllib.request.urlopen(req, timeout=10) as resp:
                status_code = resp.status
                if 200 <= status_code < 400:
                    success_count += 1
                    results.append((name, url, "OK", f"HTTP {status_code}"))
                else:
                    is_error = True
                    error_reason = f"HTTP {status_code}"
        except urllib.error.HTTPError as e:
            is_error = True
            error_reason = f"HTTP {e.code}: {e.reason}"
        except urllib.error.URLError as e:
            is_error = True
            error_reason = f"Network Error: {e.reason}"
        except TimeoutError:
            is_error = True
            error_reason = "Connection Timed Out (>10s)"
        except Exception as e:
            is_error = True
            error_reason = f"Unexpected Error: {str(e)}"

        if is_error:
            error_count += 1
            prod.availability = "unknown"
            prod.last_updated = now_utc
            results.append((name, url, "ERROR", error_reason))
            print(f"   -> Link Failed: {error_reason} (Set availability='unknown')")

        # 1-second delay between requests to be polite
        if idx < total_products:
            time.sleep(1.0)

    # Commit any availability and last_updated updates
    try:
        db.commit()
    except Exception as e:
        db.rollback()
        print(f"Error saving link check updates to database: {e}")
    finally:
        db.close()

    print("\n==================================================")
    print("LINK CHECK REPORT SUMMARY")
    print("==================================================")
    print(f"Total Products Checked : {total_products}")
    print(f"Successful Links (OK)  : {success_count}")
    print(f"Failed Links (Errors)  : {error_count}")
    print("Products Deleted       : 0 (Strict policy: never delete)")
    print("==================================================")

    if error_count > 0:
        print("\n--- PRODUCTS WITH FAILED LINKS ---")
        for name, url, status, err_msg in results:
            if status == "ERROR":
                print(f"Product : {name}")
                print(f"URL     : {url}")
                print(f"Issue   : {err_msg}")
                print(f"Action  : availability set to 'unknown'")
                print("-" * 50)
    else:
        print("\nAll product links responded successfully without errors!")


if __name__ == "__main__":
    check_product_links()
