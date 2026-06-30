-- ═══════════════════════════════════════════════════════════
-- Bronze Layer: TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D
-- Source: NYC TLC taxi_zone_lookup.csv (public dataset)
-- Maps LocationID (integer 1–265) → Borough + Zone name
-- ═══════════════════════════════════════════════════════════

CREATE OR REPLACE TABLE TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D (
    SHAPE_GEOMETRY  VARCHAR,       -- WKT polygon geometry string (for geo viz)
    SHAPE_LENGTH    VARCHAR,
    SHAPE_AREA      VARCHAR,
    ZONE            VARCHAR,       -- Neighborhood name (e.g., "JFK Airport")
    LOCATION_ID     NUMBER(38,0),  -- TLC LocationID (1–265) — primary key
    BOROUGH         VARCHAR        -- NYC borough (Manhattan, Brooklyn, Queens, Bronx, Staten Island)
);
