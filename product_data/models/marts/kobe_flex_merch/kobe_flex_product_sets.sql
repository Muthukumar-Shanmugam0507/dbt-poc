select
    PRODUCT_SET_ID as SF_PRODUCT_ID
    , DISPLAY_NAME as TITLE
    , LONG_DESCRIPTION as DESCRIPTION
    , URL
    , DEFAULT_THUMB_IMAGE
    , DEFAULT_ON_HOVER_IMAGE
    , IS_LIVE
from
    {{ ref('int_kobe_flex_product_sets') }} as ps
