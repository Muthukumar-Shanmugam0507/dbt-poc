select
    aps.PRODUCT_SET_ID
    , aps.PRODUCT_ID
    , aps.BRAND_CODE
    , br.BRAND_NAME as BRAND
    , aps.TITLE
    , aps.URL
    , aps.THUMB_IMAGE
    , aps.ON_HOVER_IMAGE
    , 'Y' as IS_PRODUCT_SET
    , psi.IS_INTERNATIONAL
    , psr.REVIEW_AVERAGE
    , psr.REVIEW_COUNT
    , psp.PRICE
    , psp.MIN_BROWSE_PRICE
    , psp.MIN_BRW_PRICE
    , psp.MAX_BRW_PRICE
    , psp.MIN_CLR_PRICE
    , psp.MAX_CLR_PRICE
    , psp.MIN_FS_PRICE
    , psp.MAX_FS_PRICE
    , psp.MIN_BRW_ONLY_PRICE
    , psp.MAX_BRW_ONLY_PRICE
    , psp.MIN_CLR_ONLY_PRICE
    , psp.MAX_CLR_ONLY_PRICE
    , psp.BRW_LIST_PRICE
    , psp.BRW_SALE_PRICE
    , psp.CLR_LIST_PRICE
    , psp.CLR_SALE_PRICE
    , psp.FS_LIST_PRICE
    , psp.FS_SALE_PRICE
    , psp.BRW_ONLY_LIST_PRICE
    , psp.BRW_ONLY_SALE_PRICE
    , psp.CLR_ONLY_LIST_PRICE
    , psp.CLR_ONLY_SALE_PRICE
    , PRODUCT_PRICE
    , PRODUCT_SALE_PRICE
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
from
    {{ ref('int_fbb_active_product_sets') }} as aps
    join {{ ref('stg_land__fbb_brands') }} as br on aps.BRAND_CODE = br.BRAND_CODE
    join {{ ref('int_fbb_product_sets_is_international') }} psi on aps.PRODUCT_SET_ID = psi.PRODUCT_SET_ID
    join {{ ref('int_fbb_product_sets_prices') }} psp on aps.PRODUCT_SET_ID = psp.PRODUCT_SET_ID
    left join {{ ref('stg_land__fbb_turn_to_product_set_reviews') }} psr on aps.PRODUCT_SET_ID = psr.PRODUCT_SET_ID
