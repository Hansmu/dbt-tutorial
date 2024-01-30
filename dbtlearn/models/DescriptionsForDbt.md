<!--
The docs block defines that it's a documentation block.
The name of the block is what can be used for referencing it later on.
-->

{% docs dim_listing_cleansed__minimum_nights %}
Minimum number of nights required to rent this property.

Keep in mind that old listings might have `minimum_nights` set
to 0 in the source tables. Our cleansing algorithm updates this to `1`.

{% enddocs %}
