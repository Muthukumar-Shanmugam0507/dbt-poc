{% macro get_color_swatch_image(size_id, brand_code, is_mp=None) %}
    {% set prefix = 'mp' if is_mp is not none else 'fbb' %}
    select
        any_value(site.IMAGE_DOMAIN || (coalesce(imu.RELATIVE_URL, substring(sfim.IMAGE_PATH, regexp_instr(sfpr.URL, '\\\.com/') + 4)))) as COLOR_SWATCH_IMAGE
    from
        {{ ref('stg_land__fbb_sfra_sizes') }} as sz
        join {{ ref('stg_land__fbb_sfra_images') }} as sfim on sz.PRODUCT_ID = sfim.PRODUCT_ID and sz.STYLE_ID = sfim.VARIATION_VALUE and sfim.VIEW_TYPE = 'swatch'
        join {{ ref('stg_land__' ~ prefix ~ '_images') }} as im on sfim.IMAGE_NAME = im.IMAGE_NAME
        left join {{ ref('stg_land__fbb_sfra_image_urls') }} as imu ON sz.PRODUCT_ID = imu.PRODUCT_ID and sfim.VARIATION_VALUE = imu.VARIATION_VALUE and imu.TYPE = 'swatch'
        join {{ ref('stg_land__fbb_sfra_products') }} as sfpr on sz.PRODUCT_ID = sfpr.PRODUCT_ID and sz.SITE_ID = sfpr.SITE_ID
        join {{ ref('stg_land__' ~ prefix ~ '_products') }} as pr on sfpr.PRODUCT_ID = pr.PRODUCT_ID
        cross join {{ref('stg_land__' ~ prefix ~ '_brands')}} as site
    where
        im.IMAGE_TYPE_ID = 6
        and sz.SIZE_ID = {{ size_id }}
        and site.BRAND_CODE = {{ brand_code }}
{% endmacro %}
