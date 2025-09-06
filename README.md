# PriceCheck PH

Give Filipinos a clear view of common products (grocery, sari‑sari store, talipapa/wet markets) with **estimated prices** and **where those prices were seen**. Start small, get useful, then scale.

I really want this to happen. Something we filipinos could be proud of. A software product that can innovate created by filipinos.

---

## Vision

A trustworthy, community‑aware price reference that:

* Normalizes prices to fair units (₱/kg, ₱/L, ₱/100g) so people compare apples to apples.
* Shows **what’s typical** (median), **what’s cheap** (p10), and **what’s expensive** (p90) for a product in a city/market.
* Clearly labels **source, location, and date** for every price.
* Uses AI to detect outliers, fill missing metadata (e.g., pack size), and surface trends without fabricating facts.

## Non‑Goals (for now)

* No live crawling of every store in the Philippines.
* No price guarantees. This is a **reference**, not a promise.
* No personal data collection beyond what’s required for accounts and moderation.

---

## MVP (v0.1)

**Scope:** 10–20 staple items. Search → Product → Price list. Local database only.

* Product list with search
* Product detail: unit price math, latest prices (with store/city/date)
* Favorites (local)
* Manual “Add Price” form
* Optional: barcode scan to attach GTIN to product

**Definition of Done:** a user can pick rice/sardines/detergent, see SRP (if available) and two or more recent prices with dates, and decide where to buy.

---

## Data & Legality (read before coding)

**We only use data that is: (a) public domain or (b) explicitly permitted or (c) user‑contributed.**

Checklist:

* Respect robots.txt and Terms of Service for every site.
* Attribute sources in‑app (name, URL, last fetched date).
* Store the **timestamp and source** with each price.
* If users upload receipts/photos, redact personal info on‑device (names, card tail, QR with PII) before upload.
* Provide a **takedown path** for any data owner.

**User‑Contributed Prices**

* Require store, city, price, date, optional photo.
* Moderate with automatic checks (unit‑price outliers) + community flags.
* Mark user entries as “Unverified” until they pass basic heuristics.

---

## Architecture (planned)

```
app/ (Flutter)
  lib/
    core/        # unit conversion, price math
    data/        # repository layer
    features/
      search/
      product_detail/
      favorites/
    services/
      barcode/
      storage/   # sqflite, shared_prefs

api/ (FastAPI or Node/Fastify) – Phase 3
  routes/: products, prices, srp
  workers/: source ingestors (DTI SRP, DA markets, retailer APIs where allowed)
  db/: migrations (PostgreSQL)
```

---

## Minimal Data Model (Phase 1: SQLite)

```sql
CREATE TABLE products(
  id TEXT PRIMARY KEY,
  gtin TEXT,           -- barcode (EAN-13), nullable
  name TEXT NOT NULL,
  brand TEXT,
  size_value REAL,     -- 155, 1.0, 5.0
  size_unit TEXT       -- g, kg, ml, L
);

CREATE TABLE prices(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id TEXT NOT NULL REFERENCES products(id),
  store TEXT,
  city TEXT,
  price REAL NOT NULL,
  collected_at TEXT NOT NULL  -- ISO date string
);

CREATE TABLE srp(
  product_id TEXT PRIMARY KEY REFERENCES products(id),
  srp_price REAL NOT NULL,
  effective_date TEXT
);

CREATE INDEX idx_prices_product_time ON prices(product_id, collected_at DESC);
```

**Unit Price Rules (display)**

* If unit is `g` or `kg` → show ₱/kg
* If unit is `ml` or `L` → show ₱/L
* If ambiguous (e.g., diapers per pack) → show per‑pack and optionally per‑unit where applicable

---

## Quickstart (MVP local prototype)

1. Scaffold

   ```bash
   flutter create pricecheck_ph
   cd pricecheck_ph
   flutter pub add intl provider
   # later: sqflite, mobile_scanner
   ```
2. Seed data

   * Put `assets/data/products.json` with \~10 items and 2–3 sample prices each.
   * Wire asset loading in `pubspec.yaml`.
3. Implement 3 screens

   * Home/Search → list + filter
   * Product Detail → SRP, best price, unit price, price history
   * Favorites → stored locally
4. Price math helper

   * `lib/core/pricing.dart` with unit conversion and per‑unit computation

---

## Roadmap

* **v0.1**: Local prototype (no backend), barcode optional
* **v0.2**: SQLite storage, price history chart, import/export CSV
* **v0.3**: Small backend sync (auth, products, prices, SRP)
* **v0.4**: Source ingestors (DTI SRP, DA markets), moderation & flags
* **v0.5**: Price alerts, simple AI outlier detection, auto size parsing

---

## AI Features (scoped and safe)

* **Outlier detection**: z‑score on normalized prices per category & location.
* **Auto‑complete metadata**: infer `size_value` + `size_unit` from name (e.g., “Tuna 155g”).
* **Trend summaries**: per product per city: “Down 5% vs 30‑day median.”
* **Deduplication**: name/brand/size fuzzy matching to merge near‑duplicates.

We never fabricate prices. AI only assists with cleaning and summarization.

---

## Contribution Guidelines (short)

* One feature per PR, with screenshots.
* Include sample data changes under `assets/data` for UI features.
* Tests for price math and unit conversions.
* Be explicit about data source and license for any new ingestor.

---

## License

Choose later: MIT (simple) or MPL‑2.0 (encourages sharing improvements). For now, code is © contributors; external datasets retain their original licenses.

---

## Glossary

* **Sari‑sari store**: neighborhood convenience kiosk, often cash only.
* **Talipapa**: small/wet market, produce/meat/fish; prices vary daily.
* **SRP**: Suggested Retail Price (government guidance for some goods).

---

## Risks & Mitigations

* **Stale data** → show timestamps prominently; sort by freshness.
* **Bad submissions** → combine heuristics, reputation, and photo checks.
* **Legal concerns** → follow TOS, partner where needed, and provide takedown.

---

## Maintainers

TBD (this is your passion project—add your name and contact).
