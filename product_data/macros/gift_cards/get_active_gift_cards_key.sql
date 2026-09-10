{% macro get_active_gift_cards_key() %}
    md5(
        ifnull(ap.GIFT_CARD_ID, 100) ||
        ifnull(ap.MF_ITEM_ID, 'gift_card') ||
        ifnull(ap.BRAND_ID, 'gift_card') ||
        ifnull(ap.PRODUCT_TYPE_ID, 'gift_card') ||
        ifnull(ap.TITLE, 'gift_card') ||
        ifnull(PRODUCT_URL, 'gift_card') ||
        ifnull(ap.DESCRIPTION, 'gift_card') ||
        ifnull(ap.BRAND_CODE, 'gift_card') ||
        ifnull(ap.BRAND_NAME, 'gift_card')
    )
{% endmacro %}