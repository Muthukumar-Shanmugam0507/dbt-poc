with cte_all_care_products as (
    select
        MASTER_ITEM_NUMBER
        , CARE_CODE
        , DIVISION
    from (
        select
            MASTER_ITEM_NUMBER
            , CARE_CODE
            , DIVISION
            , row_number() over (partition by MASTER_ITEM_NUMBER order by SEASON desc) as rn
        from
            {{ref('stg_prod__finance_cmn_item_season')}}
        where
            CARE_CODE != 000
    ) as subquery
    where rn = 1
),
cte_all_active_products as (
    select
        distinct
        MF_MASTER_ITEM_ID as MF_PRODUCT_ID
        , PRODUCT_ID
        , PRODUCT_URL
        , BRAND_ID
    from
       {{ref('fbb_active_products')}}
),
cte_care_attributes_to_kobe_attributes as (
    select
        distinct
        pv.product_id
        , mc.ATTRIBUTE_NAME_1
        , mc.ATTRIBUTE_VALUE_1
        , mc.ATTRIBUTE_NAME_2
        , mc.ATTRIBUTE_VALUE_2
    from
        cte_all_care_products as ap
    join
        cte_all_active_products as pv
    on
        AP.MASTER_ITEM_NUMBER = PV.MF_PRODUCT_ID
        and ap.DIVISION = pv.BRAND_ID
    left join
        {{source('KOBE', 'MAP_CARE_ATTRIBUTES')}} as mc using(CARE_CODE)
),
cte_products_with_care_attribute as (
    select
        product_id
        , ATTRIBUTE_NAME_1
        , ATTRIBUTE_VALUE_1
    from
        cte_care_attributes_to_kobe_attributes
    union
    select
        product_id
        , ATTRIBUTE_NAME_2
        , ATTRIBUTE_VALUE_2
    from
        cte_care_attributes_to_kobe_attributes
    where
        ATTRIBUTE_NAME_2 is not null
)
select
    distinct
    pa.product_id
    , mw.WEBSITE_ATTRIBUTE_NAME
    , mw.WEBSITE_ATTRIBUTE_VALUE
from
    cte_products_with_care_attribute as pa
left join
    {{source('PDM', 'MAPPING_BETWEEN_APPROVED_AND_WEBSITE')}} as mw
where
    pa.ATTRIBUTE_NAME_1 = mw.APPROVED_ATTRIBUTE_NAME
    and pa.ATTRIBUTE_VALUE_1 = mw.APPROVED_ATTRIBUTE_VALUE
