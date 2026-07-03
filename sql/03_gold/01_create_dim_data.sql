-- ============================================================
-- Gold Layer DDL: DIM_DATA (Date Dimension)
-- Surrogate key via IDENTITY. Grain: one row per unique date.
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_GOLD.DIM_DATA (
    DATE_ID      NUMBER IDENTITY(1,1) PRIMARY KEY,
    DATE_VALUE   DATE,
    YEAR         NUMBER,
    MONTH        NUMBER,
    DAY          NUMBER,
    DAY_OF_WEEK  NUMBER,
    IS_WEEKEND   BOOLEAN
);
