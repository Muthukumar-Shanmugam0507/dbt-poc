with product_analytics as (
    {{ generate_fbb_product_analytics() }}
),

product_attributes as (
    {{ get_product_attributes() }}
)

select
    ap.PRODUCT_ID
    , br.BRAND_NAME
    , pr.IS_INTERNATIONAL
    , 'N' as IS_MARKETPLACE_ITEM
    , iff(pr.BRAND_ID = 11, 'Mens', 'Womens') as GENDER
    , 'grouped' as GROUPING
    , pi.THUMB_IMAGE
    , pi.ON_HOVER_IMAGE
    , pi.BROWSE_THUMB_IMAGE
    , pi.CLEARANCE_THUMB_IMAGE
    , pi.CLEARANCE_ON_HOVER_IMAGE
    , pi.FINAL_SALE_THUMB_IMAGE
    , pi.FINAL_SALE_ON_HOVER_IMAGE
    , pa.*
    , fp.PRICE
    , fp.MIN_BROWSE_PRICE
    , fp.MIN_CLEARANCE_PRICE
    , fp.MIN_FINAL_SALE_PRICE
    , fp.MIN_BRW_PRICE
    , fp.MAX_BRW_PRICE
    , fp.MIN_CLR_PRICE
    , fp.MAX_CLR_PRICE
    , fp.MIN_FS_PRICE
    , fp.MAX_FS_PRICE
    , fp.MIN_BRW_ONLY_PRICE
    , fp.MAX_BRW_ONLY_PRICE
    , fp.MIN_CLR_ONLY_PRICE
    , fp.MAX_CLR_ONLY_PRICE
    , rp.BRW_LIST_PRICE
    , rp.CLR_LIST_PRICE
    , rp.FS_LIST_PRICE
    , rp.BRW_SALE_PRICE
    , rp.CLR_SALE_PRICE
    , rp.FS_SALE_PRICE
    , rp.BRW_ONLY_SALE_PRICE
    , rp.BRW_ONLY_LIST_PRICE
    , rp.CLR_ONLY_SALE_PRICE
    , rp.CLR_ONLY_LIST_PRICE
    , pvar.MAX_DISCOUNT_ID
    , pvar.MAX_BRW_VARIANTS
    , pvar.MIN_BRW_VARIANTS
    , pvar.MIN_PRICE_VARIANTS
    , pvar.MAX_PRICE_VARIANTS
    , pvar.MIN_FS_PRICE_VARIANTS
    , pvar.MAX_FS_PRICE_VARIANTS
    , pvar.BACKORDER_MAX_VARIANTS_BRW
    , pvar.BACKORDER_MIN_VARIANTS_BRW
    , pvar.BACKORDER_MAX_VARIANTS
    , pvar.BACKORDER_MIN_VARIANTS
    , pvar.BRW_SS_VARIANT_ID
    , pvar.CLR_SS_VARIANT_ID
    , pvar.FS_SS_VARIANT_ID
    , pvar.MIN_BRW_ONLY_VARIANTS
    , pvar.MAX_BRW_ONLY_VARIANTS
    , pvar.MIN_CLR_ONLY_VARIANTS
    , pvar.MAX_CLR_ONLY_VARIANTS
    , pro.BRW_PROMO_ID
    , pro.CLR_PROMO_ID
    , pro.FS_PROMO_ID
    , pro.BRW_PLP_SS
    , pro.CLR_PLP_SS
    , pro.FS_PLP_SS
    , pro.BRW_ONLY_PLP_SS
    , pro.CLR_ONLY_PLP_SS
    , pat.BOTTOM_FIT
    , pat.CARE
    , pat.CLOSURE
    , pat.FABRIC_MATERIAL
    , pat.FEATURES
    , pat.ITEM_TYPE
    , pat.LENGTH
    , pat.NECKLINE
    , pat.OCCASION
    , pat.SLEEVE_LENGTH
    , pat.STYLE
    , pat.COAT_WEIGHT
    , pat.SOCK_HEIGHT
    , pat.BRA_LINING
    , pat.SHAPE
    , pat.SWIM_COVERAGE
    , pat.SHOE_HEIGHT
    , pat.FABRIC
    , pat.SETS
    , pat.THREAD_COUNT
    , pat.SHEET_TYPE
    , pat.PILLOW_TYPE
    , pat.SLEEP_POSITION
    , pat.LIGHTING_TYPE
    , pat.LIGHTING_COLOR
    , pat.WIDTH
    , pat.TOWEL_TYPE
    , pat.CUUP_PRODUCT_TYPE
    , pat.POCKET_TYPE
    , pat.PRODUCT_THICKNESS
    , pat.COMFORT_LEVEL
    , pat.WEIGHT
    , pat.LIGHT_COUNT
    , pat.HEIGHT_
    , pat.CAPACITY_
    , pat.BEAUTY_FEATURES
    , pat.SEASON
    , pat.STRAP_TYPE
    , pat.SHOE_WIDTH
    , pat.SUPPORT_LEVEL
    , pat.MULTI_PACKS
    , pat.BRA_SUPPORT_LEVEL
    , pat.SHORTS_INSEAM
    , pat.MATERIAL
    , pat.CONSTRUCTION
    , pat.LIGHT_FILTRATION
    , pat.THEME
    , pat.VOLTAGE
    , pat.HEEL_HEIGHT
    , pat.CUUP_SILHOUETTE
    , pat.CUUP_SHEERNESS
    , pat.FILL_MATERIAL
    , pat.WREATH_SIZE
    , pat.APPLICATION
    , pat.EYEWEAR_SHAPE
from
    {{ ref('fbb_active_products') }} as ap
    join {{ ref('stg_land__fbb_products') }} as pr on ap.PRODUCT_ID = pr.PRODUCT_ID
    join {{ ref('stg_land__fbb_brands') }} as br on ap.BRAND_ID = br.BRAND_ID
    left join product_analytics as pa on to_varchar(ap.PRODUCT_ID) = pa.SFCC_PRODUCT_ID
    left join product_attributes as pat on ap.PRODUCT_ID = pat.PRODUCT_ID
    left join {{ ref('stg_land__fbb_sfra_final_price_promos') }} as pro on ap.PRODUCT_ID = pro.PRODUCT_ID
    left join {{ ref('int_fbb_prices') }} as fp on ap.PRODUCT_ID = fp.PRODUCT_ID
    left join {{ ref('int_fbb_ranged_prices') }} as rp on ap.PRODUCT_ID = rp.PRODUCT_ID
    left join {{ ref('int_fbb_price_variants') }} as pvar on ap.PRODUCT_ID = pvar.PRODUCT_ID
    left join {{ ref('int_fbb_product_images') }} as pi on ap.PRODUCT_ID = pi.PRODUCT_ID