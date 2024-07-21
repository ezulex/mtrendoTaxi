{{ config(
    materialized='incremental',
    unique_key=('taxi_id, year_month')
) }}


SELECT
    taxi_id,
    year_month,
    tips_sum,
    CASE
        WHEN previous_month_tips = 0 THEN NULL
        ELSE SAFE_DIVIDE(tips_sum - previous_month_tips, previous_month_tips) * 100
    END AS tips_change
FROM
    {{ ref('tips_with_previous') }}

{% if is_incremental() %}
    WHERE year_month >= (SELECT MAX(year_month) FROM {{ this }})
{% endif %}

ORDER BY
    taxi_id, year_month