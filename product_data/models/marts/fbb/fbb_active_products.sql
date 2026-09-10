select
    BRAND_ID
    , BRAND_CODE
    , PRODUCT_ID
    , MF_MASTER_ITEM_ID
    , MF_ID
    , TITLE
    , MS_DESCRIPTION
    , PCM_BRAND
    , PCM_SEO_DESCRIPTION
    , CUSTOMER_REVIEW_COUNT
    , CUSTOMER_REVIEW_AVERAGE
    , IMAGE_URL
    , PRODUCT_URL
    , DIVISION
    , CATEGORY
    , SUBCATEGORY
    , date(DBT_VALID_FROM) as CREATED_AT
from
    {{ ref('int_fbb_active_products_from_snapshot') }}