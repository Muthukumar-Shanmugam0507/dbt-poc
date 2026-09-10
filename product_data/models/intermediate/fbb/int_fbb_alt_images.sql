select 
    pim.PRODUCT_ID
    , array_agg(img.IMAGE_URL) as ALT_IMAGES
from
    {{ref('stg_land__fbb_product_images')}} as pim
    join {{ref('stg_land__fbb_images')}} as img on img.IMAGE_ID = pim.IMAGE_ID
where
    img.IMAGE_CODE in ('ma', 'mb', 'mc')
group by 1