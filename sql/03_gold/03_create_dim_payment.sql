-- ============================================================
-- Camada Gold DDL: DIM_PAYEMENT
-- Chave substituta via IDENTITY. Granularidade: uma linha por tipo de pagamento.
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_GOLD.DIM_PAYEMENT (
    PAYMENT_ID          NUMBER IDENTITY(1,1) PRIMARY KEY,
    PAYMENT_CODE        VARCHAR,
    PAYMENT_DESCRIPTION VARCHAR
);
