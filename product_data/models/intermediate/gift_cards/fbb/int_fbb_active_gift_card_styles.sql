select distinct
    gsz.GIFT_CARD_SIZE_ID
    , gst.GIFT_CARD_STYLE_ID
    , gst.GIFT_CARD_ID
    , gsz.MF_SIZE_ID
    , gc.MF_ITEM_ID
    , gst.GIFT_CARD_STYLE_ID as COLOR_ID
    , gst.COLOR
    , b.BRAND_CODE
    , b.BRAND_NAME
    , gsz.WAS_PRICE
    , gsz.SELLING_PRICE
    , url.PRODUCT_URL
    , url.PRODUCT_URL as IMAGE_URL
from
    {{ ref('stg_land__fbb_gift_card_styles') }} as gst
    join {{ref('stg_land__fbb_gift_card_sizes')}} as gsz on gst.GIFT_CARD_STYLE_ID = gsz.GIFT_CARD_STYLE_ID
    left join {{ ref('int_fbb_active_gift_cards') }} as gc on gc.GIFT_CARD_ID = gst.GIFT_CARD_ID
    join {{ ref('stg_land__fbb_brands') }} as b on gc.BRAND_ID = b.BRAND_ID
    left join {{ ref('int_fbb_gift_card_images') }} as url on gc.GIFT_CARD_ID = url.PRODUCT_ID
        and url.BRAND_CODE = b.BRAND_CODE
        and url.IMAGE_NAME ilike '%_mm_%'
where
    gst.STATUS = 1
    and gsz.STATUS = 1
    and gsz.STOCK_QUANTITY > 0
