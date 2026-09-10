{% macro get_mp_style_thumb_image(size_id) %}
    select
        any_value(site.IMAGE_DOMAIN || substring(sfim.IMAGE_PATH, regexp_instr(sfpr.URL, '\\\.com/') + 4)) as THUMBNAIL_IMAGE
    from
        {{ ref('stg_land__fbb_sfra_sizes') }} as sz
        join {{ ref('stg_land__fbb_sfra_images') }} as sfim on sz.SFCC_PRODUCT_ID = sfim.SFCC_PRODUCT_ID and sz.STYLE_ID = sfim.VARIATION_VALUE and sfim.VIEW_TYPE = 'hi-res'
        join {{ ref('stg_land__mp_images') }} as im on sfim.IMAGE_NAME = im.IMAGE_NAME
        join {{ ref('stg_land__fbb_sfra_products') }} as sfpr on sz.SFCC_PRODUCT_ID = sfpr.SFCC_PRODUCT_ID and sz.SITE_ID = sfpr.SITE_ID
        join {{ ref('stg_land__mp_products') }} as pr on left(sfpr.SFCC_PRODUCT_ID, 7) = pr.PRODUCT_ID
        cross join {{ref('stg_land__fbb_brands')}} as site
    where
        im.IMAGE_TYPE_ID = 5
        and sz.SIZE_ID = {{ size_id }}
        and site.BRAND_CODE = 'OS'
{% endmacro %}
