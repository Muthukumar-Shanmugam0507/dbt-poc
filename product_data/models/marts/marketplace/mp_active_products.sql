select
    BRAND_ID
    , BRAND_CODE
    , PRODUCT_ID
    , MF_MASTER_ITEM_ID
    , TITLE
    , MS_DESCRIPTION
    , PCM_BRAND
    , MP_VENDOR_ID
    , IS_DIA
    , PCM_SEO_DESCRIPTION
    , CUSTOMER_REVIEW_COUNT
    , CUSTOMER_REVIEW_AVERAGE
    , IMAGE_URL
    , PRODUCT_URL
    , DIVISION
    , CATEGORY
    , SUBCATEGORY
    , GENDER
    , date(DBT_VALID_FROM) as CREATED_AT
from
    {{ ref('int_mp_active_products_from_snapshot') }}
