-- ============================================================
-- Camada Gold DML: carga de DIM_VENDOR a partir da Silver
-- ============================================================

INSERT INTO TAXI_NYC.TAXI_GOLD.DIM_VENDOR (VENDOR_CODE, VENDOR_DESCRIPTION)
SELECT DISTINCT
    VENDOR_ID AS VENDOR_CODE,
    CASE
        WHEN VENDOR_ID = '1' THEN 'Creative Mobile Technologies (CMT)'
        WHEN VENDOR_ID = '2' THEN 'VeriFone Transportation Systems (VTS)'
        ELSE 'Desconhecido'
    END AS VENDOR_DESCRIPTION
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA;
