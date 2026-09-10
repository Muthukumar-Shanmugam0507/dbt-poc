{% macro get_active_styles_key() %}
    md5(
        ifnull(BRAND_ID, 'style') ||
        ifnull(BRAND_CODE, 'style') ||
        ifnull(st.PRODUCT_ID, 100) ||
        ifnull(MF_MASTER_ITEM_ID, 'style') ||
        ifnull(MF_ITEM_ID, 'style') ||
        TITLE ||
        ifnull(STYLE_ID, 100) ||
        ifnull(MF_STYLE_ID, 'style') ||
        ifnull(STYLE_TYPE, 'style') ||
        ifnull(COLOR_ID, 100) ||
        ifnull(COLOR, 'style') ||
        ifnull(IS_PRINT, true) ||
        ifnull(SIZE_ID, 100) ||
        ifnull(MF_SIZE_ID, 'style') ||
        ifnull(DISPLAY_SIZE, 'style') ||
        ifnull(OFFERED_SIZE, 'style') ||
        ifnull(SIZE_SEQUENCE, 100) ||
        ifnull(WAS_PRICE, 100) ||
        ifnull(SELLING_DEPARTMENT, 'style') ||
        ifnull(MEDIA_KEY, 'style') ||
        ifnull(SELLING_PRICE, 100) ||
        ifnull(SELLING_PRICE_START_DATE, 'style') ||
        ifnull(SELLING_PRICE_END_DATE, 'style') ||
        ifnull(IMAGE_URL, 'style') ||
        ifnull(PRODUCT_URL, 'style') ||
        QUANTITY ||
        BACKORDER_QUANTITY ||
        CLEARANCE_INDICATOR ||
        ifnull(IS_FINAL_SALE, 0)
    )
{% endmacro %}