-- Bronze Layer: Zone lookup dimension
-- Source: NYC TLC taxi_zone_lookup.csv (public dataset)
-- Maps LocationID integer -> Borough + Zone name

CREATE OR REPLACE TABLE TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D (
    LOCATION_ID    NUMBER,        -- TLC LocationID (1-265)
    ZONE           VARCHAR,       -- Neighborhood name (e.g., "JFK Airport")
    BOROUGH        VARCHAR,       -- NYC borough (Manhattan, Brooklyn, etc.)
    SHAPE_GEOMETRY VARCHAR,       -- WKT geometry string (for geo viz)
    SHAPE_LENGTH   VARCHAR,
    SHAPE_AREA     VARCHAR
);
