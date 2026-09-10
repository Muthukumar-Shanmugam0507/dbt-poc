select
    PRODUCT_SET_ID
    , PRODUCT_ID
    , DISPLAY_NAME
    , URL
    , THUMB_IMAGE
    , date(DBT_VALID_FROM) as CREATED_AT
from
    {{ ref('int_fbb_active_product_sets_from_snapshot') }}