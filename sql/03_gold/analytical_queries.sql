-- =================================================================
-- Camada Gold: Queries Analíticas — Pipeline NYC Yellow Taxi
-- Dataset: dados públicos da NYC TLC (sem PII, sem informações sensíveis)
-- Tabelas de origem: FACT_TRIP, DIM_LOCATION, DIM_PAYEMENT
-- As 6 queries abaixo alimentam exatamente os 6 painéis do dashboard
-- em docs/dashboard.png.
-- =================================================================


-- ── 1. Média de Tarifa por Bairro (pickup) ──────────────────────
-- Painel: "Média De Tarifa" — ranking de FARE_AMOUNT médio por bairro de embarque
SELECT
    dl.BAIRRO                        AS BAIRRO,
    COUNT(*)                         AS TOTAL_CORRIDAS,
    ROUND(AVG(f.FARE_AMOUNT), 2)     AS MEDIA_TARIFA
FROM TAXI_NYC.TAXI_GOLD.FACT_TRIP f
JOIN TAXI_NYC.TAXI_GOLD.DIM_LOCATION dl
    ON f.PICKUP_LOCATION_ID = dl.LOCATION_ID
GROUP BY dl.BAIRRO
ORDER BY MEDIA_TARIFA DESC;


-- ── 2. Distribuição por Tipo de Pagamento ───────────────────────
-- Painel: "Distribuição Por Tipo De Pagamento" — participação de cada
-- forma de pagamento (Cartão de Crédito, Dinheiro, Disputa, Sem Cobrança)
SELECT
    dp.PAYMENT_DESCRIPTION           AS TIPO_PAGAMENTO,
    COUNT(*)                         AS TOTAL_CORRIDAS,
    ROUND(COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (), 2)  AS PERCENTUAL
FROM TAXI_NYC.TAXI_GOLD.FACT_TRIP f
JOIN TAXI_NYC.TAXI_GOLD.DIM_PAYEMENT dp
    ON f.PAYMENT_ID = dp.PAYMENT_ID
GROUP BY dp.PAYMENT_DESCRIPTION
ORDER BY TOTAL_CORRIDAS DESC;


-- ── 3. Média de Tempo de Viagem por Corrida, por Bairro ─────────
-- Painel: "Média de Tempo De Viagem Por Corrida" — duração média
-- (em minutos) das corridas, agrupadas por bairro de embarque
SELECT
    dl.BAIRRO                                          AS BAIRRO,
    ROUND(AVG(
        DATEDIFF('minute', f.PICKUP_DATETIME, f.DROPOFF_DATETIME)
    ), 2)                                               AS MEDIA_TEMPO_MIN
FROM TAXI_NYC.TAXI_GOLD.FACT_TRIP f
JOIN TAXI_NYC.TAXI_GOLD.DIM_LOCATION dl
    ON f.PICKUP_LOCATION_ID = dl.LOCATION_ID
WHERE
    -- Exclui outliers: corridas com menos de 1 minuto ou mais de 3 horas
    DATEDIFF('minute', f.PICKUP_DATETIME, f.DROPOFF_DATETIME) BETWEEN 1 AND 180
GROUP BY dl.BAIRRO
ORDER BY MEDIA_TEMPO_MIN DESC;


-- ── 4. Receita de Corridas por Hora do Dia ──────────────────────
-- Painel: "Receita de Corridas por Hora do Dia" — soma de TOTAL_AMOUNT
-- agrupada pela hora de embarque, mostrando os picos de faturamento
SELECT
    HOUR(f.PICKUP_DATETIME)          AS HORA_CORRIDA,
    COUNT(*)                         AS TOTAL_CORRIDAS,
    ROUND(SUM(f.TOTAL_AMOUNT), 2)    AS RECEITA_TOTAL
FROM TAXI_NYC.TAXI_GOLD.FACT_TRIP f
GROUP BY HORA_CORRIDA
ORDER BY HORA_CORRIDA;


-- ── 5. Top 3 Bairros com Mais Corridas Pegas ────────────────────
-- Painel: "Top 3 Bairros com Mais Corridas Pegas" — ranking de volume
-- de embarques por bairro (contagem por local de embarque)
SELECT
    dl.BAIRRO                        AS BAIRRO,
    COUNT(*)                         AS CONTAGEM_EMBARQUES
FROM TAXI_NYC.TAXI_GOLD.FACT_TRIP f
JOIN TAXI_NYC.TAXI_GOLD.DIM_LOCATION dl
    ON f.PICKUP_LOCATION_ID = dl.LOCATION_ID
GROUP BY dl.BAIRRO
ORDER BY CONTAGEM_EMBARQUES DESC
LIMIT 3;


-- ── 6. Top 3 Médias de Gorjeta por Bairro ───────────────────────
-- Painel: "Tops 3 Médias De Gorjetas Por Bairros" — ranking dos bairros
-- com maior média de TIP_AMOUNT por corrida
SELECT
    dl.BAIRRO                        AS BAIRRO,
    ROUND(AVG(f.TIP_AMOUNT), 2)      AS MEDIA_GORJETA
FROM TAXI_NYC.TAXI_GOLD.FACT_TRIP f
JOIN TAXI_NYC.TAXI_GOLD.DIM_LOCATION dl
    ON f.PICKUP_LOCATION_ID = dl.LOCATION_ID
GROUP BY dl.BAIRRO
ORDER BY MEDIA_GORJETA DESC
LIMIT 3;
