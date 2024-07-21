{{ config(alias='top_3_taxis') }}

WITH april_2018_tips_top_3_taxis AS (
    SELECT
        taxi_id,
        SUM(tips) AS tips_sum,
        FORMAT_TIMESTAMP('%Y-%m', MAX(trip_start_timestamp)) AS rep_date
    FROM
        `bigquery-public-data.chicago_taxi_trips.taxi_trips`
    WHERE
        EXTRACT(YEAR FROM trip_start_timestamp) = 2018
        AND EXTRACT(MONTH FROM trip_start_timestamp) = 4
    GROUP BY
        taxi_id
)
SELECT
    taxi_id,
    tips_sum,
    rep_date
FROM
    april_2018_tips_top_3_taxis
ORDER BY
    tips_sum DESC
LIMIT 3
