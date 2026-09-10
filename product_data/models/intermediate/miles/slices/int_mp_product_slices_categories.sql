select
    concat(asl.PRODUCT_ID, '_', asl.COLOR_ID) as SLICE_ID
    , asl.PRODUCT_ID
    , awc.BRAND_ID
    , ( {{ get_product_url('asl.PRODUCT_ID', 'awc.BRAND_ID') }} ) as PRODUCT_URL
    , awc.CATEGORY_ID
    , DISPLAY_NAME
    , PARENT_CATEGORIES
from
    {{ ref('int_recursive_categories') }} as awc
    join {{ ref('stg_land__fbb_sfra_category_product_splits') }} as sfcps on awc.CATEGORY_ID = sfcps.CATEGORY_ID
    join {{ ref('mp_active_slices') }} as asl on sfcps.PRODUCT_ID = asl.PRODUCT_ID and sfcps.COLOR_ID = asl.COLOR_ID
