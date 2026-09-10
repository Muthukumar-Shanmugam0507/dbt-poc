select
    gc.GIFT_CARD_ID
    , gsz.GIFT_CARD_STYLE_ID
    , min(gsz.WAS_PRICE) as MIN_PRICE
    , max(gsz.WAS_PRICE) as MAX_PRICE
from {{ ref('stg_land__fbb_gift_cards') }} as gc
join {{ ref('stg_land__fbb_brands') }} as b on gc.BRAND_ID = b.BRAND_ID
join {{ ref('stg_land__fbb_gift_card_styles') }} as gst on gc.GIFT_CARD_ID = gst.GIFT_CARD_ID
join {{ ref('stg_land__fbb_gift_card_sizes') }} as gsz on gst.GIFT_CARD_STYLE_ID = gsz.GIFT_CARD_STYLE_ID
group by gc.GIFT_CARD_ID, gsz.GIFT_CARD_STYLE_ID