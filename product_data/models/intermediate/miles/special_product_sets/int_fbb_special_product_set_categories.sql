with sps as (
    select distinct
        SPECIAL_PRODUCT_SET_ID
    from
        {{ ref('fbb_active_special_product_sets') }}
)
select
    sps.SPECIAL_PRODUCT_SET_ID
    , awc.BRAND_ID
    , ( {{ get_special_product_set_url('sps.SPECIAL_PRODUCT_SET_ID', 'awc.BRAND_ID') }} ) as PRODUCT_URL
    , awc.CATEGORY_ID
    , DISPLAY_NAME as CATEGORY_NAME
    , PARENT_CATEGORIES
from
    {{ ref('int_active_categories_joined_with_category_products') }} as awc
    join sps on awc.SFCC_PRODUCT_ID = sps.SPECIAL_PRODUCT_SET_ID
