-- This is a Jinja template that will be compiled by dbt
-- Specify that the materialization strategy is different from the default
-- Since it's incremental, we also need to specify how to handle schema changes
{{
    config(
        materialized = 'incremental',
        on_schema_change='fail'
    )
}}

WITH src_reviews AS (
  SELECT * FROM {{ ref('staging_reviews') }}
)

SELECT *
FROM src_reviews
WHERE review_text is not null
-- Since it's incremental, it needs to know what defines a new record
-- If this is an incremental load, only load records that are newer than the last time the model was run
-- The `this` variable is a reference to the current model
{% if is_incremental() %}
    AND review_date > (select max(review_date) from {{ this }})
{% endif %}