-- ═══════════════════════════════════════════════════════════
-- Gold Layer: Populate DIM_DATE from Silver
-- Extracts only temporal columns needed for time-based analysis
-- ═══════════════════════════════════════════════════════════

INSERT INTO TAXI_NYC.TAXI_OURO.DIM_DATE (PICKUP, DROPOFF)
SELECT
    TPEP_PICKUP_DATETIME  AS PICKUP,
    TPEP_DROPOFF_DATETIME AS DROPOFF
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
WHERE
    TPEP_PICKUP_DATETIME  IS NOT NULL
    AND TPEP_DROPOFF_DATETIME IS NOT NULL;
