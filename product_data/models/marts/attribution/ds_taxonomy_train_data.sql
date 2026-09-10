with base as (
    select
        kb.PRODUCT_ID
        , cl.COLOR_ID
        , case when left(kb.PRODUCT_ID::varchar, 1) = '6' then 'MP' else BRAND_CODE end as BRAND_CODE
        , sp.TITLE
        , sp.MS_DESCRIPTION
        , im.IMAGE_URL
        , kb.ATTRIBUTE_NAME AS TAXONOMY_NAME
        , kb.ATTRIBUTE_VALUE AS TAXONOMY_VALUE
        , kb.CREATED_AT
    from
        {{ref('kobe_product_level_attributes')}} as kb
    left join
        {{ref('stg_land__fbb_products')}} as sp on kb.PRODUCT_ID = to_number(sp.PRODUCT_ID)
    join
        {{ref('stg_land__fbb_styles')}} as cl on kb.PRODUCT_ID = to_number(cl.PRODUCT_ID)
    join
        {{ref('stg_land__fbb_color_images')}} as ci on cl.COLOR_ID = to_number(ci.COLOR_ID)
    join
        {{ref('stg_land__fbb_images')}} as im using(IMAGE_ID)
    where
        cl.STATUS = 1
        and ci.IMAGE_TYPE_ID = '5'
        and ci.STATUS = 1
)

select
    distinct
    base.*
from
    base
{% if is_incremental() %}
left join
    {{this}} as existing
on
    base.PRODUCT_ID = existing.PRODUCT_ID
    and base.COLOR_ID = existing.COLOR_ID
    and base.TAXONOMY_NAME = existing.TAXONOMY_NAME
    and base.TAXONOMY_VALUE = existing.TAXONOMY_VALUE
where
    existing.PRODUCT_ID is null
{% endif %}