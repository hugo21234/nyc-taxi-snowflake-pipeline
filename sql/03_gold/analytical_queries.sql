-- =================================================================
-- Gold Layer: Analytical Queries — NYC Yellow Taxi Pipeline
-- Dataset: NYC TLC public data (no PII, no sensitive information)
-- Source tables: TAXI_SILVER.TAXI_PRATA + NYC_TAXI_RAW.TAXI_ZONE_D
-- =================================================================


-- ── 1. Average fare by borough (pickup) ─────────────────────────
SELECT
    z.BOROUGH                        AS PICKUP_BOROUGH,
    COUNT(*)                         AS TOTAL_TRIPS,
    ROUND(AVG(t.FARE_AMOUNT), 2)     AS AVG_FARE,
    ROUND(AVG(t.TIP_AMOUNT), 2)      AS AVG_TIP,
    ROUND(AVG(t.TOTAL_AMOUNT), 2)    AS AVG_TOTAL
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA t
JOIN TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D z
    ON t.PU_LOCATION_ID = z.LOCATION_ID::VARCHAR
GROUP BY z.BOROUGH
ORDER BY TOTAL_TRIPS DESC;


-- ── 2. Trip volume and avg fare by hour of day ──────────────────
SELECT
    HOUR(TPEP_PICKUP_DATETIME)  AS PICKUP_HOUR,
    COUNT(*)                    AS TOTAL_TRIPS,
    ROUND(AVG(TOTAL_AMOUNT), 2) AS AVG_TOTAL_FARE
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
GROUP BY PICKUP_HOUR
ORDER BY PICKUP_HOUR;


-- ── 3. Payment type distribution ────────────────────────────────
-- 1=Credit card, 2=Cash, 3=No charge, 4=Dispute, 5=Unknown
SELECT
    CASE PAYMENT_TYPE
        WHEN '1' THEN 'Credit Card'
        WHEN '2' THEN 'Cash'
        WHEN '3' THEN 'No Charge'
        WHEN '4' THEN 'Dispute'
        ELSE 'Unknown'
    END                                             AS PAYMENT_METHOD,
    COUNT(*)                                        AS TOTAL_TRIPS,
    ROUND(COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (), 2)                 AS PCT_SHARE
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
GROUP BY PAYMENT_TYPE
ORDER BY TOTAL_TRIPS DESC;


-- ── 4. Top 10 pickup zones by volume ────────────────────────────
SELECT
    z.ZONE                           AS PICKUP_ZONE,
    z.BOROUGH                        AS BOROUGH,
    COUNT(*)                         AS TOTAL_TRIPS,
    ROUND(AVG(t.TRIP_DISTANCE), 2)   AS AVG_DISTANCE_MILES
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA t
JOIN TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D z
    ON t.PU_LOCATION_ID = z.LOCATION_ID::VARCHAR
GROUP BY z.ZONE, z.BOROUGH
ORDER BY TOTAL_TRIPS DESC
LIMIT 10;


-- ── 5. Average trip duration by borough ─────────────────────────
SELECT
    z.BOROUGH                                         AS PICKUP_BOROUGH,
    ROUND(AVG(
        DATEDIFF('minute',
            t.TPEP_PICKUP_DATETIME,
            t.TPEP_DROPOFF_DATETIME)
    ), 1)                                             AS AVG_DURATION_MIN,
    ROUND(AVG(t.TRIP_DISTANCE), 2)                    AS AVG_DISTANCE_MILES
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA t
JOIN TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D z
    ON t.PU_LOCATION_ID = z.LOCATION_ID::VARCHAR
WHERE
    -- Exclude outliers: trips under 1 min or over 3 hours
    DATEDIFF('minute',
        t.TPEP_PICKUP_DATETIME,
        t.TPEP_DROPOFF_DATETIME) BETWEEN 1 AND 180
GROUP BY z.BOROUGH
ORDER BY AVG_DURATION_MIN DESC;


