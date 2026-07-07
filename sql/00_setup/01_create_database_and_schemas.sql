-- ============================================================
-- 00_setup: Criação de database e schemas
-- Arquitetura: Medallion (Bronze → Silver → Gold Star Schema)
-- ============================================================

CREATE DATABASE IF NOT EXISTS TAXI_NYC;

CREATE SCHEMA IF NOT EXISTS TAXI_NYC.NYC_TAXI_RAW;   -- Bronze
CREATE SCHEMA IF NOT EXISTS TAXI_NYC.TAXI_SILVER;    -- Silver
CREATE SCHEMA IF NOT EXISTS TAXI_NYC.TAXI_GOLD;      -- Gold (Star Schema)
