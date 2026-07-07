-- ============================================================
-- Camada Gold DML: carga de DIM_PAYEMENT a partir da Silver
-- ============================================================

INSERT INTO TAXI_NYC.TAXI_GOLD.DIM_PAYEMENT (PAYMENT_CODE, PAYMENT_DESCRIPTION)
SELECT DISTINCT
    PAYMENT_TYPE AS PAYMENT_CODE,
    CASE
        WHEN PAYMENT_TYPE = '1' THEN 'Cartão de Crédito'
        WHEN PAYMENT_TYPE = '2' THEN 'Dinheiro'
        WHEN PAYMENT_TYPE = '3' THEN 'Sem Cobrança'
        WHEN PAYMENT_TYPE = '4' THEN 'Disputa'
        WHEN PAYMENT_TYPE = '5' THEN 'Desconhecido'
        WHEN PAYMENT_TYPE = '6' THEN 'Corrida Anulada'
        ELSE 'Outro'
    END AS PAYMENT_DESCRIPTION
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA;
