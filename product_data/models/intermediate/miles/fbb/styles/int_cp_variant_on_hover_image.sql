select
    sfimu.VARIATION_VALUE
    , br.IMAGE_DOMAIN || sfimu.RELATIVE_URL as VARIANT_ON_HOVER_IMAGE
from
    {{ ref('stg_land__fbb_images') }} as im
    left join {{ ref('stg_land__fbb_sfra_image_urls') }} as sfimu on im.IMAGE_NAME = sfimu.IMAGE_NAME
    join {{ ref('stg_land__fbb_products') }} as pr on sfimu.PRODUCT_ID = pr.PRODUCT_ID
    join {{ ref('stg_land__fbb_brands') }} as br on pr.BRAND_ID = br.BRAND_ID
where
    im.IMAGE_TYPE_ID = 10
    and im.BRAND_ID = 28
