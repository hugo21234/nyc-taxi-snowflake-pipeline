# Data Dictionary — NYC Taxi Pipeline

## Bronze: `TAXI_NYC.NYC_TAXI_RAW.TAXI_BRONZE`

| Column | Raw Type | Description |
|---|---|---|
| VENDORID | VARCHAR | 1=Creative Mobile Technologies, 2=VeriFone |
| TPEP_PICKUP_DATETIME | VARCHAR | Trip start timestamp (raw string) |
| TPEP_DROPOFF_DATETIME | VARCHAR | Trip end timestamp (raw string) |
| PASSENGER_COUNT | VARCHAR | Self-reported passenger count |
| TRIP_DISTANCE | VARCHAR | Miles traveled (odometer) |
| PULOCATIONID | VARCHAR | TLC Pickup Zone ID |
| DOLOCATIONID | VARCHAR | TLC Dropoff Zone ID |
| PAYMENT_TYPE | VARCHAR | 1=Credit, 2=Cash, 3=No charge, 4=Dispute |
| FARE_AMOUNT | VARCHAR | Base metered fare |
| EXTRA | VARCHAR | Miscellaneous extras (rush hour, overnight) |
| MTA_TAX | VARCHAR | $0.50 MTA tax triggered by metered rate |
| TIP_AMOUNT | VARCHAR | Auto-populated for credit card trips |
| TOLLS_AMOUNT | VARCHAR | Total tolls paid |
| IMPROVEMENT_SURCHARGE | VARCHAR | $0.30 surcharge on hailed trips |
| TOTAL_AMOUNT | VARCHAR | Total charged (excl. cash tips) |
| CONGESTION_SURCHARGE | VARCHAR | NYC congestion pricing surcharge |
| AIRPORT_FEE | VARCHAR | JFK/LGA pickup surcharge |
| CBD_CONGESTION_FEE | VARCHAR | Central Business District fee |

---

## Bronze Dimension: `TAXI_NYC.NYC_TAXI_RAW.TAXI_ZONE_D`

| Column | Type | Description |
|---|---|---|
| LOCATION_ID | NUMBER | TLC Zone ID (1–265) |
| ZONE | VARCHAR | Neighborhood name (e.g., "JFK Airport") |
| BOROUGH | VARCHAR | NYC borough (Manhattan, Brooklyn, Queens, Bronx, Staten Island, EWR) |
| SHAPE_GEOMETRY | VARCHAR | WKT polygon geometry (for geospatial visualization) |

---

## Silver: `TAXI_NYC.TAXI_SILVER.TAXI_PRATA`

Same columns as Bronze `TAXI_BRONZE`, with:
- Timestamps → `TIMESTAMP_NTZ`
- Numeric columns → `FLOAT` or `NUMBER`
- Rows filtered: nulls, zero passengers, negative/zero distances, fare ≤ 0, and pickup >= dropoff removed

---

## Gold: `TAXI_NYC.TAXI_OURO.DIM_DATE`

| Column | Type | Description |
|---|---|---|
| TRIP_DATE | DATE | Calendar date of pickup |
| YEAR | NUMBER | Year |
| MONTH | NUMBER | Month number (1–12) |
| MONTH_NAME | VARCHAR | Month name (January, etc.) |
| WEEK_OF_YEAR | NUMBER | ISO week number |
| DAY_OF_WEEK | NUMBER | 0=Sunday, 6=Saturday |
| DAY_NAME | VARCHAR | Day name (Monday, etc.) |
| HOUR_OF_DAY | NUMBER | Hour of pickup (0–23) |
| IS_WEEKEND | BOOLEAN | TRUE if Saturday or Sunday |
