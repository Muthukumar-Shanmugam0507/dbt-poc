{% macro get_mp_product_url(product_id, brand_code) %}
    select
        any_value(site.SFCC_SITE_URL || substring (sfp.URL, regexp_instr(sfp.URL, '\\\.com/') + 4) )
    from
        {{ref('stg_land__fbb_sfra_products')}} as sfp
        cross join {{ref('stg_land__mp_brands')}} as site
    where
        sfp.SFCC_PRODUCT_ID = {{ product_id }}
        and site.BRAND_CODE = {{ brand_code }}
{% endmacro %}
