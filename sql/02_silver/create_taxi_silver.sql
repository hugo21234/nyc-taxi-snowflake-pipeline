-- Silver Layer: Typed, cleaned trip data
-- Enforces proper data types after Bronze landing.
-- VARCHAR columns that remain are categorical IDs, not free text.

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_SILVER.TAXI_PRATA (
    TPEP_PICKUP_DATETIME   TIMESTAMP_NTZ,
    TPEP_DROPOFF_DATETIME  TIMESTAMP_NTZ,
    PASSENGER_COUNT        NUMBER,
    TRIP_DISTANCE          FLOAT,
    VENDOR_ID              VARCHAR,
    RATECODE_ID            VARCHAR,
    PU_LOCATION_ID         VARCHAR,   -- FK -> TAXI_ZONE_D.LOCATION_ID
    DO_LOCATION_ID         VARCHAR,   -- FK -> TAXI_ZONE_D.LOCATION_ID
    PAYMENT_TYPE           VARCHAR,
    FARE_AMOUNT            FLOAT,
    EXTRA                  FLOAT,
    MTA_TAX                FLOAT,
    TIP_AMOUNT             FLOAT,
    TOLLS_AMOUNT           FLOAT,
    IMPROVEMENT_SURCHARGE  FLOAT,
    TOTAL_AMOUNT           FLOAT,
    CONGESTION_SURCHARGE   FLOAT,
    AIRPORT_FEE            FLOAT,
    CBD_CONGESTION_FEE     FLOAT
);
