-- ═══════════════════════════════════════════════════════════
-- Bronze → Silver Transformation
-- TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE → TAXI_NYC.TAXI_SILVER.TAXI_PRATA
--
-- Applies: type casting, null filtering, basic quality rules
-- TRY_TO_* functions: failed casts return NULL (no load failures)
-- Run after COPY INTO TAXI_BRONZE from stage
-- ═══════════════════════════════════════════════════════════

INSERT INTO TAXI_NYC.TAXI_SILVER.TAXI_PRATA
SELECT
    TRY_TO_TIMESTAMP(TPEP_PICKUP_DATETIME)    AS TPEP_PICKUP_DATETIME,
    TRY_TO_TIMESTAMP(TPEP_DROPOFF_DATETIME)   AS TPEP_DROPOFF_DATETIME,
    TRY_TO_NUMBER(PASSENGER_COUNT)            AS PASSENGER_COUNT,
    TRY_TO_DOUBLE(TRIP_DISTANCE)              AS TRIP_DISTANCE,
    VENDORID                                  AS VENDOR_ID,
    RATECODEID                                AS RATECODE_ID,
    PULOCATIONID                              AS PU_LOCATION_ID,
    DOLOCATIONID                              AS DO_LOCATION_ID,
    PAYMENT_TYPE,
    TRY_TO_DOUBLE(FARE_AMOUNT)                AS FARE_AMOUNT,
    TRY_TO_DOUBLE(EXTRA)                      AS EXTRA,
    TRY_TO_DOUBLE(MTA_TAX)                    AS MTA_TAX,
    TRY_TO_DOUBLE(TIP_AMOUNT)                 AS TIP_AMOUNT,
    TRY_TO_DOUBLE(TOLLS_AMOUNT)               AS TOLLS_AMOUNT,
    TRY_TO_DOUBLE(IMPROVEMENT_SURCHARGE)      AS IMPROVEMENT_SURCHARGE,
    TRY_TO_DOUBLE(TOTAL_AMOUNT)               AS TOTAL_AMOUNT,
    TRY_TO_DOUBLE(CONGESTION_SURCHARGE)       AS CONGESTION_SURCHARGE,
    TRY_TO_DOUBLE(AIRPORT_FEE)                AS AIRPORT_FEE,
    TRY_TO_DOUBLE(CBD_CONGESTION_FEE)         AS CBD_CONGESTION_FEE

FROM TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE

WHERE
    -- Quality filters: reject structurally invalid rows
    TPEP_PICKUP_DATETIME  IS NOT NULL
    AND TPEP_DROPOFF_DATETIME IS NOT NULL
    AND TRY_TO_NUMBER(PASSENGER_COUNT)  > 0
    AND TRY_TO_DOUBLE(TRIP_DISTANCE)    > 0
    AND TRY_TO_DOUBLE(FARE_AMOUNT)      > 0
    -- Temporal sanity: pickup must precede dropoff
    AND TRY_TO_TIMESTAMP(TPEP_PICKUP_DATETIME)
        < TRY_TO_TIMESTAMP(TPEP_DROPOFF_DATETIME);
