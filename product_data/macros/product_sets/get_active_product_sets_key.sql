{% macro get_active_product_sets_key() %}
md5(
        ifnull(aps.PRODUCT_SET_ID, 'PS_') ||
        ifnull(aps.PRODUCT_ID, 10) ||
        ifnull(aps.DISPLAY_NAME, 'product') ||
        ifnull(aps.URL, 'product') ||
        ifnull(THUMB_IMAGE, 'product')
    )
{% endmacro %}
