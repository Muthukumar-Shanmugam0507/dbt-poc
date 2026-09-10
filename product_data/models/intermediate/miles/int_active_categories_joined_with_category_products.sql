select
    awc.CATEGORY_ID
    , DISPLAY_NAME
    , PARENT_ID
    , BRAND_ID
    , HIDE_MASTER_PRODUCT_IN_SLICING
    , PRODUCT_ID
    , SFCC_PRODUCT_ID
    , PARENT_CATEGORIES
from
    {{ ref('int_recursive_categories') }} as awc
    join {{ ref('stg_land__fbb_sfra_category_products') }} as awcp on awc.CATEGORY_ID = awcp.CATEGORY_ID
