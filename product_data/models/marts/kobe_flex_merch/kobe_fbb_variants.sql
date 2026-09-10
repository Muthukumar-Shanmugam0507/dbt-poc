select
    BRAND_CODE
    , PRODUCT_ID
    , COLOR_ID
    , VARIANT_ID
    , COLOR_NAME
    , TITLE
    , DESCRIPTION
    , IMAGE_URL
    , PRODUCT_URL
    , IS_LIVE
    , HAS_INVENTORY
    , date(DBT_VALID_FROM) as CREATED_AT
from
    ({{ get_kobe_variants_from_snapshot('fbb') }}) as kobe_variants