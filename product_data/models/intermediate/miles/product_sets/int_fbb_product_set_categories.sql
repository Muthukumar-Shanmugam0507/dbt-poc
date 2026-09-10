with ps as (
    select distinct
        PRODUCT_SET_ID
    from
        {{ ref('fbb_active_product_sets') }}
)
select
    ps.PRODUCT_SET_ID as PRODUCT_ID
    , awc.BRAND_ID
    , ( {{ get_product_set_url('ps.PRODUCT_SET_ID', 'awc.BRAND_ID') }} ) as PRODUCT_URL
    , awc.CATEGORY_ID
    , DISPLAY_NAME as CATEGORY_NAME
    , PARENT_CATEGORIES
from
    {{ ref('int_active_categories_joined_with_category_products') }} as awc
    join ps on awc.SFCC_PRODUCT_ID = ps.PRODUCT_SET_ID
