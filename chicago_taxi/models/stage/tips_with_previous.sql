{{ config(alias='tips_with_previous') }}

SELECT
    taxi_id,
    year_month,
    tips_sum,
    LAG(tips_sum) OVER (PARTITION BY taxi_id ORDER BY year_month) AS previous_month_tips
FROM
    {{ ref('monthly_tips') }}