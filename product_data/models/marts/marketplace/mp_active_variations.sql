select
    BRAND_ID
    , BRAND_CODE
    , PRODUCT_ID
    , COLOR_ID
    , COLOR
    , VARIATION_ID
    , TITLE
    , MS_DESCRIPTION
    , PCM_SEO_DESCRIPTION
    , PCM_BRAND
    , PRODUCT_URL
    , IMAGE_URL
    , LAYDOWN_IMAGE_URL
    , ALT_IMAGES
    , date(DBT_VALID_FROM) as CREATED_AT
from
    {{ ref('int_mp_active_variations_from_snapshot') }}
