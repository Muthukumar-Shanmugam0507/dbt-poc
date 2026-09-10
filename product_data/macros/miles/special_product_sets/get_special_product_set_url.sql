{% macro get_special_product_set_url(product_id, brand_code) %}
    select
        any_value(site.SFCC_SITE_URL || substring (sfsps.URL, regexp_instr(sfsps.URL, '\\\.com/') + 4) )
    from
        {{ref('stg_land__fbb_sfra_special_product_sets')}} sfsps
        cross join {{ref('stg_land__fbb_brands')}} site
    where
        sfsps.SPECIAL_PRODUCT_SET_ID = {{ product_id }}
        and site.BRAND_CODE = {{ brand_code }}
{% endmacro %}
