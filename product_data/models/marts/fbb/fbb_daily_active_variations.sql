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
    , ({{ get_active_variations_key() }}) as HASH_KEY
from
    {{ref('int_fbb_variations_joined_with_all_images')}} as st