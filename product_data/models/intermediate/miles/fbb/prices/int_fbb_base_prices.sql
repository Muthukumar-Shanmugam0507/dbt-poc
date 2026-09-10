with cte_base_prices as (
    select
        st.PRODUCT_ID
        , st.STYLE_ID
        , to_decimal(pc.SELLING_PRICE, 10, 2) as SELLING_PRICE
        , to_decimal(sz.WAS_PRICE, 10, 2) as LIST_PRICE
        , st.IS_FINAL_SALE
        , st.CLEARANCE_INDICATOR
    from
        {{ ref('stg_land__fbb_styles') }} as st
        inner join {{ ref('stg_land__fbb_sizes') }} sz on st.STYLE_ID = sz.STYLE_ID
        inner join {{ ref('stg_land__fbb_inventory') }} inv on sz.SIZE_ID = inv.SIZE_ID
        inner join {{ ref('stg_land__fbb_prices') }} pc on pc.SIZE_ID = inv.SIZE_ID
        left join {{ ref('int_fbb_excluded_styles') }} ex on st.PRODUCT_ID = ex.PRODUCT_ID and st.STYLE_ID = ex.STYLE_ID
    where
        pc.STATUS = 1
        and sz.STATUS = 1
        and st.STATUS = 1
        and (inv.QUANTITY + inv.BACKORDER_QUANTITY > 0)
)
select
    bp.PRODUCT_ID
    , bp.STYLE_ID
    , bp.SELLING_PRICE
    , bp.LIST_PRICE
    , bp.IS_FINAL_SALE
    , bp.CLEARANCE_INDICATOR
from
    cte_base_prices as bp
    left join {{ ref('int_fbb_excluded_styles') }} ex on bp.PRODUCT_ID = ex.PRODUCT_ID and bp.STYLE_ID = ex.STYLE_ID
where ex.PRODUCT_ID is null