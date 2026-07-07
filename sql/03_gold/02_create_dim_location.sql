-- ============================================================
-- Camada Gold DDL: DIM_LOCATION
-- Origem: TAXI_ZONE_D (Bronze). Granularidade: uma linha por LocationID.
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_GOLD.DIM_LOCATION (
    LOCATION_ID  NUMBER PRIMARY KEY,
    ZONA         VARCHAR,
    BAIRRO       VARCHAR
);
