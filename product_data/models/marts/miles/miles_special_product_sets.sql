select
    sps.SPECIAL_PRODUCT_SET_ID
    , sps.PRODUCT_ID
    , sps.VARIATION_GROUP
    , sps.TITLE
    , sps.LONG_DESCRIPTION
    , br.BRAND_CODE
    , br.BRAND_NAME
    , sps.URL
    , ( {{ get_product_set_main_image('sps.SPECIAL_PRODUCT_SET_ID', 'br.BRAND_CODE') }} ) as THUMB_IMAGE
    , ( {{ get_product_set_on_hover_image('sps.SPECIAL_PRODUCT_SET_ID', 'br.BRAND_CODE') }} ) as ON_HOVER_IMAGE
    , iff(sps.IS_SPECIAL_PRODUCT_SET, 'Y', 'N') as IS_SPECIAL_PRODUCT_SET
    , psi.IS_INTERNATIONAL
    , psr.REVIEW_AVERAGE
    , psr.REVIEW_COUNT
    , sps.COLOR_PRICE
    , sps.COLOR_SALE_PRICE
    , spsp.PRICE
    , spsp.MIN_BROWSE_PRICE
    , spsp.MIN_BRW_PRICE
    , spsp.MAX_BRW_PRICE
    , spsp.MIN_CLR_PRICE
    , spsp.MAX_CLR_PRICE
    , spsp.MIN_FS_PRICE
    , spsp.MAX_FS_PRICE
    , spsp.BRW_LIST_PRICE
    , spsp.BRW_SALE_PRICE
    , spsp.CLR_LIST_PRICE
    , spsp.CLR_SALE_PRICE
    , spsp.FS_LIST_PRICE
    , spsp.FS_SALE_PRICE
    , null as MIN_BRW_VARIANTS
    , null as MAX_BRW_VARIANTS
    , null as MIN_PRICE_VARIANTS
    , null as MAX_PRICE_VARIANTS
    , null as MIN_FS_PRICE_VARIANTS
    , null as MAX_FS_PRICE_VARIANTS
    , null as BACKORDER_MIN_VARIANTS_BRW
    , null as BACKORDER_MAX_VARIANTS_BRW
    , null as BACKORDER_MIN_VARIANTS
    , null as BACKORDER_MAX_VARIANTS
    , null as BRW_SS_VARIANT_ID
    , null as CLR_SS_VARIANT_ID
    , null as FS_SS_VARIANT_ID
    , null as BRW_PROMO_ID
    , null as CLR_PROMO_ID
    , null as FS_PROMO_ID
    , null as BRW_PLP_SS
    , null as CLR_PLP_SS
    , null as FS_PLP_SS
    , spt.PRODUCT_TYPE AS ITEM_TYPE
from
    {{ ref('int_fbb_active_special_product_sets') }} as sps
    join {{ ref('stg_land__fbb_products') }} as pr on sps.PRODUCT_ID = pr.PRODUCT_ID
    join {{ ref('stg_land__fbb_brands') }} as br on pr.BRAND_ID = br.BRAND_ID
    join {{ ref('int_fbb_special_product_sets_is_international') }} as psi on sps.SPECIAL_PRODUCT_SET_ID = psi.SPECIAL_PRODUCT_SET_ID
    join {{ ref('int_fbb_special_product_sets_prices') }} as spsp on sps.SPECIAL_PRODUCT_SET_ID = spsp.SPECIAL_PRODUCT_SET_ID
    join {{ ref('int_fbb_special_product_set_reviews') }} as psr on sps.SPECIAL_PRODUCT_SET_ID = psr.SPECIAL_PRODUCT_SET_ID and sps.PRODUCT_ID = psr.PRODUCT_ID
    left join {{ ref('int_swim_product_types') }} as spt on sps.SPECIAL_PRODUCT_SET_ID = spt.SPECIAL_PRODUCT_SET_ID