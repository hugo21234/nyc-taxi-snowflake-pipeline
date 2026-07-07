-- ============================================================
-- Camada Gold DDL: FACT_TRIP (Tabela Fato)
-- Centro do Star Schema. FKs para todas as dimensões + métricas da corrida.
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_GOLD.FACT_TRIP (
    TRIP_ID              NUMBER IDENTITY(1,1) PRIMARY KEY,
    -- Chaves Estrangeiras
    DATE_ID              NUMBER,
    PICKUP_LOCATION_ID   NUMBER,
    DROPOFF_LOCATION_ID  NUMBER,
    PAYMENT_ID           NUMBER,
    VENDOR_ID_SURROGATE  NUMBER,
    -- Métricas
    PASSENGER_COUNT      NUMBER,
    TRIP_DISTANCE        FLOAT,
    FARE_AMOUNT          FLOAT,
    EXTRA                FLOAT,
    MTA_TAX              FLOAT,
    TIP_AMOUNT           FLOAT,
    TOLLS_AMOUNT         FLOAT,
    IMPROVEMENT_SURCHARGE FLOAT,
    TOTAL_AMOUNT         FLOAT,
    CONGESTION_SURCHARGE FLOAT,
    AIRPORT_FEE          FLOAT,
    CBD_CONGESTION_FEE   FLOAT,
    -- Timestamps (para drill-down, se necessário)
    PICKUP_DATETIME      TIMESTAMP_NTZ,
    DROPOFF_DATETIME     TIMESTAMP_NTZ
);
