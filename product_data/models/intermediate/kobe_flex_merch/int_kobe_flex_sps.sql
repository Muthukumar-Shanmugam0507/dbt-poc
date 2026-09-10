select distinct
    sps.SPECIAL_PRODUCT_SET_ID as SF_PRODUCT_ID
    , sps.DISPLAY_NAME as TITLE
    , sps.LONG_DESCRIPTION as DESCRIPTION
    , sps.URL
    , ({{ get_product_set_image_name('sps.SPECIAL_PRODUCT_SET_ID', "'hi-res'") }}) as DEFAULT_THUMB_IMAGE
    , ({{ get_product_set_image_name('sps.SPECIAL_PRODUCT_SET_ID', "'on-hover'") }}) as DEFAULT_ON_HOVER_IMAGE
    , iff(mcp.CATEGORY_ID is not null, true, false) as IS_LIVE
from
    {{ ref('stg_land__fbb_sfra_special_product_sets') }} as sps
    left join {{ ref('miles_category_products') }} as mcp on sps.SPECIAL_PRODUCT_SET_ID = mcp.PRODUCT_ID