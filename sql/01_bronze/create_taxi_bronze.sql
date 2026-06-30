-- Bronze Layer: Raw ingestion table
-- All columns are VARCHAR intentionally — avoids load failures on type mismatches.
-- Type enforcement happens in the Silver layer (TAXI_PRATA).

CREATE OR REPLACE TABLE TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE (
    VENDORID              VARCHAR,
    TPEP_PICKUP_DATETIME  VARCHAR,
    TPEP_DROPOFF_DATETIME VARCHAR,
    PASSENGER_COUNT       VARCHAR,
    TRIP_DISTANCE         VARCHAR,
    RATECODEID            VARCHAR,
    STORE_AND_FWD_FLAG    VARCHAR,
    PULOCATIONID          VARCHAR,   -- Pickup LocationID (FK -> TAXI_ZONE_D)
    DOLOCATIONID          VARCHAR,   -- Dropoff LocationID (FK -> TAXI_ZONE_D)
    PAYMENT_TYPE          VARCHAR,
    FARE_AMOUNT           VARCHAR,
    EXTRA                 VARCHAR,
    MTA_TAX               VARCHAR,
    TIP_AMOUNT            VARCHAR,
    TOLLS_AMOUNT          VARCHAR,
    IMPROVEMENT_SURCHARGE VARCHAR,
    TOTAL_AMOUNT          VARCHAR,
    CONGESTION_SURCHARGE  VARCHAR,
    AIRPORT_FEE           VARCHAR,
    CBD_CONGESTION_FEE    VARCHAR
);
