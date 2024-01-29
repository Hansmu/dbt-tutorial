-- Snapshot definition goes between these tags
{% snapshot snapshot_raw_listings %}

-- The strategy is set to timestamp, which means that we need a unique_key and a updated_at column.
-- invalidate_hard_deletes means that any deletes will be reflected in the snapshot table, by setting the valid_to to today.
{{
   config(
       target_schema='DEV',
       strategy='timestamp',
       unique_key='id',
       updated_at='updated_at',
       invalidate_hard_deletes=True
   )
}}

SELECT * FROM {{ source('airbnb-example-data', 'listings') }}

{% endsnapshot %}