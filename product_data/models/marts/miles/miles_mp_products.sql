with product_attributes as (
    {{ get_product_attributes() }}
)

select
    ap.BRAND_CODE
    , b.BRAND_NAME
    , ap.PRODUCT_ID
    , ap.MF_MASTER_ITEM_ID
    , ap.TITLE
    , ap.MS_DESCRIPTION as DESCRIPTION
    , ap.PCM_BRAND
    , p.IS_INTERNATIONAL
    , 'Y' as IS_MARKETPLACE_ITEM
    , ap.GENDER
    , iff(v.ENABLED_PRODUCTION, 'N', 'Y') as PREVIEW_ONLY
    , ap.CUSTOMER_REVIEW_COUNT
    , ap.CUSTOMER_REVIEW_AVERAGE
    , ap.PRODUCT_URL
    , pi.THUMB_IMAGE
    , pi.BROWSE_THUMB_IMAGE
    , pi.ON_HOVER_IMAGE
    , mpp.PRICE
    , mpp.MIN_BROWSE_PRICE
    , mpp.MIN_BRW_PRICE
    , mpp.MAX_BRW_PRICE
    , mpp.CLR_LIST_PRICE
    , mpp.CLR_SALE_PRICE
    , mpp.MIN_FS_PRICE
    , mpp.MAX_FS_PRICE
    , mpp.MIN_CLR_PRICE
    , mpp.MAX_CLR_PRICE
    , mpp.BRW_LIST_PRICE
    , mpp.BRW_SALE_PRICE
    , mpp.FS_LIST_PRICE
    , mpp.FS_SALE_PRICE
    , mppv.MAX_BRW_VARIANTS
    , mppv.MIN_BRW_VARIANTS
    , mppv.MIN_PRICE_VARIANTS
    , mppv.MAX_PRICE_VARIANTS
    , mppv.MIN_FS_PRICE_VARIANTS
    , mppv.MAX_FS_PRICE_VARIANTS
    , mppv.BRW_SS_VARIANT_ID
    , mppv.CLR_SS_VARIANT_ID
    , mppv.FS_SS_VARIANT_ID
    , null as BACKORDER_MIN_VARIANTS_BRW
    , null as BACKORDER_MAX_VARIANTS_BRW
    , null as BACKORDER_MIN_VARIANTS
    , null as BACKORDER_MAX_VARIANTS
    , null as BRW_PROMO_ID
    , null as CLR_PROMO_ID
    , null as FS_PROMO_ID
    , null as BRW_PLP_SS
    , null as CLR_PLP_SS
    , null as FS_PLP_SS
    , pat.CARE
    , pat.FABRIC_MATERIAL
    , pat.FEATURES
    , pat.ITEM_TYPE
    , pat.LENGTH
    , pat.OCCASION
    , pat.STYLE
    , pat.THEME
    , pat.BOTTOM_FIT
    , pat.NECKLINE
    , pat.SLEEVE_LENGTH
    , pat.CLOSURE
    , pat.SWIM_COVERAGE
    , pat.COAT_WEIGHT
    , pat.STRAP_TYPE
    , pat.SHAPE
    , pat.HEEL_HEIGHT
from
    {{ ref('mp_active_products') }} as ap
    join {{ ref('stg_land__mp_products') }} as p on ap.PRODUCT_ID = p.PRODUCT_ID
    join {{ ref('stg_land__mp_brands') }} as b on ap.BRAND_ID = b.BRAND_ID
    join {{ ref('stg_land__mp_vendors') }} as v on p.VENDOR_ID = v.MF_VENDOR_ID
    left join {{ ref('int_ds_product_taxonomy') }} as tx on tx.PRODUCT_ID = ap.PRODUCT_ID
    left join {{ ref('int_mp_prices') }} as mpp on mpp.PRODUCT_ID = ap.PRODUCT_ID
    left join {{ ref('int_mp_price_variants') }} as mppv on mppv.PRODUCT_ID = ap.PRODUCT_ID
    left join product_attributes as pat on ap.PRODUCT_ID = pat.PRODUCT_ID
    left join {{ ref('int_mp_product_images') }} as pi on ap.PRODUCT_ID = pi.PRODUCT_ID
