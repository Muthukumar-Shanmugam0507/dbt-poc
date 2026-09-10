select
    SPECIAL_PRODUCT_SET_ID
    , PRODUCT_ID
    , TITLE
    , LONG_DESCRIPTION
    , URL
    , THUMB_IMAGE
    , VARIATION_GROUP
    , date(DBT_VALID_FROM) as CREATED_AT
from
    {{ ref('int_fbb_active_special_product_sets_from_snapshot') }}
