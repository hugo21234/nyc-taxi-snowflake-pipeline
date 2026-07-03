-- ============================================================
-- Gold Layer DML: Load DIM_PAYEMENT from Silver
-- ============================================================

INSERT INTO TAXI_NYC.TAXI_GOLD.DIM_PAYEMENT (PAYMENT_CODE, PAYMENT_DESCRIPTION)
SELECT DISTINCT
    PAYMENT_TYPE AS PAYMENT_CODE,
    CASE
        WHEN PAYMENT_TYPE = '1' THEN 'Credit Card'
        WHEN PAYMENT_TYPE = '2' THEN 'Cash'
        WHEN PAYMENT_TYPE = '3' THEN 'No Charge'
        WHEN PAYMENT_TYPE = '4' THEN 'Dispute'
        WHEN PAYMENT_TYPE = '5' THEN 'Unknown'
        WHEN PAYMENT_TYPE = '6' THEN 'Voided Trip'
        ELSE 'Other'
    END AS PAYMENT_DESCRIPTION
FROM TAXI_NYC.TAXI_SILVER.TAXI_PRATA;
