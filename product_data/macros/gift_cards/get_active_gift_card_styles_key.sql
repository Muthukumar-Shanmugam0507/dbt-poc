{% macro get_active_gift_card_styles_key() %}
    md5(
        ifnull(SIZE_ID, 100) ||
        ifnull(STYLE_ID, 100) ||
        ifnull(PRODUCT_ID, 100) ||
        ifnull(gst.MF_SIZE_ID, 100) ||
        ifnull(gst.MF_ITEM_ID, 100) ||
        ifnull(gst.COLOR_ID, 100) ||
        ifnull(gst.COLOR, 'gift_card') ||
        ifnull(gst.BRAND_CODE, 'gift_card') ||
        ifnull(gst.BRAND_NAME, 'gift_card') ||
        ifnull(SALE_PRICE, 100) ||
        ifnull(PRICE, 100) ||
        ifnull(gst.PRODUCT_URL, 'gift_card') ||
        ifnull(gst.IMAGE_URL, 'gift_card') ||
        ifnull(THUMB_IMAGE, 'gift_card') ||
        ifnull(QUANTITY, 100) ||
        ifnull(CLEARANCE_INDICATOR, 'gift_card') ||
        ifnull(DISPLAY_SIZE, 'gift_card') ||
        ifnull(AVAILABILITY, true) ||
        ifnull(IS_FINAL_SALE, 'gift_card')
    )
{% endmacro %}