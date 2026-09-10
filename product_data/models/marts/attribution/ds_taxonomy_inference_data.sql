with newproducts as (
    select
        pv.PRODUCT_ID,
        pv.BRAND_CODE,
        pv.TITLE,
        pv.MS_DESCRIPTION,
        pv.IMAGE_URL
    from
        {{ref('fbb_active_products')}} as pv
    where
        pv.BRAND_CODE != 'BH'
        and pv.PRODUCT_ID not in (
            select
                PRODUCT_ID
            from
                {{ref('kobe_product_level_attributes')}}
        )
),
attributenames as (
    select 'DIVISION' as ATTRIBUTE_NAME
    union all
    select 'CATEGORY'
    union all
    select 'SUBCATEGORY'
)
select
    fp.PRODUCT_ID,
    fp.BRAND_CODE,
    fp.TITLE,
    fp.MS_DESCRIPTION,
    fp.IMAGE_URL,
    an.ATTRIBUTE_NAME,
    cast(null as date) as AI_ATTRIBUTED_AT,
    cast(null as date) as HUMAN_EVALUATED_AT
from
    newproducts fp
cross join
    attributenames an
{% if is_incremental() %}
where
    (PRODUCT_ID, BRAND_CODE, ATTRIBUTE_NAME) not in (
        select
            PRODUCT_ID,
            BRAND_CODE,
            ATTRIBUTE_NAME
        from
            {{this}}
    )
{% endif %}