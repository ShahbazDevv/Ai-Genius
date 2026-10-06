# AI Genius Backend

FastAPI backend service for AI Genius.

## Project Structure

```text
backend/
  app/
    __init__.py
    main.py
    api/            # API routers
    core/           # Configuration, errors, security
    models/         # Database models
    schemas/        # Pydantic request/response schemas
    repositories/   # Data access layer
    services/       # Business logic
  scripts/          # Maintenance and utility scripts
  tests/            # Test suite
  requirements.txt  # Python package dependencies
  .env.example      # Example environment variables
  README.md
```

## Setup & Running

1. **Activate Virtual Environment** (Windows):
   ```powershell
   .venv\Scripts\activate
   ```

2. **Install Dependencies**:
   ```powershell
   pip install -r requirements.txt
   ```

3. **Configure Environment**:
   Copy `.env.example` to `.env` and configure credentials:
   ```powershell
   copy .env.example .env
   ```

4. **Run the Development Server**:
   ```powershell
   uvicorn app.main:app --reload
   ```

5. **API Documentation**:
   Navigate to [http://localhost:8000/docs](http://localhost:8000/docs) in your browser.
