-- ═══════════════════════════════════════════════════════════
-- Bronze Layer: TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE
-- Source: NYC TLC Yellow Taxi Trip Records (Parquet)
--
-- Design decision: ALL columns are VARCHAR intentionally.
-- Loading into typed columns breaks on NULL, format changes,
-- and mid-year schema drift. TRY_TO_* in Silver handles casting.
-- ═══════════════════════════════════════════════════════════

CREATE OR REPLACE TABLE TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE (
    VENDORID              VARCHAR,   -- 1=Creative Mobile Technologies, 2=VeriFone
    TPEP_PICKUP_DATETIME  VARCHAR,   -- Trip start timestamp (raw string)
    TPEP_DROPOFF_DATETIME VARCHAR,   -- Trip end timestamp (raw string)
    PASSENGER_COUNT       VARCHAR,   -- Number of passengers (driver-entered)
    TRIP_DISTANCE         VARCHAR,   -- Miles traveled (taximeter)
    RATECODEID            VARCHAR,   -- 1=Standard, 2=JFK, 3=Newark, 4=Nassau/Westchester, 5=Negotiated, 6=Group
    STORE_AND_FWD_FLAG    VARCHAR,   -- Y=trip held in memory before send, N=live transmission
    PULOCATIONID          VARCHAR,   -- TLC Pickup Zone ID (FK → TAXI_ZONE_D.LOCATION_ID)
    DOLOCATIONID          VARCHAR,   -- TLC Dropoff Zone ID (FK → TAXI_ZONE_D.LOCATION_ID)
    PAYMENT_TYPE          VARCHAR,   -- 1=Credit card, 2=Cash, 3=No charge, 4=Dispute, 5=Unknown
    FARE_AMOUNT           VARCHAR,   -- Base metered fare
    EXTRA                 VARCHAR,   -- Miscellaneous extras (rush hour/overnight surcharges)
    MTA_TAX               VARCHAR,   -- $0.50 MTA tax
    TIP_AMOUNT            VARCHAR,   -- Auto-populated for credit card tips
    TOLLS_AMOUNT          VARCHAR,   -- Total tolls paid
    IMPROVEMENT_SURCHARGE VARCHAR,   -- $0.30 surcharge for hailed trips at flag drop
    TOTAL_AMOUNT          VARCHAR,   -- Total charged to passenger (excl. cash tips)
    CONGESTION_SURCHARGE  VARCHAR,   -- NYC congestion pricing surcharge
    AIRPORT_FEE           VARCHAR,   -- $1.25 pickup fee at LGA or JFK
    CBD_CONGESTION_FEE    VARCHAR    -- Central Business District congestion fee
);
