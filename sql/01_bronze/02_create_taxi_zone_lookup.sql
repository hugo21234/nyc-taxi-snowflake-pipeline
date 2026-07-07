-- ============================================================
-- Camada Bronze: dimensão de zonas (NYC TLC taxi_zone_lookup.csv)
-- Mapeia LocationID → Bairro (Borough) + nome da Zona
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D (
    LOCATION_ID    NUMBER,
    ZONE           VARCHAR,
    BOROUGH        VARCHAR,
    SHAPE_GEOMETRY VARCHAR,
    SHAPE_LENGTH   VARCHAR,
    SHAPE_AREA     VARCHAR
);
