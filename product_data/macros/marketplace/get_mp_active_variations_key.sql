{% macro get_mp_active_variations_key() %}
    md5(
        ifnull(BRAND_ID, 'mp_variation') ||
        ifnull(BRAND_CODE, 'mp_variation') ||
        ifnull(PRODUCT_ID, 100) ||
        ifnull(COLOR_ID, 100) ||
        ifnull(COLOR, 'mp_variation') ||
        ifnull(VARIATION_ID, 'mp_variation') ||
        TITLE ||
        ifnull(MS_DESCRIPTION, 'mp_variation') ||
        ifnull(PCM_SEO_DESCRIPTION, 'mp_variation') ||
        ifnull(PCM_BRAND, 'mp_variation') ||
        ifnull(PRODUCT_URL, 'mp_variation') ||
        ifnull(IMAGE_URL, 'mp_variation') ||
        ifnull(LAYDOWN_IMAGE_URL, 'mp_variation') ||
        ifnull(array_to_string(ALT_IMAGES, ','), 'mp_variation')
    )
{% endmacro %}
