{{ config(alias='top_3_taxis') }}

WITH april_2018_tips_top_3_taxis AS (
    SELECT
        taxi_id,
        SUM(tips) AS tips_sum,
        FORMAT_TIMESTAMP('%Y-%m', MAX(trip_start_timestamp)) AS rep_date
    FROM
        {{ source('chicago_taxi_trips', 'taxi_trips') }}
    WHERE
        DATE_TRUNC(trip_start_timestamp, MONTH) = '2018-04-01'
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
