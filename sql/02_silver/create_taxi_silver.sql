-- ═══════════════════════════════════════════════════════════
-- Silver Layer: TAXI_NYC.TAXI_SILVER.TAXI_PRATA
-- Typed, cleaned trip data. Enforces proper data types
-- after Bronze landing. VARCHAR columns that remain are
-- categorical IDs, not free text.
-- ═══════════════════════════════════════════════════════════

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_SILVER.TAXI_PRATA (
    TPEP_PICKUP_DATETIME   TIMESTAMP_NTZ(9),  -- Trip start (cast from Bronze VARCHAR)
    TPEP_DROPOFF_DATETIME  TIMESTAMP_NTZ(9),  -- Trip end (cast from Bronze VARCHAR)
    PASSENGER_COUNT        NUMBER(38,0),       -- Integer count of passengers
    TRIP_DISTANCE          FLOAT,              -- Miles traveled
    VENDOR_ID              VARCHAR,            -- 1=Creative Mobile, 2=VeriFone
    RATECODE_ID            VARCHAR,            -- Rate category code
    PU_LOCATION_ID         VARCHAR,            -- Pickup TLC Zone ID (FK → TAXI_ZONE_D.LOCATION_ID)
    DO_LOCATION_ID         VARCHAR,            -- Dropoff TLC Zone ID (FK → TAXI_ZONE_D.LOCATION_ID)
    PAYMENT_TYPE           VARCHAR,            -- 1=Credit, 2=Cash, 3=No charge, 4=Dispute
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
