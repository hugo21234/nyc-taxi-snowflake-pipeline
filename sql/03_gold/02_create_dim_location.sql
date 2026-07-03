-- ============================================================
-- Gold Layer DDL: DIM_LOCATION
-- Source: TAXI_ZONE_D (Bronze). Grain: one row per LocationID.
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_GOLD.DIM_LOCATION (
    LOCATION_ID  NUMBER PRIMARY KEY,
    ZONA         VARCHAR,
    BAIRRO       VARCHAR
);
