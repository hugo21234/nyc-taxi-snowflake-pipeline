-- ============================================================
-- Gold Layer DDL: DIM_VENDOR
-- Surrogate key via IDENTITY. Grain: one row per vendor.
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_GOLD.DIM_VENDOR (
    VENDOR_ID_SURROGATE  NUMBER IDENTITY(1,1) PRIMARY KEY,
    VENDOR_CODE          VARCHAR,
    VENDOR_DESCRIPTION   VARCHAR
);
