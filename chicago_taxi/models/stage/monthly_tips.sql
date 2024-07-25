{{ config(alias='monthly_tips') }}

WITH max_rep_date AS (
  SELECT MAX(rep_date) AS max_rep_date
  FROM {{ ref('top_3_taxis') }}
)

SELECT
    t.taxi_id,
    FORMAT_TIMESTAMP('%Y-%m', t.trip_start_timestamp) AS year_month,
    SUM(t.tips) AS tips_sum
FROM
    {{ source('chicago_taxi_trips', 'taxi_trips') }} t
JOIN
    max_rep_date m
ON
    FORMAT_TIMESTAMP('%Y-%m', t.trip_start_timestamp) >= FORMAT_TIMESTAMP('%Y-%m', m.max_rep_date)
WHERE
    t.taxi_id IN (SELECT taxi_id FROM {{ ref('top_3_taxis') }})
GROUP BY
    t.taxi_id,
    year_month
