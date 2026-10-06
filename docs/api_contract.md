# AI Genius: API Contract (v1)

Base URL (local): http://localhost:8000
All endpoints under /api/v1 except /health. All requests and responses are JSON (UTF-8). No authentication in v1.

## Allowed values (lowercase, snake_case)

relationship: mother, father, friend, best_friend, partner, brother, sister, teacher, colleague, other
age_group: 5_9, 10_19, 20_24, 25_29, 30_39, 40_49, 50_plus
gender (optional, may be null): male, female, unspecified
occasion: birthday, wedding, anniversary, graduation, engagement, thank_you, valentines_day, eid, christmas, other
interests (list, 1 to 6 items): beauty, skincare, makeup, books, technology, computer_gadgets, mobile_accessories, sports, cricket, fitness, fashion, jewelry, gaming, travel, home_lifestyle, food, art_crafts, other
gift_styles (list, 0 to 4 items): practical, elegant, luxury, budget_friendly, personalized, sentimental, fun, minimal, self_care, experience
availability: in_stock, out_of_stock, unknown

## 1. GET /health
Response 200:
```json
{ "status": "ok", "version": "1.0.0", "database": "ok" }
```
If the database is unreachable: status "degraded", database "down" (still HTTP 200).

## 2. POST /api/v1/recommendations
Request body:
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
Rules: budget is an integer in PKR, between 500 and 15000. additional_details is optional, max 200 characters, and is stored/echoed only (not used for ranking in v1). Unknown values are rejected with a validation error.

Response 200:
```json
{
  "request_id": "string",
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
          "id": "string",
          "name": "string",
          "description": "string",
          "price": 2999,
          "currency": "PKR",
          "image_url": "https://... or null",
          "store_name": "Daraz",
          "store_url": "https://...",
          "category_id": "skincare_gift_set",
          "tags": ["skincare", "beauty"],
          "availability": "in_stock",
          "source": "sample",
          "last_updated": "2026-10-04T10:00:00Z"
        }
      ]
    }
  ]
}
```
Rules:
- categories has 0 to 4 items, ordered best first.
- Every product price MUST be less than or equal to budget. This is enforced by the backend.
- A category is returned only if it has at least 1 product within budget.
- If nothing matches, return HTTP 200 with "categories": [] (this is NOT an error).
- Each category has at most 12 products, sorted by relevance.
- Never invent products. Reasons are human-readable sentences, never scores.

## 3. GET /api/v1/products/{product_id}
Response 200: one product object (same shape as above). 404 if not found.

## Error format (all errors)
```json
{ "error": { "code": "VALIDATION_ERROR", "message": "Human readable message", "details": [ ... optional ... ] } }
```
Codes and HTTP status:
- VALIDATION_ERROR: 422
- NOT_FOUND: 404
- RATE_LIMITED: 429
- DATABASE_ERROR: 503
- INTERNAL_ERROR: 500
Never expose stack traces, SQL, file paths or secrets in error messages.

## Versioning
Breaking changes require /api/v2.
