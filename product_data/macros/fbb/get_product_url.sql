{% macro get_product_url(product_id, brand_code) %}
    select
        any_value(site.SFCC_SITE_URL || substring (sfp.URL, regexp_instr(sfp.URL, '\\\.com/') + 4) )
    from
        {{ref('stg_land__fbb_sfra_products')}} sfp
        cross join {{ref('stg_land__fbb_brands')}} site
    where
        sfp.SFCC_PRODUCT_ID = {{ product_id }}
        and site.BRAND_CODE = {{ brand_code }}
{% endmacro %}