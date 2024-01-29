WITH listing AS (
    SELECT * FROM {{ ref('dim_listings_cleansed') }}
    ),
    host AS (
        SELECT * FROM {{ ref('dim_hosts_cleansed') }}
    )

SELECT
    listing.listing_id,
    listing.listing_name,
    listing.room_type,
    listing.minimum_nights,
    listing.price,
    listing.host_id,
    host.host_name,
    host.is_superhost as host_is_superhost,
    listing.created_at,
    GREATEST(listing.updated_at, host.updated_at) as updated_at
FROM listing
 LEFT JOIN host ON (host.host_id = listing.host_id)