# Arquitetura — Pipeline NYC Taxi no Snowflake

## Arquitetura Medallion

```
[Arquivos Parquet da NYC TLC]
        |
        v
[STAGE: NYC_TAXI_RAW.RAW_STAGE]
        |
   COPY INTO
        |
        v
[BRONZE: NYC_TAXI_RAW.TAXI_BRONZE]   <-- tudo VARCHAR, chegada bruta
        |
   INSERT ... SELECT (casts TRY_TO_* + filtros de qualidade)
        |
        v
[SILVER: TAXI_SILVER.TAXI_PRATA]     <-- tipado, limpo
        |
   Queries analíticas + DIM_DATA
        |
        v
[GOLD: TAXI_GOLD.*]                  <-- agregado, pronto para consumo
```

## Por que tudo VARCHAR na Bronze?

Carregar Parquet/CSV diretamente em colunas tipadas quebra quando:
- Um fornecedor envia um NULL onde um número era esperado
- O formato de timestamp muda entre arquivos mensais
- Uma nova coluna aparece no meio do ano

Todas as colunas da Bronze chegam como `VARCHAR`. As funções `TRY_TO_*` na
transformação para Silver tratam a conversão de tipo com segurança —
conversões que falham viram `NULL` em vez de abortar a carga inteira.

## Por que `TRY_TO_*` em vez de `CAST`?

`CAST('valor_invalido' AS FLOAT)` lança um erro e interrompe a query.
`TRY_TO_DOUBLE('valor_invalido')` retorna `NULL` e continua.
Em pipelines de produção, o objetivo é isolar linhas ruins, não derrubar o job.

## Fonte dos Dados

NYC TLC Yellow Taxi Trip Records — dataset público, sem PII.
https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

## Warehouse Utilizado

Snowflake `COMPUTE_WH` (X-Small, auto-suspend em 60s).
