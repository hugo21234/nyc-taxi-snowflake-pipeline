# NYC Yellow Taxi — Pipeline de Dados no Snowflake

Pipeline de dados completo para o dataset **NYC TLC Yellow Taxi Trip Records**, construído no Snowflake utilizando a **Arquitetura Medallion** (Bronze → Silver → Gold).

## Arquitetura

```
[Fonte NYC TLC]
      │
      ▼
┌──────────────────────────────────┐
│  BRONZE  NYC_TAXI_RAW            │
│  TAXI_BRONZE   (3,8M linhas)     │
│  TAXI_ZONE_D   (263 zonas)       │
│  Tudo VARCHAR — bruto como recebido │
└──────────────┬───────────────────┘
               │  transform_bronze_to_silver.sql
               ▼
┌──────────────────────────────────┐
│  SILVER  TAXI_SILVER             │
│  TAXI_PRATA   (3,8M linhas)      │
│  Tipado, limpo, filtrado por qualidade │
└──────────────┬───────────────────┘
               │  populate_dim_date.sql
               ▼
┌──────────────────────────────────┐
│  GOLD  TAXI_OURO                 │
│  DIM_DATE   (3,8M linhas)        │
│  Camada analítica / série temporal │
└──────────────────────────────────┘
```

## Estrutura do Repositório

```
sql/
├── 01_bronze/
│   ├── create_database_and_schemas.sql
│   ├── create_taxi_bronze.sql
│   └── create_taxi_zone_lookup.sql
├── 02_silver/
│   ├── create_taxi_silver.sql
│   └── transform_bronze_to_silver.sql
└── 03_gold/
    ├── create_dim_date.sql
    ├── populate_dim_date.sql
    └── analytical_queries.sql
docs/
├── architecture.md
└── data_dictionary.md
```

## Stack Tecnológica

- **Snowflake** — data warehouse em nuvem
- **SQL** — todas as transformações
- **Arquitetura Medallion** — Bronze / Silver / Gold
- **Dataset** — NYC TLC Yellow Taxi Trip Records (público)

## Decisões de Design

| Decisão | Motivo |
|---|---|
| Todas as colunas Bronze são VARCHAR | Evita falhas de carga por variações de formato ou NULLs inesperados |
| Funções `TRY_TO_*` na Silver | Conversões falhas retornam NULL — sem cargas abortadas |
| Filtros de qualidade no INSERT da Silver | Rejeita tarifas negativas, zero passageiros e timestamps invertidos |
| `NULLIF` no cálculo de % de gorjeta | Protege contra divisão por zero em corridas com tarifa zero |

## Executando o Pipeline

```sql
-- 1. Configuração
snowsql -f sql/01_bronze/create_database_and_schemas.sql
snowsql -f sql/01_bronze/create_taxi_bronze.sql
snowsql -f sql/01_bronze/create_taxi_zone_lookup.sql

-- 2. Carregue os dados brutos (Parquet do site da TLC)
-- Veja docs/architecture.md para instruções de COPY INTO

-- 3. Transformação
snowsql -f sql/02_silver/create_taxi_silver.sql
snowsql -f sql/02_silver/transform_bronze_to_silver.sql

-- 4. Construir a camada Gold
snowsql -f sql/03_gold/create_dim_date.sql
snowsql -f sql/03_gold/populate_dim_date.sql

-- 5. Executar queries analíticas
snowsql -f sql/03_gold/analytical_queries.sql
```

## Fonte dos Dados

[NYC TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) — dataset público, sem informações sensíveis.
