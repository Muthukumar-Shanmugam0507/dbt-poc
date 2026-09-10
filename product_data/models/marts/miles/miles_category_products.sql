select
    PRODUCT_ID
    , BRAND_ID
    , CATEGORY_ID
    , CATEGORY_NAME
    , PRODUCT_URL
    , PARENT_CATEGORIES
from
    {{ ref('int_miles_category_products') }}