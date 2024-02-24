## Q1
- it applies a limit 100 only to our staging models
- It's the same as running dbt build

## Q2
- The code from a development branch requesting a merge to main

## Q3
- check table in details (zoomcamp-dataengineering.dbt_vbrunnhuber.fact_fhv_tripdata)
- 23014060   ->  42998722

## Q4
SELECT
  count(1)
FROM
  `zoomcamp-dataengineering.dbt_vbrunnhuber.fact_fhv_tripdata`
WHERE
  EXTRACT(YEAR FROM pickup_datetime) = 2019
  AND EXTRACT(MONTH FROM pickup_datetime) = 7

- 290.682

SELECT
    service_type,
    COUNT(1) AS observation_count
  FROM
    `zoomcamp-dataengineering.dbt_vbrunnhuber.fact_trips`
  WHERE
    EXTRACT(YEAR FROM pickup_datetime) = 2019
    AND EXTRACT(MONTH FROM pickup_datetime) = 7
  GROUP BY
    service_type

- yellow: 3.251.174  -> Yellow has the most trips in 7.2019
- green: 415.281