-- ── 6. Daily trip volume and revenue trend ───────────────────────
SELECT
    DATE(TPEP_PICKUP_DATETIME)   AS TRIP_DATE,
    COUNT(*)                     AS TOTAL_TRIPS,
    ROUND(SUM(TOTAL_AMOUNT), 2)  AS TOTAL_REVENUE,
    ROUND(AVG(TOTAL_AMOUNT), 2)  AS AVG_FARE
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
GROUP BY TRIP_DATE
ORDER BY TRIP_DATE;


-- ── 7. Tip rate by payment type and borough ─────────────────────
-- NULLIF prevents division by zero on zero-fare rows
SELECT
    z.BOROUGH,
    CASE PAYMENT_TYPE
        WHEN '1' THEN 'Credit Card'
        WHEN '2' THEN 'Cash'
        ELSE 'Other'
    END                                               AS PAYMENT_METHOD,
    ROUND(AVG(t.TIP_AMOUNT), 2)                       AS AVG_TIP,
    ROUND(AVG(t.TIP_AMOUNT / NULLIF(t.FARE_AMOUNT, 0)) * 100, 1) AS AVG_TIP_PCT
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA t
JOIN TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D z
    ON t.PU_LOCATION_ID = z.LOCATION_ID::VARCHAR
WHERE t.FARE_AMOUNT > 0
GROUP BY z.BOROUGH, PAYMENT_TYPE
ORDER BY z.BOROUGH, AVG_TIP DESC;


-- ── 8. EDA: Fare amount distribution buckets ────────────────────
SELECT
    CASE
        WHEN FARE_AMOUNT < 0          THEN 'Negative (anomaly)'
        WHEN FARE_AMOUNT = 0          THEN 'Zero'
        WHEN FARE_AMOUNT BETWEEN 0.01 AND 10   THEN '$0.01 – $10'
        WHEN FARE_AMOUNT BETWEEN 10.01 AND 25  THEN '$10 – $25'
        WHEN FARE_AMOUNT BETWEEN 25.01 AND 50  THEN '$25 – $50'
        WHEN FARE_AMOUNT BETWEEN 50.01 AND 100 THEN '$50 – $100'
        ELSE '$100+'
    END                          AS FARE_BUCKET,
    COUNT(*)                     AS TOTAL_TRIPS,
    ROUND(COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (), 2) AS PCT_SHARE
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
GROUP BY FARE_BUCKET
ORDER BY MIN(FARE_AMOUNT);


-- ── 9. EDA: Trip distance distribution buckets ──────────────────
SELECT
    CASE
        WHEN TRIP_DISTANCE = 0                  THEN 'Zero (anomaly)'
        WHEN TRIP_DISTANCE BETWEEN 0.01 AND 1   THEN '0 – 1 mile'
        WHEN TRIP_DISTANCE BETWEEN 1.01 AND 3   THEN '1 – 3 miles'
        WHEN TRIP_DISTANCE BETWEEN 3.01 AND 10  THEN '3 – 10 miles'
        WHEN TRIP_DISTANCE BETWEEN 10.01 AND 30 THEN '10 – 30 miles'
        ELSE '30+ miles (outlier)'
    END                          AS DISTANCE_BUCKET,
    COUNT(*)                     AS TOTAL_TRIPS,
    ROUND(AVG(FARE_AMOUNT), 2)   AS AVG_FARE
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
GROUP BY DISTANCE_BUCKET
ORDER BY MIN(TRIP_DISTANCE);


-- ── 10. EDA: Data quality summary (Bronze vs Silver row count) ───
SELECT
    'TAXI_BRONZE (raw)'  AS layer,
    COUNT(*)             AS total_rows
FROM TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE

UNION ALL

SELECT
    'TAXI_PRATA (cleaned)' AS layer,
    COUNT(*)               AS total_rows
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA;
