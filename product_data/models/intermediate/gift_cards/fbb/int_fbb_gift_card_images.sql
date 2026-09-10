select
    img.PRODUCT_ID
    , site.BRAND_CODE
    , site.SFCC_SITE_URL || img.RELATIVE_URL as PRODUCT_URL
    , img.IMAGE_NAME
from
    {{ref('stg_land__fbb_sfra_image_urls')}} img
    cross join {{ref('stg_land__fbb_brands')}} site
where
    img.VARIATION_VALUE is null
    and left(brand_id, 2) = left(IMAGE_NAME, 2)