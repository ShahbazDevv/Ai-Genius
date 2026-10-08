# AI Genius Backend

FastAPI backend service for AI Genius recommendation engine.

---

## Project Structure

```text
backend/
  app/
    api/            # API endpoints (health, recommendations, products)
    core/           # Config, database, errors, rate limiter, middleware
    models/         # SQLAlchemy ORM models (Product, GiftCategory)
    repositories/   # Catalog repository queries
    schemas/        # Pydantic v2 validation models and enums
    services/       # Business logic (Recommender, ProductService)
    main.py         # FastAPI application entrypoint
  alembic/          # Database migrations
  data/             # Catalog CSV data
  scripts/          # Maintenance and utility scripts
  tests/            # Pytest test suite
  alembic.ini       # Alembic configuration
  requirements.txt  # Python package dependencies
  render.yaml       # Render infrastructure blueprint
  runtime.txt       # Python version pin (3.12.8)
  start.sh          # Render startup script
  .env.example      # Example environment variables
  README.md
```

---

## Local Development & Setup

### 1. Activate Virtual Environment (Windows)
```powershell
.venv\Scripts\activate
```

### 2. Install Dependencies
```powershell
pip install -r requirements.txt
```

### 3. Configure Local Environment
Copy `.env.example` to `.env` and fill in your database credentials:
```powershell
copy .env.example .env
```

### 4. Run Database Migrations (One Command)
To apply all database migrations to the latest schema:
```powershell
alembic upgrade head
```

### 5. Import Product Catalog
To upsert categories and products from CSV data:
```powershell
python scripts/import_catalog_csv.py
```

### 6. Run the Development Server
```powershell
uvicorn app.main:app --reload
```

Interactive API documentation will be available at:
- Swagger UI: [http://localhost:8000/docs](http://localhost:8000/docs)
- Health check: [http://localhost:8000/health](http://localhost:8000/health)

### 7. Run Test Suite
```powershell
pytest
```

---

## Step-by-Step Deployment on Render (Free Web Service)

Deploying to Render takes only a few minutes. Follow these beginner-friendly steps:

### Step 1: Sign Up & Connect Repository
1. Log in to [Render Dashboard](https://dashboard.render.com/).
2. Click **New +** in the top right and select **Web Service**.
3. Choose **Build and deploy from a Git repository** and connect your `Ai-Genius` repository.

### Step 2: Configure Service Settings
Fill in the deployment settings:
- **Name**: `ai-genius-backend` (or your choice)
- **Region**: Choose a region closest to your users or your database (e.g., Frankfurt, Singapore, Oregon).
- **Branch**: `main`
- **Root Directory**: `backend`
- **Runtime**: `Python 3`
- **Build Command**:
  ```bash
  pip install -r requirements.txt
  ```
- **Start Command**:
  ```bash
  uvicorn app.main:app --host 0.0.0.0 --port $PORT --proxy-headers --forwarded-allow-ips="*"
  ```
  > **Why these flags matter:** Behind Render's reverse proxy, all requests arrive from internal proxy IPs. The flags `--proxy-headers --forwarded-allow-ips="*"` allow Uvicorn to read the real client IP from the `X-Forwarded-For` header. Without this, **all users would share a single IP and hit the 30 requests/minute rate limit together**.
- **Instance Type**: Select **Free**.

### Step 3: Configure Advanced Settings
Click **Advanced** at the bottom of the page:
- **Health Check Path**: `/health` (Render will ping `/health` to verify zero-downtime deployment).
- **Auto-Deploy**: `Yes` (deploys automatically when you push to `main`).

### Step 4: Add Environment Variables
Under the **Environment Variables** section, add the following:

| Key | Example Value | Description |
|---|---|---|
| `PYTHON_VERSION` | `3.12.8` | Pins Python to 3.12 on Render |
| `ENVIRONMENT` | `production` | Sets runtime environment |
| `ALLOWED_ORIGINS` | `*` (or `https://your-frontend.com`) | CORS allowed origins |
| `DATABASE_URL` | `postgresql+psycopg://postgres:[PASSWORD]@[HOST]:5432/postgres` | Your live Supabase PostgreSQL connection string |

> **Note on DATABASE_URL:** Make sure the driver is `postgresql+psycopg://` or `postgres://` (the application automatically normalizes it to `psycopg`). Never commit this string to Git.

### Step 5: Deploy & Verify
1. Click **Create Web Service**.
2. Render will build the project and launch the server.
3. Once the build finishes and shows **Live**:
   - Visit `https://your-service-name.onrender.com/health`. You should receive:
     ```json
     { "status": "ok", "version": "1.0.0", "database": "ok" }
     ```
   - Visit `https://your-service-name.onrender.com/docs` to test endpoints via the interactive Swagger UI.

---

## One-Command Database Migrations

To apply database schema changes in development or production:

```bash
# Run from the backend directory:
alembic upgrade head
```

To inspect current revision:
```bash
alembic current
```

---

## Security & Secrets Policy

- Real database passwords, API tokens, and connection strings must **NEVER** be committed to Git.
- Local configuration lives in `backend/.env` (which is excluded by `.gitignore`).
- Production secrets are configured securely in the **Render Dashboard Environment Variables**.
- Rate limiting enforces 30 requests/minute per client IP using `X-Forwarded-For`.
