{% macro get_active_variations_key() %}
    md5(
        ifnull(BRAND_ID, 'variation') ||
        ifnull(BRAND_CODE, 'variation') ||
        ifnull(PRODUCT_ID, 100) ||
        ifnull(COLOR_ID, 100) ||
        ifnull(COLOR, 'variation') ||
        ifnull(VARIATION_ID, 'variation') ||
        TITLE ||
        ifnull(MS_DESCRIPTION, 'variation') ||
        ifnull(PCM_SEO_DESCRIPTION, 'variation') ||
        ifnull(PCM_BRAND, 'variation') ||
        ifnull(PRODUCT_URL, 'variation') ||
        ifnull(IMAGE_URL, 'variation') ||
        ifnull(LAYDOWN_IMAGE_URL, 'variation') ||
        ifnull(array_to_string(ALT_IMAGES, ','), 'variation')
    )
{% endmacro %}