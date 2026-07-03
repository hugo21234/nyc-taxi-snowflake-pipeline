-- ============================================================
-- Gold Layer: Patch DROPOFF_DATE_ID on FACT_TRIP
-- Requires DROPOFF_DATE_ID column to exist on FACT_TRIP.
-- Run after adding the column via ALTER TABLE if needed.
-- ============================================================

UPDATE TAXI_NYC.TAXI_GOLD.FACT_TRIP AS f
SET f.DROPOFF_DATE_ID = d.DATE_ID
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA AS a
JOIN TAXI_NYC.TAXI_GOLD.DIM_DATA AS d
    ON DATE(a.tpep_dropoff_datetime) = d.DATE_VALUE
JOIN TAXI_NYC.TAXI_GOLD.DIM_DATA AS pd
    ON DATE(a.tpep_pickup_datetime) = pd.DATE_VALUE
WHERE f.PICKUP_DATE_ID = pd.DATE_ID;
