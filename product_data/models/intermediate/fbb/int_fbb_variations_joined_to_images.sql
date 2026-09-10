select
    im.BRAND_ID
    , co.PRODUCT_ID
    , co.COLOR_ID
    , co.PRODUCT_ID || '_' || co.COLOR_ID AS VARIATION_ID
    , im.IMAGE_URL
    , cim.IMAGE_TYPE_ID
    , cim.STATUS as COLOR_IMAGE_STATUS
    , im.STATUS as IMAGE_STATUS
from
    {{ref('stg_land__fbb_color_images')}} as cim
    join {{ref('stg_land__fbb_colors')}} as co on co.COLOR_ID = cim.COLOR_ID
    join {{ref('stg_land__fbb_images')}} as im on im.IMAGE_ID = cim.IMAGE_ID
where
    cim.IMAGE_TYPE_ID = 5 --IMAGE_TYPE 5 is the color type
    and cim.STATUS = 1
    and im.STATUS = 1