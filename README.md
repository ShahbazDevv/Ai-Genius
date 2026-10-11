# <div align="center">AI Genius</div>

<div align="center">

**Find the perfect gift, within your budget**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![GetX](https://img.shields.io/badge/GetX-8A2BE2?style=for-the-badge&logo=flutter&logoColor=white)](https://pub.dev/packages/get)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://www.android.com)

</div>

---

## 📖 About

AI Genius is a Flutter Android application designed to eliminate the guesswork from gift shopping in Pakistan. Users describe the recipient by specifying relationship, age group, gender, occasion, budget (from PKR 500 to PKR 15,000), recipient interests, and preferred gift styles. A FastAPI backend processes these preferences through an intelligent recommendation engine that matches the recipient against a verified product catalog. The service returns up to four ranked gift categories containing real, hand-verified store items that strictly never exceed the user's budget.

---

## 📱 Screenshots

| Splash Screen | Home Form |
| :---: | :---: |
| <img src="assets/screenshots/Splash.jpeg" width="220" alt="Splash screen" /> | <img src="assets/screenshots/Home.jpeg" width="220" alt="Home form" /> |
| **Home Form (Lower Part)** | **AI Analysis / Loading** |
| <img src="assets/screenshots/Home_2.jpeg" width="220" alt="Home form, lower part" /> | <img src="assets/screenshots/Analyze.jpeg" width="220" alt="AI analysis / loading" /> |
| **AI Gift Suggestions** | **Product List** |
| <img src="assets/screenshots/Suggestion.jpeg" width="220" alt="AI gift suggestions" /> | <img src="assets/screenshots/Product.jpeg" width="220" alt="Product list" /> |
| **Product Detail** | **View on Store (Store Page)** |
| <img src="assets/screenshots/Detail_product.jpeg" width="220" alt="Product detail" /> | <img src="assets/screenshots/Daraz.jpeg" width="220" alt="View on Store opens the real store page" /> |

---

## ✨ Features

### 📱 App (Flutter)
- **Sectioned Preference Form**: Intuitive input workflow for recipient relationship, age bracket, gender, occasion, interests, and gift styles.
- **Budget Range Slider**: Enforces valid budget inputs strictly between PKR 500 and PKR 15,000.
- **Animated Loading Screen**: Provides engaging visual feedback while communicating with the recommendation engine.
- **Explainable Suggestions**: Suggestion cards explain *why* each gift category was selected using generated human-readable sentences.
- **Product Exploration & Filtering**: Product lists featuring instant sort (price low-to-high, high-to-low) and stock availability filters.
- **Product Detail View**: Displays item pricing, category tags, descriptions, and high-resolution store images.
- **Direct Store Outlink**: "View on Store" opens live product pages directly on Daraz via `url_launcher`.
- **Local SQLite Persistence (Drift)**: Saved gifts and recommendation history are persisted on-device and fully accessible offline.
- **Theme Support**: Seamless switching between light, dark, and system themes with persistent user preferences.
- **Resilient Network Handling**: User-friendly states and recovery actions for no internet connectivity, connection timeouts, rate limit hits, and server cold starts.

### ⚡ Backend (FastAPI)
- **Strict Server Budget Enforcement**: Products exceeding the user's budget are strictly eliminated on the server before responses are built.
- **Rigorous Input Validation**: Pydantic v2 schemas validate all inputs and enums against the contract.
- **Standardized Contract Error Handling**: All HTTP exceptions (404, 405, 413, 422, 429, 500, 503) output uniform `{"error": {"code": "...", "message": "..."}}` payloads with zero leaked server internals or stack traces.
- **IP-Based Rate Limiting**: SlowAPI limits requests (30 req/min) based on proxy forwarded client IPs (`X-Forwarded-For`).
- **Request Tracing**: Generates or propagates `X-Request-ID` across all response headers and payloads.
- **Configurable CORS**: Environment-driven CORS policies for security across environments.
- **Health Monitoring**: Dedicated `GET /health` endpoint reporting operational status of both the API and PostgreSQL database.

---

## 🧠 How the Recommendation Works

The recommendation engine uses a deterministic, rule-based scoring algorithm designed to produce relevant and explainable results:

1. **Category Qualification Rule**: A category qualifies for evaluation **only** if at least one of the user's requested interests matches the category's `related_interests`. (Exception: if the user solely selects the interest `"other"`, qualification bypasses this rule and evaluates occasion, relationship, and gift style). Non-qualifying categories are excluded immediately, even if occasion or relationship matches.
2. **Point Scoring**:
   - **+3 points** for each user interest found in the category's `related_interests`.
   - **+3 points** if the requested occasion matches the category's `related_occasions`.
   - **+1 point** if the recipient relationship matches the category's `related_relationships`.
   - **+1 point** per matching gift style found in `style_tags` (capped at +2 points).
   - **+1 or +2 bonus points** for categories with in-budget products (1 product = +1, 2+ products = +2).
3. **Tie-Breaking**: If categories tie in score, the tie is broken first by **interest focus** (calculated as `matched_interests / total_category_interests`), and second alphabetically by category name.
4. **Strict Budget Filter**: Any product with a price greater than the requested budget (`price > budget`) is filtered out. Categories that have zero in-budget products are eliminated.
5. **Top 4 Selection**: The top 4 scoring categories are returned.
6. **In-Category Product Ranking**: Products inside each category are ranked based on keyword matches (interests and tags), occasion match, style match, and price proximity.
7. **Explainable Reasons**: Natural-language sentences are generated dynamically for each category (e.g., *"Matches the skincare interest and birthday occasion."*). Numeric scores are never shown to the user.

> [!NOTE]
> **ML ranking is on the roadmap; the current engine is rule-based and deterministic.**

```mermaid
flowchart TD
    A["Flutter Mobile App"] -->|"POST /api/v1/recommendations"| B["FastAPI Endpoint"]
    B --> C["Input Validation (Pydantic v2)"]
    C --> D["Category Qualification<br/>(Must match &ge;1 interest)"]
    D --> E["Rule-Based Scoring<br/>(+3 Interest, +3 Occasion, +1 Relation, +1-2 Style)"]
    E --> F["Strict Budget Filter<br/>(Exclude items > budget)"]
    F --> G["Select Top 4 Categories<br/>(Tie-break by focus)"]
    G --> H["Rank In-Budget Products"]
    H --> I["Generate Human Reasons"]
    I -->|"HTTP 200 JSON Response"| A
```

---

## 🔌 API

- **Base URL**: `https://ai-genius-backend.fastapicloud.dev`
- **Interactive Documentation**: [https://ai-genius-backend.fastapicloud.dev/docs](https://ai-genius-backend.fastapicloud.dev/docs)

> [!NOTE]
> The backend is deployed on a free cloud tier. The server may take up to 60 seconds to spin up on cold start when first accessed. The Flutter app has a configured 60-second timeout with an informative loading status to handle this gracefully.

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/health` | Server and database health check (`{"status": "ok", "version": "1.0.0", "database": "ok"}`) |
| `POST` | `/api/v1/recommendations` | Generates ranked gift categories and products within budget |
| `GET` | `/api/v1/products/{id}` | Fetches details for an individual product by UUID |

### Example Request (`POST /api/v1/recommendations`)

```json
{
  "relationship": "mother",
  "age_group": "40_49",
  "gender": "female",
  "occasion": "birthday",
  "budget": 3500,
  "interests": ["beauty", "skincare"],
  "gift_styles": ["elegant", "practical"],
  "additional_details": "She likes simple skincare products."
}
```

### Trimmed Example Response (`200 OK`)

```json
{
  "request_id": "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d",
  "budget": 3500,
  "currency": "PKR",
  "categories": [
    {
      "id": "skincare_gift_set",
      "name": "Skincare Gift Set",
      "reason": "Matches the skincare interest and birthday occasion.",
      "icon": "spa",
      "product_count": 3,
      "products": [
        {
          "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
          "name": "4-Step Skincare Whitening Facial Kit",
          "description": "Complete glowing skin care routine set.",
          "price": 2499,
          "currency": "PKR",
          "image_url": "https://img.drz.lazcdn.com/g/kf/S91b98a12e52b47e2a969bba2e9b27d42L.jpg",
          "store_name": "Daraz",
          "store_url": "https://www.daraz.pk/products/arena-gold-4-step-skincare-whitening-facial-kit-skin-brightening-combo-best-facial-serum-cream-milky-facewash-bb-cream-for-glowing-skin-i1963170836.html",
          "category_id": "skincare_gift_set",
          "tags": ["skincare", "beauty"],
          "availability": "in_stock",
          "source": "curated",
          "last_updated": "2026-10-08T03:25:39Z"
        }
      ]
    }
  ]
}
```

### Standardized Error Format

All error responses strictly follow the contract shape:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Input should be greater than or equal to 500",
    "details": []
  }
}
```

Standard error codes: `VALIDATION_ERROR` (422 or 413 for payloads > 64 KB), `NOT_FOUND` (404), `METHOD_NOT_ALLOWED` (405), `RATE_LIMITED` (429), `DATABASE_ERROR` (503), `INTERNAL_ERROR` (500).

---

## 🛠️ Tech Stack

### Mobile Frontend

| Technology | Purpose |
|---|---|
| **Flutter** (`^3.12.2`) | Cross-platform UI toolkit targeting Android |
| **Dart** | Programming language |
| **GetX** (`^4.7.3`) | State management, dependency injection, and route navigation |
| **Drift** (`^2.35.1`) & **sqlite3_flutter_libs** (`^0.6.0+eol`) | Local reactive SQLite persistence for saved gifts and offline history |
| **Dio** (`^5.8.0+1`) | HTTP client with timeout configuration and error mapping |
| **connectivity_plus** (`^7.3.2`) | Device network monitoring and offline awareness |
| **url_launcher** (`^6.3.3`) | External browser launching to view store listings |
| **cached_network_image** (`^4.0.3`) | Image caching with placeholder and error state support |
| **google_fonts** (`^8.2.1`) | Typography management |
| **flutter_svg** (`^2.3.0`) | Vector asset rendering |
| **shared_preferences** (`^2.5.5`) | User theme preference persistence |
| **path_provider** (`^2.1.6`) | Native filesystem directory resolution |

### Backend Service

| Technology | Purpose |
|---|---|
| **FastAPI** (`fastapi[standard]`) | High-performance Python web framework |
| **Pydantic v2** (`pydantic-settings`) | Data modeling, validation, and settings management |
| **SQLAlchemy 2** (`sqlalchemy>=2`) | Python SQL toolkit and Object-Relational Mapper (ORM) |
| **Alembic** (`alembic`) | Database schema migrations |
| **psycopg 3** (`psycopg[binary]`) | PostgreSQL database adapter for Python |
| **SlowAPI** (`slowapi`) | Endpoint rate limiting based on client IP |
| **Uvicorn** (`uvicorn[standard]`) | ASGI web server |
| **HTTPX** (`httpx`) | HTTP client used for contract testing |
| **pytest** (`pytest`) | Automated test framework |

### Database, Hosting & Tools

| Component | Technology / Platform |
|---|---|
| **Database** | PostgreSQL hosted on **Supabase** (connection pooling) |
| **Cloud Hosting** | **FastAPI Cloud** (`https://ai-genius-backend.fastapicloud.dev`) |
| **Development Tools** | VS Code / Android Studio, Flutter CLI, Android SDK, Git |

---

## 📂 Project Structure

```text
ai_genius/
├── app/                                # Flutter mobile application
│   ├── lib/
│   │   ├── core/                       # App-wide config, network, theme, and widgets
│   │   ├── data/                       # Drift local SQLite database, models, and repositories
│   │   ├── modules/                    # Feature modules (home, results, product, saved, history, etc.)
│   │   ├── routes/                     # GetX route declarations and page bindings
│   │   └── main.dart                   # Flutter application entrypoint
│   ├── test/                           # 110 Flutter unit, widget, and integration tests
│   └── pubspec.yaml                    # Flutter dependencies and asset configuration
├── backend/                            # FastAPI backend service
│   ├── alembic/                        # Alembic migration scripts
│   ├── app/
│   │   ├── api/                        # API routes (health, recommendations, products)
│   │   ├── core/                       # Config, database engine, error handlers, and rate limiter
│   │   ├── models/                     # SQLAlchemy ORM models (Product, GiftCategory)
│   │   ├── repositories/               # Database query operations
│   │   ├── schemas/                    # Pydantic v2 schemas and validation enums
│   │   ├── services/                   # Business logic (Recommender, ProductService)
│   │   └── main.py                     # FastAPI application setup and middleware
│   ├── data/                           # Catalog CSVs, product logs, and reviews
│   ├── tests/                          # 49 backend pytest tests
│   ├── requirements.txt                # Python package dependencies
│   └── alembic.ini                     # Database migration configuration
├── docs/
│   └── api_contract.md                 # Shared v1 API contract specification
├── assets/
│   └── screenshots/                    # Screenshots used in documentation
├── scripts/
│   ├── import_catalog_csv.py           # Catalog import and upsert script
│   └── check_links.py                  # Catalog URL and price verification script
├── LICENSE                             # MIT License
└── README.md                           # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.12.2` (Dart `^3.12.2`)
- **Android Studio** or Android SDK (with emulator or connected Android device)
- **Python**: `3.12+`
- **PostgreSQL / Supabase** account (or local PostgreSQL instance)

---

### Backend Setup

1. **Navigate to the backend directory and activate a virtual environment**:
   - **Windows (PowerShell)**:
     ```powershell
     cd backend
     python -m venv .venv
     .venv\Scripts\activate
     ```
   - **macOS / Linux**:
     ```bash
     cd backend
     python3 -m venv .venv
     source .venv/bin/activate
     ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Configure environment variables**:
   Copy `.env.example` to `.env` and fill in your database connection string:
   - **Windows**: `copy .env.example .env`
   - **macOS / Linux**: `cp .env.example .env`

4. **Apply database migrations**:
   ```bash
   alembic upgrade head
   ```

5. **Import product catalog data**:
   ```bash
   python scripts/import_catalog_csv.py
   ```

6. **Start the local development server**:
   ```bash
   uvicorn app.main:app --reload
   ```
   Interactive Swagger docs will be available at `http://127.0.0.1:8000/docs`.

---

### App Setup

1. **Navigate to the app directory and install dependencies**:
   ```bash
   cd app
   flutter pub get
   ```

2. **Configure API base URL**:
   The app connects by default to the live cloud API (`https://ai-genius-backend.fastapicloud.dev`). To point to a local backend, adjust `app/lib/core/config/app_config.dart`:
   - For Android Emulator: `AppConfig.useEmulator()` (`http://10.0.2.2:8000`)
   - For Desktop / Web: `AppConfig.setBaseUrl('http://127.0.0.1:8000')`

3. **Run the app**:
   ```bash
   flutter run
   ```

---

### Environment Variables

| Variable | Required | Example | Description |
|---|---|---|---|
| `DATABASE_URL` | Yes | `postgresql+psycopg://user:password@host:5432/postgres` | PostgreSQL connection string |
| `ALLOWED_ORIGINS` | No | `*` (or `http://localhost:3000`) | CORS allowed origin domains |
| `ENVIRONMENT` | No | `development` / `production` | Operational runtime environment |

> [!SECURITY]
> Real database passwords, API keys, and connection credentials must **NEVER** be committed to version control. They are kept in local `.env` files (ignored in `.gitignore`) and set securely in cloud environment dashboards.

---

## 🧪 Testing

The repository maintains an automated test suite across both the mobile frontend and backend service.

### Running Backend Tests
Execute pytest inside the backend virtual environment:

```powershell
# From backend directory
pytest
```

The backend test suite contains **49 automated tests** (all passing):
- `test_api_v1.py` (16 tests): API endpoints, header validation, rate limiter isolation, and 413/422 payload boundaries.
- `test_health.py` (2 tests): Healthy and degraded database states.
- `test_integration_contract.py` (13 tests): End-to-end API budget tests, contract key assertion, and data-leak prevention (ensuring database credentials or stack traces are never exposed).
- `test_recommender.py` (10 tests): Recommendation qualification rules, scoring calculation, tie-breaking, and product sorting.
- `test_schemas.py` (8 tests): Pydantic input validation, boundary tests, and extra field rejection.

### Running Flutter Tests
Execute the Flutter test suite from the `app` directory:

```bash
cd app
flutter test
```

The app suite contains **110 automated tests** covering widget rendering, user flows, responsive layouts, theme switching, Drift SQLite persistence, and offline fallback behavior.

---

## 📦 Catalog and Data Disclaimer

- **Hand-Curated Catalog**: The demo catalog consists of **48 products** hand-collected from public listings on Daraz Pakistan (`daraz.pk`).
- **Indicative Information**: Listed prices and availability are indicative snapshots from collection time and may change on the actual merchant site.
- **Product Media**: Product images are referenced directly from public merchant CDNs.
- **Independent Project**: This project is an independent educational demonstration and is **not affiliated with, authorized, maintained, sponsored, or endorsed by Daraz**.

---

## 🗺️ What I Built (Project Journey)

1. **Phased Requirements Specification**: Outlined functional requirements, user stories, and strict budget rules before implementation.
2. **Flutter Mobile UI**: Built 9 screens featuring a deep purple (`#171A29`) and yellow accent palette supporting light and dark modes.
3. **Local Database & Offline Mode**: Implemented Drift (SQLite) tables for offline storage of saved gifts and previous recommendation queries.
4. **FastAPI Backend & Migrations**: Developed a REST service using SQLAlchemy 2, Alembic migrations, and PostgreSQL on Supabase.
5. **Verified Pakistani Product Catalog**: Hand-curated, structured, and double-checked 48 products across diverse price points and gift categories.
6. **Deterministic Recommendation Engine**: Designed an explainable, rule-based recommendation algorithm with strict server-enforced budget limits.
7. **Unified API Contract**: Co-designed and documented the REST API contract (`docs/api_contract.md`) shared by both app and backend.
8. **Automated Test Coverage**: Built 49 backend pytest tests and 110 Flutter tests verifying contract compliance, budget limits, and error handling.
9. **Cloud Deployment**: Deployed the backend service to FastAPI Cloud.
10. **Full End-to-End Integration**: Connected the Flutter client to the live cloud backend with offline recovery and timeout handling.

---

## 🧗 Challenges and How I Solved Them

| Challenge | Solution |
|---|---|
| **Initial AI-collected product data contained errors**: Approximately 30% of the initial batch had dead links, inaccurate prices, or links pointing to mismatched products. | Performed an independent second review pass reopening every single product URL in the browser, removed and replaced invalid items, cleared wrong images, and manually verified 10 random products (all 100% correct). |
| **Recommender suggested unrelated categories**: The engine occasionally returned an irrelevant category simply because the occasion matched. | Implemented a qualification rule where a category must match at least one requested interest to qualify, backed by unit tests, and introduced a focus tie-breaker. |
| **Equal scores ordered alphabetically by accident**: Categories with matching scores defaulted to arbitrary alphabetical ordering. | Implemented a tie-breaker prioritizing interest focus (`matched_interests / category_interests`) followed by category-relationship metadata. |
| **Payment card required for free hosting**: The initially evaluated hosting provider required credit card details to verify a free account. | Switched to FastAPI Cloud, which allowed deployment of the service without requiring a credit card. |
| **Deployment hung on "Verifying Readiness"**: The cloud host runs applications using the `fastapi` CLI command, which failed because `requirements.txt` initially specified bare `fastapi`. | Updated `requirements.txt` to `fastapi[standard]`, which includes the required CLI tools and dependencies. |
| **Rate limiting behind reverse proxy grouped all users**: SlowAPI initially counted all requests from the proxy as a single client IP. | Configured Uvicorn and SlowAPI to read client IP addresses from the `X-Forwarded-For` header and added tests to verify quota isolation across client IPs. |
| **Store prices change across variants and time**: Products on eCommerce stores vary frequently by size, seller, and time. | Treated prices as indicative, added clear "price may change" guidance in the app UI, and built a `check_links.py` script to monitor catalog health. |
| **Free-tier server cold starts take up to 60 seconds**: Inactive cloud containers sleep and require up to a minute to boot on initial request. | Configured a 60-second client timeout in Dio and displayed a descriptive "Waking up server..." status message in the app loading screen. |

---

## 🔮 Roadmap & Future Technology

- [ ] **ML Ranking Model**: Train a machine learning ranking model in Google Colab (scikit-learn or LightGBM) benchmarked against the deterministic rule-based baseline. *(Not built yet)*
- [ ] **Catalog Expansion**: Expand the catalogue from ~50 products to several hundred across additional categories (e.g., sports accessories, watches, perfumes, stationery) through manual curation and authorized product feeds or APIs. *(Not built yet)*
- [ ] **Automated Refresh Job**: Add a scheduled background job to verify product links and refresh pricing periodically. *(Not built yet)*
- [ ] **Live Authorized Data**: Ingest real-time product availability and pricing from authorized affiliate or merchant APIs. *(Not built yet)*
- [ ] **Shared Rate Limiting**: Migrate in-memory rate limiting to distributed Redis storage for scalable multi-instance deployment. *(Not built yet)*
- [ ] **Continuous Integration (CI)**: Implement GitHub Actions workflows to run Flutter and pytest test suites automatically on pull requests. *(Not built yet)*
- [ ] **Containerization**: Create Dockerfile and Docker Compose configurations for containerized backend deployments. *(Not built yet)*
- [ ] **iOS Platform Support**: Build and test the Flutter client on iOS devices. *(Not built yet)*
- [ ] **User Feedback Mechanism**: Allow users to rate suggestions (thumbs up/down) to collect evaluation data for future ML ranking. *(Not built yet)*
- [ ] **Natural Language Requests**: Add support for parsing unstructured natural-language gift descriptions into preference attributes. *(Not built yet)*

---

## 👤 Author

**Shahbaz Devv**

[![GitHub](https://img.shields.io/badge/GitHub-ShahbazDevv-181717?style=flat&logo=github)](https://github.com/ShahbazDevv)
[![Portfolio](https://img.shields.io/badge/Portfolio-Shahbaz%20Devv-blue?style=flat&logo=google-chrome&logoColor=white)](https://shahbaz-flutter.vercel.app/)

- 🌐 Portfolio: [shahbaz-flutter.vercel.app](https://shahbaz-flutter.vercel.app/)
- 💻 GitHub: [@ShahbazDevv](https://github.com/ShahbazDevv)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](file:///d:/Flutter%20Projects/ai_genius/LICENSE) file for details.

Copyright (c) 2026 ShahbazDevv

---

<div align="center">

Made with ❤️ and Flutter

⭐ Star this repository if you find it helpful!

</div>
