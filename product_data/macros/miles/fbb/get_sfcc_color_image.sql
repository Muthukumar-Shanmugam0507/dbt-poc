{% macro get_sfcc_color_image(product_id, clearance_indicator) %}
    select
        any_value(VARIATION_VALUE) as COLOR_ID
    from
        {{ ref('stg_land__fbb_sfra_images') }} as sfim
    where
        sfim.SFCC_PRODUCT_ID = to_varchar({{ product_id }})
        and sfim.CLEARANCE_INDICATOR = {{ clearance_indicator }}
        and sfim.IS_FINAL_SALE = 0
        and sfim.IMAGE_CODE = 'mc'
        and sfim.VIEW_TYPE = 'hi-res'
{% endmacro %}
