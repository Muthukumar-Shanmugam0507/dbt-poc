select distinct
    ps.PRODUCT_SET_ID
    , ps.DISPLAY_NAME
    , ps.LONG_DESCRIPTION
    , ps.URL
    , ({{ get_product_set_image_name('ps.PRODUCT_SET_ID', "'hi-res'") }}) as DEFAULT_THUMB_IMAGE
    , ({{ get_product_set_image_name('ps.PRODUCT_SET_ID', "'on-hover'") }}) as DEFAULT_ON_HOVER_IMAGE
    , iff(mcp.CATEGORY_ID is not null, true, false) as IS_LIVE
from
    {{ ref('stg_land__fbb_sfra_product_sets') }} as ps
    left join {{ ref('miles_category_products') }} as mcp on ps.PRODUCT_SET_ID = mcp.PRODUCT_ID
    join {{ ref('stg_land__fbb_brands') }} as br on ps.SITE_ID = br.BRAND_CODE
