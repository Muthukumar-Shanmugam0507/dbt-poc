select
    dim.IMAGE_ID as SF_IMAGE_ID
    , dim.IMAGE_TYPE_ID
    , dim.PRODUCT_IDS as SF_PRODUCT_IDS
    , dim.COLOR_IDS as SF_COLOR_IDS
    , dim.BRAND_ID as EFFORT
    , dim.MF_DEPARTMENT_ID
    , dim.MF_ITEM_ID
    , dim.MF_STYLE_ID
    , dim.IMAGE_NAME
    , dim.IMAGE_URL
from
    {{ ref('int_kobe_flex_fbb_detached_images') }} as dim