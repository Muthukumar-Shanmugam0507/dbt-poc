select
    SIZE_ID
    , STYLE_ID
    , PRODUCT_ID
    , MF_SIZE_ID
    , MF_ITEM_ID
    , COLOR_ID
    , COLOR
    , BRAND_CODE
    , BRAND_NAME
    , PRICE
    , SALE_PRICE
    , PRODUCT_URL
    , IMAGE_URL
    , THUMB_IMAGE
    , QUANTITY
    , CLEARANCE_INDICATOR
    , DISPLAY_SIZE
    , AVAILABILITY
    , IS_FINAL_SALE
    , HASH_KEY
    , date(DBT_VALID_FROM) as CREATED_AT
from
    {{ ref('int_fbb_active_gift_card_styles_from_snapshot') }}