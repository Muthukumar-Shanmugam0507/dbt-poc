select
    gst.GIFT_CARD_SIZE_ID as SIZE_ID
    , gst.GIFT_CARD_STYLE_ID as STYLE_ID
    , gst.GIFT_CARD_ID as PRODUCT_ID
    , gst.MF_SIZE_ID
    , gst.MF_ITEM_ID
    , gst.COLOR_ID
    , gst.COLOR
    , gst.BRAND_CODE
    , gst.BRAND_NAME
    , gst.WAS_PRICE as PRICE
    , gst.SELLING_PRICE as SALE_PRICE
    , gst.PRODUCT_URL
    , gst.IMAGE_URL
    , gst.IMAGE_URL as THUMB_IMAGE
    , 999 as QUANTITY
    , 'B' as CLEARANCE_INDICATOR
    , '0' as DISPLAY_SIZE
    , true as AVAILABILITY
    , false as IS_FINAL_SALE
    , ( {{ get_active_gift_card_styles_key() }} ) as HASH_KEY
from
    {{ ref('int_fbb_active_gift_card_styles') }} as gst