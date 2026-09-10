with cte_product_color as (
    select
        SPECIAL_PRODUCT_SET_ID
        , PRODUCT_ID
        , split_part(VARIATION_GROUP, '-', 1) as MF_MASTER_ITEM_ID
        , split_part(VARIATION_GROUP, '-', 2) as COLOR_ID
    from
        {{ ref('fbb_active_special_product_sets') }}
),
cte_color_sale_prices as (
    select
        pc.SPECIAL_PRODUCT_SET_ID
        , pc.PRODUCT_ID
        , to_decimal(SELLING_PRICE, 10, 2) as COLOR_SALE_PRICE
    from
        cte_product_color as pc
        join {{ ref('fbb_active_styles') }} as st on pc.COLOR_ID = st.COLOR_ID and pc.PRODUCT_ID = st.PRODUCT_ID
    qualify row_number() over(partition by pc.SPECIAL_PRODUCT_SET_ID, st.PRODUCT_ID order by COLOR_SALE_PRICE asc) = 1
),
cte_color_prices as (
    select
        pc.SPECIAL_PRODUCT_SET_ID
        , pc.PRODUCT_ID
        , to_decimal(WAS_PRICE, 10, 2) as COLOR_PRICE
    from
        cte_product_color as pc
        join {{ ref('fbb_active_styles') }} as st on pc.COLOR_ID = st.COLOR_ID and pc.PRODUCT_ID = st.PRODUCT_ID
    qualify row_number() over(partition by pc.SPECIAL_PRODUCT_SET_ID, st.PRODUCT_ID order by COLOR_PRICE asc) = 1
)
select
    sps.SPECIAL_PRODUCT_SET_ID
    , sps.PRODUCT_ID
    , sps.DISPLAY_NAME as TITLE
    , sps.LONG_DESCRIPTION
    , sps.URL
    , ( {{ get_product_set_main_image('sps.SPECIAL_PRODUCT_SET_ID', 'pr.BRAND_CODE') }} ) as THUMB_IMAGE
    , sps.VARIATION_GROUP
    , sps.LIST_PRICE
    , sps.SALE_PRICE
    , cp.COLOR_PRICE
    , csp.COLOR_SALE_PRICE
    , sps.IS_SPECIAL_PRODUCT_SET
from
    {{ ref('stg_land__fbb_sfra_special_product_sets') }} as sps
    join {{ ref('fbb_active_products') }} as pr on sps.PRODUCT_ID = pr.PRODUCT_ID
    join cte_color_prices as cp on sps.SPECIAL_PRODUCT_SET_ID = cp.SPECIAL_PRODUCT_SET_ID and sps.PRODUCT_ID = cp.PRODUCT_ID
    join cte_color_sale_prices as csp on sps.SPECIAL_PRODUCT_SET_ID = csp.SPECIAL_PRODUCT_SET_ID and sps.PRODUCT_ID = csp.PRODUCT_ID
