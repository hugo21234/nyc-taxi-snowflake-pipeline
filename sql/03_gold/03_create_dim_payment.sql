-- ============================================================
-- Gold Layer DDL: DIM_PAYEMENT
-- Surrogate key via IDENTITY. Grain: one row per payment type.
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_GOLD.DIM_PAYEMENT (
    PAYMENT_ID          NUMBER IDENTITY(1,1) PRIMARY KEY,
    PAYMENT_CODE        VARCHAR,
    PAYMENT_DESCRIPTION VARCHAR
);
