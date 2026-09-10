select
    sps.SPECIAL_PRODUCT_SET_ID
    , sps.PRODUCT_ID
    , sps.DISPLAY_NAME as TITLE
    , sps.LONG_DESCRIPTION
    , sps.URL
    , ( {{ get_product_set_main_image('sps.SPECIAL_PRODUCT_SET_ID', 'pr.BRAND_CODE') }} ) as THUMB_IMAGE
    , sps.VARIATION_GROUP
    , ({{ get_active_special_product_sets_key() }}) as HASH_KEY
from
    {{ ref('stg_land__fbb_sfra_special_product_sets') }} as sps
    join {{ ref('int_fbb_special_product_sets_joined_with_active_products') }} as asps on sps.SPECIAL_PRODUCT_SET_ID = asps.SPECIAL_PRODUCT_SET_ID
    join {{ ref('fbb_active_products') }} as pr on sps.PRODUCT_ID = pr.PRODUCT_ID
