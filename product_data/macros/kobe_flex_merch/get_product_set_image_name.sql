{% macro get_product_set_image_name(product_set_id, view_type) %}
    select
        any_value(IMAGE_NAME) as IMAGE_NAME
    from
        {{ ref('stg_land__fbb_sfra_images') }} as sfim
    where
        sfim.SFCC_PRODUCT_ID = {{ product_set_id }}
        and sfim.VIEW_TYPE = {{ view_type }}
{% endmacro %}