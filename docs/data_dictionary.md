# Dicionário de Dados — Pipeline NYC Taxi

## Bronze: `TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE`

| Coluna | Tipo Bruto | Descrição |
|---|---|---|
| VENDORID | VARCHAR | 1=Creative Mobile Technologies, 2=VeriFone |
| TPEP_PICKUP_DATETIME | VARCHAR | Timestamp de início da corrida (string bruta) |
| TPEP_DROPOFF_DATETIME | VARCHAR | Timestamp de fim da corrida (string bruta) |
| PASSENGER_COUNT | VARCHAR | Número de passageiros autodeclarado |
| TRIP_DISTANCE | VARCHAR | Distância percorrida (milhas, via odômetro) |
| PULOCATIONID | VARCHAR | ID da zona de embarque (TLC) |
| DOLOCATIONID | VARCHAR | ID da zona de desembarque (TLC) |
| PAYMENT_TYPE | VARCHAR | 1=Cartão, 2=Dinheiro, 3=Sem cobrança, 4=Disputa |
| FARE_AMOUNT | VARCHAR | Tarifa base do taxímetro |
| EXTRA | VARCHAR | Taxas adicionais diversas (horário de pico, período noturno) |
| MTA_TAX | VARCHAR | Taxa de $0,50 acionada pela tarifa do taxímetro |
| TIP_AMOUNT | VARCHAR | Preenchido automaticamente para corridas pagas em cartão |
| TOLLS_AMOUNT | VARCHAR | Total de pedágios pagos |
| IMPROVEMENT_SURCHARGE | VARCHAR | Taxa adicional de $0,30 em corridas via chamada |
| TOTAL_AMOUNT | VARCHAR | Total cobrado (exclui gorjetas em dinheiro) |
| CONGESTION_SURCHARGE | VARCHAR | Taxa de congestionamento de NYC |
| AIRPORT_FEE | VARCHAR | Taxa adicional de embarque em JFK/LGA |
| CBD_CONGESTION_FEE | VARCHAR | Taxa do Central Business District |

---

## Dimensão Bronze: `TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D`

| Coluna | Tipo | Descrição |
|---|---|---|
| LOCATION_ID | NUMBER | ID de zona da TLC (1–265) |
| ZONE | VARCHAR | Nome do bairro/zona (ex.: "JFK Airport") |
| BOROUGH | VARCHAR | Distrito de NYC (Manhattan, Brooklyn, Queens, Bronx, Staten Island, EWR) |
| SHAPE_GEOMETRY | VARCHAR | Geometria do polígono em WKT (para visualização geoespacial) |

---

## Silver: `TAXI_NYC.TAXI_SILVER.TAXI_PRATA`

Mesmas colunas da Bronze `TAXI_BRONZE`, com:
- Timestamps → `TIMESTAMP_NTZ`
- Colunas numéricas → `FLOAT` ou `NUMBER`
- Linhas filtradas: nulos, zero passageiros, distâncias negativas/zero, tarifa ≤ 0 e embarque ≥ desembarque removidos

---

## Gold: `TAXI_NYC.TAXI_GOLD.DIM_DATA`

| Coluna | Tipo | Descrição |
|---|---|---|
| DATE_ID | NUMBER | Chave substituta (IDENTITY) |
| DATE_VALUE | DATE | Data calendário do embarque |
| YEAR | NUMBER | Ano |
| MONTH | NUMBER | Número do mês (1–12) |
| DAY | NUMBER | Dia do mês |
| DAY_OF_WEEK | NUMBER | 0=Domingo, 6=Sábado |
| IS_WEEKEND | BOOLEAN | TRUE se sábado ou domingo |

---

## Gold: `TAXI_NYC.TAXI_GOLD.DIM_LOCATION`

| Coluna | Tipo | Descrição |
|---|---|---|
| LOCATION_ID | NUMBER | Chave primária — ID de zona da TLC |
| ZONA | VARCHAR | Nome do bairro/zona |
| BAIRRO | VARCHAR | Distrito de NYC (borough) |

---

## Gold: `TAXI_NYC.TAXI_GOLD.DIM_PAYEMENT`

| Coluna | Tipo | Descrição |
|---|---|---|
| PAYMENT_ID | NUMBER | Chave substituta (IDENTITY) |
| PAYMENT_CODE | VARCHAR | Código original do tipo de pagamento |
| PAYMENT_DESCRIPTION | VARCHAR | Descrição legível (Cartão de Crédito, Dinheiro, Disputa, Sem Cobrança) |

---

## Gold: `TAXI_NYC.TAXI_GOLD.DIM_VENDOR`

| Coluna | Tipo | Descrição |
|---|---|---|
| VENDOR_ID_SURROGATE | NUMBER | Chave substituta (IDENTITY) |
| VENDOR_CODE | VARCHAR | Código original do fornecedor |
| VENDOR_DESCRIPTION | VARCHAR | Nome do fornecedor do sistema de despacho |

---

## Gold: `TAXI_NYC.TAXI_GOLD.FACT_TRIP`

| Coluna | Tipo | Descrição |
|---|---|---|
| TRIP_ID | NUMBER | Chave primária (IDENTITY) |
| DATE_ID | NUMBER | FK → DIM_DATA |
| PICKUP_LOCATION_ID | NUMBER | FK → DIM_LOCATION (embarque) |
| DROPOFF_LOCATION_ID | NUMBER | FK → DIM_LOCATION (desembarque) |
| PAYMENT_ID | NUMBER | FK → DIM_PAYEMENT |
| VENDOR_ID_SURROGATE | NUMBER | FK → DIM_VENDOR |
| PASSENGER_COUNT | NUMBER | Número de passageiros |
| TRIP_DISTANCE | FLOAT | Distância percorrida (milhas) |
| FARE_AMOUNT | FLOAT | Tarifa base |
| TIP_AMOUNT | FLOAT | Gorjeta |
| TOTAL_AMOUNT | FLOAT | Valor total cobrado |
| PICKUP_DATETIME | TIMESTAMP_NTZ | Timestamp de embarque |
| DROPOFF_DATETIME | TIMESTAMP_NTZ | Timestamp de desembarque |
