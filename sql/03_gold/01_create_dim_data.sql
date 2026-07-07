-- ============================================================
-- Camada Gold DDL: DIM_DATA (Dimensão de Data)
-- Chave substituta via IDENTITY. Granularidade: uma linha por data única.
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
