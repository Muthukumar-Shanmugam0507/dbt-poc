with cte_current_attributes_pivoted as (
    select
        product_id
        , case when left(product_id::varchar, 1) = '6' then 'MP' else brand_code end as brand_code
        , division
        , category
        , subcategory
    from (
        select
            product_id
            , brand_code
            , attribute_name
            , attribute_value
        from
            {{ ref('ds_product_level_attributes')}}
    ) as source
    PIVOT (
        max(attribute_value)
        for attribute_name in ('DIVISION', 'CATEGORY', 'SUBCATEGORY')
    ) as attributes (product_id, brand_code, division, category, subcategory)
),
cte_mapping_kobe as (
    select
        da.product_id
        , da.brand_code
        , km.KOBE_DIVISION as division
        , km.KOBE_CATEGORY as category
        , km.KOBE_SUBCATEGORY as subcategory
    from
        cte_current_attributes_pivoted as da
    left join
        {{source('KOBE', 'KOBE_TAXONOMY_MAP')}} as km
    on
        da.division = km.DIVISION
        and da.category = km.CATEGORY
        and (da.subcategory = km.SUBCATEGORY or (da.subcategory is null and km.SUBCATEGORY is null))
),
cte_seed_kobe_attributes as (
    select
        product_id
        , brand_code
        , attribute_name
        , attribute_value
        , annotated_by
        , created_at
        , updated_at
    from
        {{ ref('kobe_product_level_attributes_seed') }}
),
cte_unpivoted as(
    select
        product_id
        , brand_code
        , attribute_name
        , attribute_value
    from
        (
        select
            product_id
            , brand_code
            , division
            , category
            , subcategory
        from
            cte_mapping_kobe
        ) as p
        unpivot
        (
            attribute_value for attribute_name in (DIVISION, CATEGORY, SUBCATEGORY)
        ) as up (product_id, brand_code, attribute_name, attribute_value)
),
cte_attributes_dates as (
    select
        un.PRODUCT_ID
        , un.BRAND_CODE
        , un.ATTRIBUTE_NAME
        , un.ATTRIBUTE_VALUE
        , 'HUMAN' as ANNOTATED_BY
        , coalesce(pla.CREATED_AT, current_date()) as CREATED_AT
        , coalesce(pla.UPDATED_AT, current_date()) as UPDATED_AT
    from
        cte_unpivoted as un
    left join {{ ref('ds_product_level_attributes')}} as pla on pla.product_id = un.product_id and pla.brand_code = un.brand_code and pla.attribute_name = un.attribute_name
)
select
    product_id
    , brand_code
    , attribute_name
    , attribute_value
    , annotated_by
    , coalesce(created_at, current_date()) as created_at
    , coalesce(updated_at, current_date()) as updated_at
from
    cte_attributes_dates
union all
select
    product_id
    , brand_code
    , attribute_name
    , attribute_value
    , annotated_by
    , created_at
    , updated_at
from
    cte_seed_kobe_attributes

