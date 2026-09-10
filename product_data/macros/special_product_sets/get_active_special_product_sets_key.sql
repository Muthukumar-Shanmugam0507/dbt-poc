{% macro get_active_special_product_sets_key() %}
    md5(
        ifnull(sps.SPECIAL_PRODUCT_SET_ID, 'special_special_product_set_set') ||
        ifnull(sps.PRODUCT_ID, 100) ||
        sps.DISPLAY_NAME ||
        ifnull(sps.LONG_DESCRIPTION, 'special_product_set') ||
        ifnull(sps.URL, 'special_product_set') ||
        ifnull(THUMB_IMAGE, 'special_product_set') ||
        ifnull(sps.VARIATION_GROUP, 'special_product_set')
    )
{% endmacro %}
