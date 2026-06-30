-- ═══════════════════════════════════════════════════════════
-- Gold Layer: TAXI_NYC.TAXI_OURO.DIM_DATE
-- Temporal dimension table: stores pickup and dropoff
-- timestamps from Silver for time-series analytical queries.
-- ═══════════════════════════════════════════════════════════

CREATE OR REPLACE TABLE TAXI_NYC.TAXI_OURO.DIM_DATE (
    PICKUP   TIMESTAMP_NTZ(9),  -- Trip start (from TAXI_PRATA.TPEP_PICKUP_DATETIME)
    DROPOFF  TIMESTAMP_NTZ(9)   -- Trip end (from TAXI_PRATA.TPEP_DROPOFF_DATETIME)
);
