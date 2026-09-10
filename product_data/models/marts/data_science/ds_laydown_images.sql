--<effNum><deptNum>_<itemNum>_ma_<colorNum>_0200_00.jpg
{{
    config(
        materialized='incremental'
    )
}}

select
    ldi.PRODUCT_ID
    , ldi.COLOR_ID
    , ldi.PRODUCT_ID || '_'  || ldi.COLOR_ID as VARIATION_ID
    , ima.BRAND_ID
    , ima.MF_DEPARTMENT_ID
    , ima.MF_ITEM_ID
    , ima.MF_STYLE_ID
    , ima.BRAND_ID || ima.MF_DEPARTMENT_ID || '_' || ima.MF_ITEM_ID || '_ma_' || ima.MF_STYLE_ID || '_0200_00.jpg' as FBB_LAYDOWN_IMAGE_NAME
    , ldi.IMAGE_URL as LAYDOWN_IMAGE_URL
    , null as UPLOADED_AT
from
    {{ ref('stg_laydown__images') }} as ldi
    join {{ ref('stg_land__fbb_color_images') }} as cli on ldi.COLOR_ID = cli.COLOR_ID
    join {{ ref('stg_land__fbb_images') }} as ima on cli.IMAGE_ID = ima.IMAGE_ID
where
    cli.STATUS = 1
    and cli.IMAGE_TYPE_ID = 5
    and ima.STATUS = 1
{% if is_incremental() %}
    and VARIATION_ID not in (select VARIATION_ID from {{ this }})
{% endif %}