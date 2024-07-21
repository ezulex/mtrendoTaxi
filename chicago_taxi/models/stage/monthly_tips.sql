{{ config(alias='monthly_tips') }}

SELECT
    taxi_id,
    FORMAT_TIMESTAMP('%Y-%m', trip_start_timestamp) AS year_month,
    SUM(tips) AS tips_sum
FROM
    `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE
    taxi_id IN (SELECT taxi_id FROM {{ ref('top_3_taxis') }})
    AND FORMAT_TIMESTAMP('%Y-%m', trip_start_timestamp) >= (SELECT MAX(rep_date) FROM {{ ref('top_3_taxis') }})
GROUP BY
    taxi_id,
    year_month