with cte_joined_with_styles as (
    select
        sfps.PRODUCT_SET_ID
        , sfps.PRODUCT_ID
        , SELLING_PRICE
        , WAS_PRICE
    from
        {{ ref('stg_land__fbb_sfra_product_sets') }} as sfps
        join {{ ref('fbb_active_styles') }} as st on sfps.PRODUCT_ID = st.PRODUCT_ID
),
cte_sale_price as (
    select
        PRODUCT_SET_ID
        , PRODUCT_ID
        , to_decimal(SELLING_PRICE, 10, 2) as SELLING_PRICE
    from
        cte_joined_with_styles
    qualify row_number() over(partition by PRODUCT_SET_ID, PRODUCT_ID order by SELLING_PRICE asc) = 1
),
cte_price as (
    select
        PRODUCT_SET_ID
        , PRODUCT_ID
        , TRY_TO_DECIMAL(TO_VARCHAR(WAS_PRICE), 10, 2) as WAS_PRICE
    from
        cte_joined_with_styles
    qualify row_number() over(partition by PRODUCT_SET_ID, PRODUCT_ID order by WAS_PRICE desc) = 1
),
distinct_ps as (
    select distinct
        PRODUCT_SET_ID
        , PRODUCT_ID
        , SITE_ID as BRAND_CODE
        , DISPLAY_NAME as TITLE
        , LIST_PRICE
        , SALE_PRICE
        , URL
    from
        {{ ref('stg_land__fbb_sfra_product_sets') }}
)
select
    aps.PRODUCT_SET_ID
    , aps.PRODUCT_ID
    , sfps.BRAND_CODE
    , sfps.TITLE
    , sfps.LIST_PRICE
    , sfps.SALE_PRICE
    , p.WAS_PRICE as PRODUCT_PRICE
    , sp.SELLING_PRICE as PRODUCT_SALE_PRICE
    , sfps.URL
    , aps.THUMB_IMAGE
    , ( {{ get_product_set_on_hover_image('aps.PRODUCT_SET_ID', 'BRAND_CODE') }} ) as ON_HOVER_IMAGE
from
    distinct_ps as sfps
    join {{ ref('fbb_active_product_sets') }} as aps on sfps.PRODUCT_SET_ID = aps.PRODUCT_SET_ID and sfps.PRODUCT_ID = aps.PRODUCT_ID
    join cte_price as p on sfps.PRODUCT_SET_ID = p.PRODUCT_SET_ID and sfps.PRODUCT_ID = p.PRODUCT_ID
    join cte_sale_price as sp on sfps.PRODUCT_SET_ID = sp.PRODUCT_SET_ID and sfps.PRODUCT_ID = sp.PRODUCT_ID
