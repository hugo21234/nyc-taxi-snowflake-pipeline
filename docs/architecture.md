# Architecture — NYC Taxi Snowflake Pipeline

## Medallion Architecture

```
[NYC TLC Parquet files]
        |
        v
[STAGE: NYC_TAXI_RAW.RAW_STAGE]
        |
   COPY INTO
        |
        v
[BRONZE: NYC_TAXI_RAW.TAXI_BRONZE]   <-- all VARCHAR, raw landing
        |
   INSERT ... SELECT (TRY_TO_* casts + quality filters)
        |
        v
[SILVER: TAXI_SILVER.TAXI_PRATA]     <-- typed, cleaned
        |
   Analytical queries + DIM_DATE
        |
        v
[GOLD: TAXI_OURO.*]                  <-- aggregated, consumer-ready
```

## Why all VARCHAR in Bronze?

Loading Parquet/CSV directly into typed columns breaks when:
- A vendor sends a NULL where a number is expected
- A timestamp format changes between monthly files
- A new column appears mid-year

All Bronze columns land as `VARCHAR`. `TRY_TO_*` functions in the Silver
transformation handle type coercion gracefully — failed casts become `NULL`
instead of aborting the entire load.

## Why `TRY_TO_*` instead of `CAST`?

`CAST('bad_value' AS FLOAT)` raises an error and stops the query.
`TRY_TO_DOUBLE('bad_value')` returns `NULL` and continues.
In production pipelines, you want bad rows isolated, not the job killed.

## Data Source

NYC TLC Yellow Taxi Trip Records — public dataset, no PII.
https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

## Warehouse Used

Snowflake `COMPUTE_WH` (X-Small, auto-suspend 60s).
