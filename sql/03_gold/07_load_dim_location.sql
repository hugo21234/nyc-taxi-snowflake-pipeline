-- ============================================================
-- Gold Layer DML: Load DIM_LOCATION from Bronze zone lookup
-- ============================================================

INSERT INTO TAXI_NYC.TAXI_GOLD.DIM_LOCATION (LOCATION_ID, ZONA, BAIRRO)
SELECT
    CAST(LOCATION_ID AS NUMBER) AS LOCATION_ID,
    ZONE                        AS ZONA,
    CAST(BOROUGH AS VARCHAR)    AS BAIRRO
FROM TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D;
