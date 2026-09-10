{% macro get_mp_active_styles_key() %}
    md5(
        ifnull(BRAND_ID, 'mp_style') ||
        ifnull(BRAND_CODE, 'mp_style') ||
        ifnull(st.PRODUCT_ID, 100) ||
        ifnull(MF_MASTER_ITEM_ID, 'mp_style') ||
        ifnull(MF_ITEM_ID, 'mp_style') ||
        TITLE ||
        ifnull(STYLE_ID, 100) ||
        ifnull(MF_STYLE_ID, 'mp_style') ||
        ifnull(STYLE_TYPE, 'mp_style') ||
        ifnull(COLOR_ID, 100) ||
        ifnull(COLOR, 'mp_style') ||
        ifnull(IS_PRINT, true) ||
        ifnull(SIZE_ID, 100) ||
        ifnull(MF_SIZE_ID, 'mp_style') ||
        ifnull(DISPLAY_SIZE, 'mp_style') ||
        ifnull(OFFERED_SIZE, 'mp_style') ||
        ifnull(SIZE_SEQUENCE, 100) ||
        ifnull(WAS_PRICE, 100) ||
        ifnull(SELLING_DEPARTMENT, 'mp_style') ||
        ifnull(MEDIA_KEY, 'mp_style') ||
        ifnull(SELLING_PRICE, 100) ||
        ifnull(SELLING_PRICE_START_DATE, 'mp_style') ||
        ifnull(SELLING_PRICE_END_DATE, 'mp_style') ||
        ifnull(IMAGE_URL, 'mp_style') ||
        ifnull(PRODUCT_URL, 'mp_style') ||
        QUANTITY ||
        BACKORDER_QUANTITY
    )
{% endmacro %}
