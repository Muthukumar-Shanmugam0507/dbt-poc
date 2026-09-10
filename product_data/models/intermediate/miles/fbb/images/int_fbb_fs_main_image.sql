with imgurl as (
    select
        pr.PRODUCT_ID
        , pr.BRAND_ID
        , coalesce(imu.RELATIVE_URL, substring(im.IMAGE_PATH, regexp_instr(im.IMAGE_PATH, '\\\.com/') + 4)) as IMAGE_URL
        , sz.STYLE_ID as COLOR_ID
    from 
        {{ ref('stg_land__fbb_sfra_products') }} as spr
        inner join {{ ref('stg_land__fbb_products') }} as pr on spr.PRODUCT_ID = pr.PRODUCT_ID
        inner join {{ ref('stg_land__fbb_sfra_sizes') }} as sz on spr.PRODUCT_ID = sz.PRODUCT_ID
        inner join {{ ref('stg_land__fbb_sfra_images') }} as im on spr.SFCC_PRODUCT_ID = im.PRODUCT_ID and sz.STYLE_ID = im.VARIATION_VALUE and im.VIEW_TYPE = 'hi-res'
        left join {{ ref('stg_land__fbb_sfra_image_urls') }} as imu on spr.SFCC_PRODUCT_ID = imu.SFCC_PRODUCT_ID and imu.TYPE = 'hi-res' and sz.STYLE_ID = imu.VARIATION_VALUE
    where
        sz.IS_FINAL_SALE = 1
        and sz.INVENTORY_QUANTITY > 0
    qualify row_number() over(partition by pr.PRODUCT_ID order by sz.INVENTORY_QUANTITY desc) = 1
)
select
    imgurl.PRODUCT_ID
    , site.IMAGE_DOMAIN || IMAGE_URL
    , COLOR_ID
    , site.BRAND_ID
    , imgurl.IMAGE_URL
from
    imgurl
    join {{ ref('stg_land__fbb_brands') }} as site on imgurl.BRAND_ID = site.BRAND_ID
