# Architecture — NYC Taxi Snowflake Pipeline

## Medallion Architecture

```
[NYC TLC Source]
      │
      ▼
┌─────────────────────────────────────┐
│  BRONZE: TAXI_NYC.NYC_TAXI_RAW      │
│  TAXI_BRONZE   (3.8M rows, ~72 MB)  │
│  TAXI_ZONE_D   (263 rows)           │
│  All columns: VARCHAR               │
└──────────────┬──────────────────────┘
               │ transform_bronze_to_silver.sql
               ▼
┌─────────────────────────────────────┐
│  SILVER: TAXI_NYC.TAXI_SILVER       │
│  TAXI_PRATA   (3.8M rows, ~98 MB)  │
│  Typed: TIMESTAMP_NTZ, FLOAT, etc.  │
│  Quality filters applied            │
└──────────────┬──────────────────────┘
               │ populate_dim_date.sql
               ▼
┌─────────────────────────────────────┐
│  GOLD: TAXI_NYC.TAXI_OURO           │
│  DIM_DATE   (3.8M rows, ~53 MB)    │
│  Analytical / time-series layer     │
└─────────────────────────────────────┘
```

## Why Medallion?

Separating layers by concern means:
- **Bronze** preserves the raw source exactly as received — the source of truth for re-processing.
- **Silver** enforces business rules once, cleanly. A Silver bug is fixed by re-running one script.
- **Gold** serves analytical consumers without coupling them to Silver complexity.

## Why VARCHAR in Bronze?

Loading directly into typed columns fails when:
- A vendor sends NULL where a number is expected
- A timestamp format changes between monthly files
- New columns appear mid-year

`TRY_TO_*` functions in `transform_bronze_to_silver.sql` handle casting gracefully — failed casts return NULL instead of aborting the load.

## Loading Raw Data

```sql
-- 1. Create an internal stage
CREATE OR REPLACE STAGE TAXI_NYC.NYC_TAXI_RAW.RAW_STAGE
  FILE_FORMAT = (TYPE = 'PARQUET');

-- 2. Upload via SnowSQL or Snowsight UI, then:
COPY INTO TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE
FROM @TAXI_NYC.NYC_TAXI_RAW.RAW_STAGE/yellow_tripdata_2024-01.parquet
FILE_FORMAT = (TYPE = 'PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
```

## Data Source

NYC TLC Yellow Taxi Trip Records — public dataset.
https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
