select
    SF_PRODUCT_ID
    , TITLE
    , DESCRIPTION
    , URL
    , DEFAULT_THUMB_IMAGE
    , DEFAULT_ON_HOVER_IMAGE
    , IS_LIVE
from {{ ref('int_kobe_flex_sps') }} as sps