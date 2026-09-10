with  cte_variants as (
    select
        PRODUCT_ID
         , COLOR_ID
    from {{ref('int_fbb_active_variation_inventory')}} as var
    where
        FULFILLMENT_INDICATOR != 2
        and QUANTITY > 0
)
select
    PRODUCT_ID,
    min(DATE_ADDED) as DATE_ADDED,
    array_agg(object_construct('COLOR_ID', COLOR_ID, 'DATE_ADDED', to_char(DATE_ADDED, 'YYYY-MM-DD HH24:MI:SS'))) as COLORS
from
    {{ ref('fbb_product_variations_launch_dates') }} as ca
    join cte_variants as var using(PRODUCT_ID, COLOR_ID)
group by PRODUCT_ID