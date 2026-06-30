-- Bronze Layer: COPY INTO from internal stage
-- Run after creating the stage and uploading raw Parquet files

-- Step 1: Create internal stage
CREATE OR REPLACE STAGE TAXI_NYC.NYC_TAXI_RAW.RAW_STAGE
  FILE_FORMAT = (TYPE = 'PARQUET');

-- Step 2: Upload your file via SnowSQL CLI or Snowsight UI
-- PUT file:///path/to/yellow_tripdata_2024-01.parquet @TAXI_NYC.NYC_TAXI_RAW.RAW_STAGE;

-- Step 3: Load into Bronze
COPY INTO TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE
FROM @TAXI_NYC.NYC_TAXI_RAW.RAW_STAGE
FILE_FORMAT = (TYPE = 'PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
ON_ERROR = 'CONTINUE';  -- Log bad rows; don't abort entire load

-- Step 4: Verify load
SELECT COUNT(*) AS total_rows FROM TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE;
