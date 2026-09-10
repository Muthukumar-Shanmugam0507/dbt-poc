with cte_variation_group_inventory as (
    select
        sps.SPECIAL_PRODUCT_SET_ID
        , sum(case when ROW_ID = 1 then QUANTITY + BACKORDER_QUANTITY end) as VG1_INVENTORY
        , sum(case when ROW_ID = 2 then QUANTITY + BACKORDER_QUANTITY end) as VG2_INVENTORY
    from
        {{ ref('stg_land__fbb_sfra_special_product_sets') }} as sps
        join {{ ref('fbb_active_styles') }} as st ON sps.PRODUCT_ID = st.PRODUCT_ID and sps.COLOR_ID = st.COLOR_ID
    group by
        sps.SPECIAL_PRODUCT_SET_ID
)
select
    sps.SPECIAL_PRODUCT_SET_ID
from
    {{ ref('stg_land__fbb_sfra_special_product_sets') }} as sps
    join cte_variation_group_inventory as vi on sps.SPECIAL_PRODUCT_SET_ID = vi.SPECIAL_PRODUCT_SET_ID
where
    ONLINE_FLAG
    and AVAILABLE_FLAG
    and SEARCHABLE_FLAG
    and VG1_INVENTORY > 0
    and VG2_INVENTORY > 0
group by
    sps.SPECIAL_PRODUCT_SET_ID
