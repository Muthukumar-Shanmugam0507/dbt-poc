{% macro get_active_slices_key() %}
    md5(
        ifnull(sl.PRODUCT_ID, 'slice') ||
        ifnull(sl.COLOR_ID, 'slice') ||
        ifnull(SLICE_ID, 'slice')
    )
{% endmacro %}
