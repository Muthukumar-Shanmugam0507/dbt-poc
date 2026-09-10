{% macro get_kobe_variants_key() %}
    md5(
        ifnull(BRAND_CODE, 'variant') ||
        ifnull(PRODUCT_ID, 100) ||
        ifnull(COLOR_ID, 100) ||
        ifnull(VARIANT_ID, 'variant') ||
        ifnull(COLOR_NAME, 'variant') ||
        ifnull(TITLE, 'variant') ||
        ifnull(DESCRIPTION, 'variant') ||
        ifnull(IMAGE_URL, 'variant') ||
        ifnull(PRODUCT_URL, 'variant') ||
        ifnull(IS_LIVE, false) ||
        ifnull(HAS_INVENTORY, false)
    )
{% endmacro %}