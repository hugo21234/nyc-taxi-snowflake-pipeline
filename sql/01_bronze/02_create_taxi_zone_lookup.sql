-- ============================================================
-- Bronze Layer: Zone lookup dimension (NYC TLC taxi_zone_lookup.csv)
-- Maps LocationID → Borough + Zone name
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D (
    LOCATION_ID    NUMBER,
    ZONE           VARCHAR,
    BOROUGH        VARCHAR,
    SHAPE_GEOMETRY VARCHAR,
    SHAPE_LENGTH   VARCHAR,
    SHAPE_AREA     VARCHAR
);
