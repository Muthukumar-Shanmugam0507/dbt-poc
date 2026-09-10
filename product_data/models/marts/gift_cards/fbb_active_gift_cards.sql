select
    PRODUCT_ID
    , MF_ITEM_ID
    , BRAND_ID
    , PRODUCT_TYPE_ID
    , TITLE
    , DESCRIPTION
    , BRAND_CODE
    , BRAND_NAME
    , PRODUCT_URL
    , IMAGE_URL
    , HASH_KEY
    , date(DBT_VALID_FROM) as CREATED_AT
from
    {{ ref('int_fbb_active_gift_cards_from_snapshot') }}