select
    gc.GIFT_CARD_ID
    , gc.MF_ITEM_ID
    , gc.BRAND_ID
    , gc.PRODUCT_TYPE_ID
    , gc.TITLE
    , gc.DESCRIPTION
    , b.BRAND_CODE
    , b.BRAND_NAME
from
    {{ ref('stg_land__fbb_gift_cards') }} as gc
    join {{ ref('stg_land__fbb_brands') }} as b on gc.BRAND_ID = b.BRAND_ID
    join {{ref('stg_land__fbb_gift_card_images')}} as gci on gc.GIFT_CARD_ID = gci.GIFT_CARD_ID
    join {{ref('stg_land__fbb_gift_card_styles')}} as gst on gc.GIFT_CARD_ID = gst.GIFT_CARD_ID
    join {{ref('stg_land__fbb_gift_card_sizes')}} as gsz on gst.GIFT_CARD_STYLE_ID = gsz.GIFT_CARD_STYLE_ID
where
    gc.STATUS = 1
    and gst.STATUS = 1
    and gsz.STATUS = 1
    and gci.STATUS = 1
    and gc.TITLE is not null
    and gsz.STOCK_QUANTITY > 0
group by
    gc.BRAND_ID
    , gc.PRODUCT_TYPE_ID
    , b.BRAND_CODE
    , b.BRAND_NAME
    , gc.GIFT_CARD_ID
    , gc.MF_ITEM_ID
    , gc.TITLE
    , gc.DESCRIPTION
