select
    EFFORT
    , OWNING_BRAND
    , BRAND_CODE
    , DEPARTMENT
    , BRAND_LABEL
    , SF_PRODUCT_ID
    , MF_ID
    , SF_COLOR_ID
    , STYLE_IDS
    , TITLE
    , DESCRIPTION
    , COLOR_NAME
    , COLOR_SORT_ORDER
    , IMAGE_NAME
    , PRODUCT_URL
    , PRODUCT_COLOR_URL
    , HAS_INVENTORY
    , IS_LIVE
    , IS_SLICE
from
    {{ ref("int_kobe_flex_gift_cards") }} as gc