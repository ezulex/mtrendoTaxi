{{ config(
    materialized='incremental',
    unique_key='tips_change'
) }}

WITH top_3_taxis AS (
    SELECT
        taxi_id,
        rep_date
    FROM
        `mtrendo-430108.mtrendo_ds.top_3_taxis`
),

monthly_tips AS (
    SELECT
        taxi_id,
        FORMAT_TIMESTAMP('%Y-%m', trip_start_timestamp) AS year_month,
        SUM(tips) AS tips_sum
    FROM
        `bigquery-public-data.chicago_taxi_trips.taxi_trips`
    WHERE
        taxi_id IN (SELECT taxi_id FROM top_3_taxis)
        AND FORMAT_TIMESTAMP('%Y-%m', trip_start_timestamp) >= (SELECT MAX(rep_date) FROM top_3_taxis)
    GROUP BY
        taxi_id,
        year_month
),

tips_with_previous AS (
    SELECT
        taxi_id,
        year_month,
        tips_sum,
        LAG(tips_sum) OVER (PARTITION BY taxi_id ORDER BY year_month) AS previous_month_tips
    FROM
        monthly_tips
)

SELECT
    taxi_id,
    year_month,
    tips_sum,
    CASE
        WHEN previous_month_tips = 0 THEN NULL
        ELSE SAFE_DIVIDE(tips_sum - previous_month_tips, previous_month_tips) * 100
    END AS tips_change
FROM
    tips_with_previous
ORDER BY
    taxi_id, year_month

{% if is_incremental() %}
    WHERE tips_change > (SELECT MAX(tips_change) FROM {{ this }})
{% endif %}