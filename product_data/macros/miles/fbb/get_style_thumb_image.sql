{% macro get_style_thumb_image(size_id, brand_code) %}
    select
        any_value(site.IMAGE_DOMAIN || (coalesce(imu.RELATIVE_URL, substring(sfim.IMAGE_PATH, regexp_instr(sfpr.URL, '\\\.com/') + 4)))) as THUMBNAIL_IMAGE
    from
        {{ ref('stg_land__fbb_sfra_sizes') }} as sz
        join {{ ref('stg_land__fbb_sfra_images') }} as sfim on sz.PRODUCT_ID = sfim.PRODUCT_ID and sz.STYLE_ID = sfim.VARIATION_VALUE and sfim.VIEW_TYPE = 'hi-res'
        join {{ ref('stg_land__fbb_images') }} as im on sfim.IMAGE_NAME = im.IMAGE_NAME
        left join {{ ref('stg_land__fbb_sfra_image_urls') }} as imu ON sz.PRODUCT_ID = imu.PRODUCT_ID and sfim.VARIATION_VALUE = imu.VARIATION_VALUE and imu.TYPE = 'hi-res'
        join {{ ref('stg_land__fbb_sfra_products') }} as sfpr on sz.PRODUCT_ID = sfpr.PRODUCT_ID
        join {{ ref('stg_land__fbb_products') }} as pr on sfpr.PRODUCT_ID = pr.PRODUCT_ID
        join {{ref('stg_land__fbb_brands')}} as site on pr.BRAND_ID = site.BRAND_ID
    where
        im.IMAGE_TYPE_ID = 5
        and sz.SIZE_ID = {{ size_id }}
        and site.BRAND_CODE = {{ brand_code }}
{% endmacro %}
