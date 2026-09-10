with cte_variation_group_inventory as (
    select
        sps.SPECIAL_PRODUCT_SET_ID
        , sum(case when ROW_ID = 1 then QUANTITY + BACKORDER_QUANTITY end) as VG1_INVENTORY
        , sum(case when ROW_ID = 2 then QUANTITY + BACKORDER_QUANTITY end) as VG2_INVENTORY
    from
        {{ ref('stg_land__fbb_sfra_special_product_sets') }} as sps
        join {{ ref('int_eligible_sizes') }} as st ON sps.PRODUCT_ID = st.SF_PRODUCT_ID and sps.COLOR_ID = st.SF_COLOR_ID
    group by
        sps.SPECIAL_PRODUCT_SET_ID
)
select
    distinct sps.SPECIAL_PRODUCT_SET_ID
from
    {{ ref('stg_land__fbb_sfra_special_product_sets') }} as sps
    join cte_variation_group_inventory as vi on sps.SPECIAL_PRODUCT_SET_ID = vi.SPECIAL_PRODUCT_SET_ID
where
    ONLINE_FLAG
    and AVAILABLE_FLAG
    and SEARCHABLE_FLAG
    and VG1_INVENTORY + VG2_INVENTORY > 0
group by
    sps.SPECIAL_PRODUCT_SET_ID
