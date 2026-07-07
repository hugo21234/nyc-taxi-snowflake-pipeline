-- ============================================================
-- Camada Gold DML: carga de DIM_DATA a partir da Silver
-- ============================================================

INSERT INTO TAXI_NYC.TAXI_GOLD.DIM_DATA (
    DATE_VALUE,
    YEAR,
    MONTH,
    DAY,
    DAY_OF_WEEK,
    IS_WEEKEND
)
SELECT DISTINCT
    DATE(TPEP_PICKUP_DATETIME)                                   AS DATE_VALUE,
    YEAR(TPEP_PICKUP_DATETIME)                                   AS YEAR,
    MONTH(TPEP_PICKUP_DATETIME)                                  AS MONTH,
    DAY(TPEP_PICKUP_DATETIME)                                    AS DAY,
    DAYOFWEEK(TPEP_PICKUP_DATETIME)                              AS DAY_OF_WEEK,
    IFF(DAYOFWEEK(TPEP_PICKUP_DATETIME) IN (0, 6), TRUE, FALSE) AS IS_WEEKEND
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
WHERE TPEP_PICKUP_DATETIME IS NOT NULL;
