-- ============================================================
-- Camada Bronze: tabela de ingestão bruta
-- Todas as colunas em VARCHAR — evita falhas de carga por
-- incompatibilidade de tipo. A tipagem é aplicada na camada Silver.
-- ============================================================

CREATE OR REPLACE TABLE TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE (
    VENDORID              VARCHAR,
    TPEP_PICKUP_DATETIME  VARCHAR,
    TPEP_DROPOFF_DATETIME VARCHAR,
    PASSENGER_COUNT       VARCHAR,
    TRIP_DISTANCE         VARCHAR,
    RATECODEID            VARCHAR,
    STORE_AND_FWD_FLAG    VARCHAR,
    PULOCATIONID          VARCHAR,
    DOLOCATIONID          VARCHAR,
    PAYMENT_TYPE          VARCHAR,
    FARE_AMOUNT           VARCHAR,
    EXTRA                 VARCHAR,
    MTA_TAX               VARCHAR,
    TIP_AMOUNT            VARCHAR,
    TOLLS_AMOUNT          VARCHAR,
    IMPROVEMENT_SURCHARGE VARCHAR,
    TOTAL_AMOUNT          VARCHAR,
    CONGESTION_SURCHARGE  VARCHAR,
    AIRPORT_FEE           VARCHAR,
    CBD_CONGESTION_FEE    VARCHAR
);
