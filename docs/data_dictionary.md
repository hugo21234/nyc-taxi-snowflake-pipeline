# Data Dictionary — NYC Taxi Snowflake Pipeline

## Bronze: `TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE`

| Column | Type | Description |
|---|---|---|
| VENDORID | VARCHAR | 1=Creative Mobile Technologies, 2=VeriFone |
| TPEP_PICKUP_DATETIME | VARCHAR | Trip start timestamp (raw string) |
| TPEP_DROPOFF_DATETIME | VARCHAR | Trip end timestamp (raw string) |
| PASSENGER_COUNT | VARCHAR | Number of passengers |
| TRIP_DISTANCE | VARCHAR | Miles traveled (taximeter) |
| RATECODEID | VARCHAR | 1=Standard, 2=JFK, 3=Newark, 4=Nassau/Westchester, 5=Negotiated, 6=Group |
| STORE_AND_FWD_FLAG | VARCHAR | Y=stored in memory, N=live transmission |
| PULOCATIONID | VARCHAR | TLC Pickup Zone ID |
| DOLOCATIONID | VARCHAR | TLC Dropoff Zone ID |
| PAYMENT_TYPE | VARCHAR | 1=Credit card, 2=Cash, 3=No charge, 4=Dispute |
| FARE_AMOUNT | VARCHAR | Base metered fare |
| EXTRA | VARCHAR | Rush hour / overnight surcharges |
| MTA_TAX | VARCHAR | $0.50 MTA tax |
| TIP_AMOUNT | VARCHAR | Auto-populated for credit card tips |
| TOLLS_AMOUNT | VARCHAR | Total tolls paid in trip |
| IMPROVEMENT_SURCHARGE | VARCHAR | $0.30 improvement surcharge |
| TOTAL_AMOUNT | VARCHAR | Total charged to passenger |
| CONGESTION_SURCHARGE | VARCHAR | NYC congestion pricing surcharge |
| AIRPORT_FEE | VARCHAR | $1.25 fee for LGA or JFK pickups |
| CBD_CONGESTION_FEE | VARCHAR | Central Business District congestion fee |

---

## Bronze: `TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D`

| Column | Type | Description |
|---|---|---|
| SHAPE_GEOMETRY | VARCHAR | WKT polygon geometry string |
| SHAPE_LENGTH | VARCHAR | Zone shape length |
| SHAPE_AREA | VARCHAR | Zone shape area |
| ZONE | VARCHAR | Neighborhood name (e.g., "JFK Airport") |
| LOCATION_ID | NUMBER(38,0) | TLC Zone ID (1–265) — join key |
| BOROUGH | VARCHAR | NYC borough |

---

## Silver: `TAXI_NYC.TAXI_SILVER.TAXI_PRATA`

| Column | Type | Description |
|---|---|---|
| TPEP_PICKUP_DATETIME | TIMESTAMP_NTZ(9) | Trip start (cast from Bronze) |
| TPEP_DROPOFF_DATETIME | TIMESTAMP_NTZ(9) | Trip end (cast from Bronze) |
| PASSENGER_COUNT | NUMBER(38,0) | Integer count of passengers |
| TRIP_DISTANCE | FLOAT | Miles traveled |
| VENDOR_ID | VARCHAR | 1=Creative Mobile, 2=VeriFone |
| RATECODE_ID | VARCHAR | Rate category |
| PU_LOCATION_ID | VARCHAR | Pickup TLC Zone ID |
| DO_LOCATION_ID | VARCHAR | Dropoff TLC Zone ID |
| PAYMENT_TYPE | VARCHAR | 1=Credit, 2=Cash, 3=No charge, 4=Dispute |
| FARE_AMOUNT | FLOAT | Base metered fare |
| EXTRA | FLOAT | Miscellaneous surcharges |
| MTA_TAX | FLOAT | $0.50 MTA tax |
| TIP_AMOUNT | FLOAT | Credit card tips only |
| TOLLS_AMOUNT | FLOAT | Tolls paid |
| IMPROVEMENT_SURCHARGE | FLOAT | $0.30 improvement surcharge |
| TOTAL_AMOUNT | FLOAT | Total charged |
| CONGESTION_SURCHARGE | FLOAT | NYC congestion surcharge |
| AIRPORT_FEE | FLOAT | LGA/JFK pickup fee |
| CBD_CONGESTION_FEE | FLOAT | CBD congestion fee |

---

## Gold: `TAXI_NYC.TAXI_OURO.DIM_DATE`

| Column | Type | Description |
|---|---|---|
| PICKUP | TIMESTAMP_NTZ(9) | Trip start (from TAXI_PRATA) |
| DROPOFF | TIMESTAMP_NTZ(9) | Trip end (from TAXI_PRATA) |
