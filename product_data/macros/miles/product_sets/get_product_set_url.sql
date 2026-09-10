{% macro get_product_set_url(product_id, brand_code) %}
    select
        any_value(site.SFCC_SITE_URL || substring (sfps.URL, regexp_instr(sfps.URL, '\\\.com/') + 4) )
    from
        {{ref('stg_land__fbb_sfra_product_sets')}} sfps
        cross join {{ref('stg_land__fbb_brands')}} site
    where
        sfps.PRODUCT_SET_ID = {{ product_id }}
        and site.BRAND_CODE = {{ brand_code }}
{% endmacro %}
