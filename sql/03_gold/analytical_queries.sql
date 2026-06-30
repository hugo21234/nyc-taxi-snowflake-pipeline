-- ═══════════════════════════════════════════════════════════
-- Gold Layer: Analytical Queries — NYC Yellow Taxi Pipeline
-- All queries reference TAXI_NYC.TAXI_SILVER.TAXI_PRATA
-- and TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D
-- No sensitive data. Public TLC dataset.
-- ═══════════════════════════════════════════════════════════


-- ── 1. Average fare by pickup borough ────────────────────────
SELECT
    z.BOROUGH                           AS PICKUP_BOROUGH,
    COUNT(*)                            AS TOTAL_TRIPS,
    ROUND(AVG(t.FARE_AMOUNT), 2)        AS AVG_FARE,
    ROUND(AVG(t.TIP_AMOUNT), 2)         AS AVG_TIP,
    ROUND(AVG(t.TOTAL_AMOUNT), 2)       AS AVG_TOTAL
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA t
JOIN TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D z
    ON t.PU_LOCATION_ID = z.LOCATION_ID::VARCHAR
GROUP BY z.BOROUGH
ORDER BY TOTAL_TRIPS DESC;


-- ── 2. Trip volume and average fare by hour of day ───────────
SELECT
    HOUR(TPEP_PICKUP_DATETIME)          AS PICKUP_HOUR,
    COUNT(*)                            AS TOTAL_TRIPS,
    ROUND(AVG(TOTAL_AMOUNT), 2)         AS AVG_TOTAL_FARE
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
GROUP BY PICKUP_HOUR
ORDER BY PICKUP_HOUR;


-- ── 3. Payment type distribution with % share ────────────────
SELECT
    CASE PAYMENT_TYPE
        WHEN '1' THEN 'Credit Card'
        WHEN '2' THEN 'Cash'
        WHEN '3' THEN 'No Charge'
        WHEN '4' THEN 'Dispute'
        ELSE 'Unknown'
    END                                 AS PAYMENT_METHOD,
    COUNT(*)                            AS TOTAL_TRIPS,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2
    )                                   AS PCT_SHARE
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
GROUP BY PAYMENT_TYPE
ORDER BY TOTAL_TRIPS DESC;


-- ── 4. Top 10 pickup zones by trip volume ────────────────────
SELECT
    z.ZONE                              AS PICKUP_ZONE,
    z.BOROUGH                           AS BOROUGH,
    COUNT(*)                            AS TOTAL_TRIPS,
    ROUND(AVG(t.TRIP_DISTANCE), 2)      AS AVG_DISTANCE_MILES
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA t
JOIN TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D z
    ON t.PU_LOCATION_ID = z.LOCATION_ID::VARCHAR
GROUP BY z.ZONE, z.BOROUGH
ORDER BY TOTAL_TRIPS DESC
LIMIT 10;


-- ── 5. Average trip duration and distance by borough ─────────
SELECT
    z.BOROUGH                           AS PICKUP_BOROUGH,
    ROUND(AVG(
        DATEDIFF('minute',
            t.TPEP_PICKUP_DATETIME,
            t.TPEP_DROPOFF_DATETIME)
    ), 1)                               AS AVG_DURATION_MIN,
    ROUND(AVG(t.TRIP_DISTANCE), 2)      AS AVG_DISTANCE_MILES
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA t
JOIN TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D z
    ON t.PU_LOCATION_ID = z.LOCATION_ID::VARCHAR
WHERE
    DATEDIFF('minute',
        t.TPEP_PICKUP_DATETIME,
        t.TPEP_DROPOFF_DATETIME) BETWEEN 1 AND 180
GROUP BY z.BOROUGH
ORDER BY AVG_DURATION_MIN DESC;


-- ── 6. Daily trip volume and revenue trend ───────────────────
SELECT
    DATE(TPEP_PICKUP_DATETIME)          AS TRIP_DATE,
    COUNT(*)                            AS TOTAL_TRIPS,
    ROUND(SUM(TOTAL_AMOUNT), 2)         AS TOTAL_REVENUE,
    ROUND(AVG(TOTAL_AMOUNT), 2)         AS AVG_FARE_PER_TRIP
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA
GROUP BY TRIP_DATE
ORDER BY TRIP_DATE;


-- ── 7. Tip rate by payment type and borough ──────────────────
-- Note: TIP_AMOUNT is only auto-populated for credit card payments.
-- Cash tips are not captured by the system.
SELECT
    z.BOROUGH,
    CASE PAYMENT_TYPE
        WHEN '1' THEN 'Credit Card'
        WHEN '2' THEN 'Cash'
        ELSE 'Other'
    END                                 AS PAYMENT_METHOD,
    ROUND(AVG(t.TIP_AMOUNT), 2)         AS AVG_TIP,
    ROUND(
        AVG(t.TIP_AMOUNT / NULLIF(t.FARE_AMOUNT, 0)) * 100, 1
    )                                   AS AVG_TIP_PCT
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA t
JOIN TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D z
    ON t.PU_LOCATION_ID = z.LOCATION_ID::VARCHAR
WHERE t.FARE_AMOUNT > 0
GROUP BY z.BOROUGH, PAYMENT_TYPE
ORDER BY z.BOROUGH, AVG_TIP DESC;
