# NYC Yellow Taxi — Snowflake Data Pipeline

End-to-end data pipeline for the **NYC TLC Yellow Taxi Trip Records** dataset, built on Snowflake using the **Medallion Architecture** (Bronze → Silver → Gold).

## Architecture

```
[NYC TLC Source]
      │
      ▼
┌──────────────────────────────────┐
│  BRONZE  NYC_TAXI_RAW            │
│  TAXI_BRONZE   (3.8M rows)       │
│  TAXI_ZONE_D   (263 zones)       │
│  All VARCHAR — raw as received   │
└──────────────┬───────────────────┘
               │  transform_bronze_to_silver.sql
               ▼
┌──────────────────────────────────┐
│  SILVER  TAXI_SILVER             │
│  TAXI_PRATA   (3.8M rows)        │
│  Typed, cleaned, quality-filtered│
└──────────────┬───────────────────┘
               │  populate_dim_date.sql
               ▼
┌──────────────────────────────────┐
│  GOLD  TAXI_OURO                 │
│  DIM_DATE   (3.8M rows)          │
│  Analytical / time-series layer  │
└──────────────────────────────────┘
```

## Repository Structure

```
sql/
├── 01_bronze/
│   ├── create_database_and_schemas.sql
│   ├── create_taxi_bronze.sql
│   └── create_taxi_zone_lookup.sql
├── 02_silver/
│   ├── create_taxi_silver.sql
│   └── transform_bronze_to_silver.sql
└── 03_gold/
    ├── create_dim_date.sql
    ├── populate_dim_date.sql
    └── analytical_queries.sql
docs/
├── architecture.md
└── data_dictionary.md
```

## Tech Stack

- **Snowflake** — cloud data warehouse
- **SQL** — all transformations
- **Medallion Architecture** — Bronze / Silver / Gold
- **Dataset** — NYC TLC Yellow Taxi Trip Records (public)

## Key Design Decisions

| Decision | Why |
|---|---|
| All Bronze columns are VARCHAR | Prevents load failures from format drift or unexpected NULLs |
| `TRY_TO_*` functions in Silver | Failed casts return NULL — no aborted loads |
| Quality filters on Silver INSERT | Rejects negative fares, zero passengers, inverted timestamps |
| `NULLIF` in tip % calculation | Guards against division by zero on zero-fare rows |

## Running the Pipeline

```sql
-- 1. Setup
snowsql -f sql/01_bronze/create_database_and_schemas.sql
snowsql -f sql/01_bronze/create_taxi_bronze.sql
snowsql -f sql/01_bronze/create_taxi_zone_lookup.sql

-- 2. Load raw data (Parquet from TLC website)
-- See docs/architecture.md for COPY INTO instructions

-- 3. Transform
snowsql -f sql/02_silver/create_taxi_silver.sql
snowsql -f sql/02_silver/transform_bronze_to_silver.sql

-- 4. Build Gold layer
snowsql -f sql/03_gold/create_dim_date.sql
snowsql -f sql/03_gold/populate_dim_date.sql

-- 5. Run analytical queries
snowsql -f sql/03_gold/analytical_queries.sql
```

## Data Source

[NYC TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) — public dataset, no sensitive information.
