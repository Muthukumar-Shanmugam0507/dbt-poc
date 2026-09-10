with cte_on_hover_image as (
    select
        PRODUCT_ID
        , BRAND_CODE
        , PRODUCT_URL
        , IMAGE_NAME
    from
        {{ref('int_fbb_gift_card_images')}} img
    where
        IMAGE_NAME like '%_ma_%'
)
select distinct
    gc.PRODUCT_ID
    , gc.MF_ITEM_ID
    , gc.BRAND_ID
    , iff(gc.BRAND_ID = 11, 'Mens', 'Womens') as GENDER
    , gc.PRODUCT_TYPE_ID
    , gc.TITLE
    , gc.DESCRIPTION
    , gc.BRAND_CODE
    , gc.BRAND_NAME as BRAND_LABEL
    , gc.BRAND_NAME as BRAND
    , gc.PRODUCT_URL
    , gc.IMAGE_URL as THUMB_IMAGE
    , gc.IMAGE_URL as BROWSE_THUMB_IMAGE
    , coalesce(ohi.PRODUCT_URL, gc.PRODUCT_URL) as ON_HOVER_IMAGE
    , 'N' as IS_MARKETPLACE_ITEM
    , true as IS_INTERNATIONAL
    , 'grouped' as GROUPING
    , true as AVAILABILITY
    , 999 as INVENTORY_QUANTITY
    , 'default' as PRIMARY_CATEGORY
    , current_date() as DATE_CHANGED
    , gcp.PRICE as MIN_PRICE
    , gcp.PRICE
    , gcp.MIN_BROWSE_PRICE
    , gcp.MIN_BRW_PRICE
    , gcp.MAX_BRW_PRICE
    , gcp.BRW_ONLY_SALE_PRICE
    , gcp.MIN_BRW_ONLY_PRICE
    , gcp.MAX_BRW_ONLY_PRICE
    , gcp.BRW_PLP_SS
    , gcp.BRW_ONLY_PLP_SS
    , gcpv.MIN_BRW_VARIANTS
    , gcpv.MAX_BRW_VARIANTS
    , gcpv.MIN_PRICE_VARIANTS
    , gcpv.MAX_PRICE_VARIANTS
from
    {{ ref('fbb_active_gift_cards') }} as gc
    left join cte_on_hover_image as ohi on gc.PRODUCT_ID = ohi.PRODUCT_ID and gc.BRAND_CODE = ohi.BRAND_CODE
    left join {{ ref('int_fbb_gift_card_prices') }} as gcp on gc.PRODUCT_ID = gcp.GIFT_CARD_ID
    left join {{ ref('int_fbb_gift_card_price_variants') }} as gcpv on gc.PRODUCT_ID = gcpv.GIFT_CARD_ID