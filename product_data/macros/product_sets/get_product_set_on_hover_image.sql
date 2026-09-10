{% macro get_product_set_on_hover_image(product_set_id, brand_code) %}
    select
        any_value(site.IMAGE_DOMAIN || substring (IMAGE_PATH, regexp_instr(IMAGE_PATH, '\\\.com/') + 4)) as IMAGE_PATH
    from
        {{ref('stg_land__fbb_sfra_images')}} as sfim
        cross join {{ref('stg_land__fbb_brands')}} as site
    where
        sfim.SFCC_PRODUCT_ID = {{ product_set_id }}
        and VIEW_TYPE = 'on-hover'
        and site.BRAND_CODE = {{ brand_code }}
{% endmacro %}
