{% macro get_gift_card_url(product_id, brand_code) %}
    select
        any_value(site.SFCC_SITE_URL || substring (sfp.URL, regexp_instr(sfp.URL, '\\\.com/') + 4) )
    from
        {{ref('stg_land__fbb_sfra_product_urls')}} sfp
        cross join {{ref('stg_land__fbb_brands')}} site
    where
        sfp.PRODUCT_ID = {{ product_id }}
        and site.BRAND_CODE = {{ brand_code }}
{% endmacro %}