-- Camada Bronze: COPY INTO a partir de stage interno
-- Executar após criar o stage e enviar os arquivos Parquet brutos

-- Passo 1: Criar stage interno
CREATE OR REPLACE STAGE TAXI_NYC.NYC_TAXI_RAW.RAW_STAGE
  FILE_FORMAT = (TYPE = 'PARQUET');

-- Passo 2: Enviar o arquivo via SnowSQL CLI ou interface do Snowsight
-- PUT file:///caminho/para/yellow_tripdata_2024-01.parquet @TAXI_NYC.NYC_TAXI_RAW.RAW_STAGE;

-- Passo 3: Carregar na Bronze
COPY INTO TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE
FROM @TAXI_NYC.NYC_TAXI_RAW.RAW_STAGE
FILE_FORMAT = (TYPE = 'PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
ON_ERROR = 'CONTINUE';  -- Registra linhas com erro; não aborta a carga inteira

-- Passo 4: Verificar a carga
SELECT COUNT(*) AS total_rows FROM TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE;
