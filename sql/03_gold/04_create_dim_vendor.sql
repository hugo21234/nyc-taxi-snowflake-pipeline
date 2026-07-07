-- ============================================================
-- Camada Gold DDL: DIM_VENDOR
-- Chave substituta via IDENTITY. Granularidade: uma linha por fornecedor.
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_GOLD.DIM_VENDOR (
    VENDOR_ID_SURROGATE  NUMBER IDENTITY(1,1) PRIMARY KEY,
    VENDOR_CODE          VARCHAR,
    VENDOR_DESCRIPTION   VARCHAR
);
