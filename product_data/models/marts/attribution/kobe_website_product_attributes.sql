with cte_balkan_data as (
    select
        to_number(PRODUCT_ID) as PRODUCT_ID
        , ATTRIBUTE_NAME as WEBSITE_ATTRIBUTE_NAME
        , ATTRIBUTE_VALUE as WEBSITE_ATTRIBUTE_VALUE
        , CREATED_AT
    from
        {{ref('int_attributes_mapped_to_website')}} as bk
),
cte_vendors_data as (
    select
        vc.PRODUCT_ID
        , vc.WEBSITE_ATTRIBUTE_NAME
        , vc.WEBSITE_ATTRIBUTE_VALUE
        , current_date() as CREATED_AT
    from
        {{ref('int_care_attributes_mapped_to_website')}} vc
),
cte_remaining_data as (
    select
        distinct
        fv.PRODUCT_ID
        , coalesce(vd.WEBSITE_ATTRIBUTE_NAME, fv.ATTRIBUTE_NAME) as WEBSITE_ATTRIBUTE_NAME
        , coalesce(vd.WEBSITE_ATTRIBUTE_VALUE, fv.ATTRIBUTE_VALUE) as WEBSITE_ATTRIBUTE_VALUE
        , fv.CREATED_AT
    from
        {{ref('stg_land__fbb_product_attribute_values')}} as fv
    left join
        cte_balkan_data as bk using(PRODUCT_ID)
    left join
        cte_vendors_data as vd using(PRODUCT_ID)
    where
        bk.PRODUCT_ID is null
),
cte_all_data as (
    select
        PRODUCT_ID
        , WEBSITE_ATTRIBUTE_NAME
        , WEBSITE_ATTRIBUTE_VALUE
        , CREATED_AT
        , row_number() over (partition by PRODUCT_ID, WEBSITE_ATTRIBUTE_NAME, WEBSITE_ATTRIBUTE_VALUE order by CREATED_AT) as rn
    from (
        select
            PRODUCT_ID
            , WEBSITE_ATTRIBUTE_NAME
            , WEBSITE_ATTRIBUTE_VALUE
            , CREATED_AT
        from
            cte_balkan_data
        union all
        select
            PRODUCT_ID
            , WEBSITE_ATTRIBUTE_NAME
            , WEBSITE_ATTRIBUTE_VALUE
            , CREATED_AT
        from
            cte_vendors_data
        union all
        select
            PRODUCT_ID
            , WEBSITE_ATTRIBUTE_NAME
            , WEBSITE_ATTRIBUTE_VALUE
            , CREATED_AT
        from
            cte_remaining_data
    ) all_data
)
select
    PRODUCT_ID
    , WEBSITE_ATTRIBUTE_NAME
    , WEBSITE_ATTRIBUTE_VALUE
    , CREATED_AT
from
    cte_all_data
where
    rn = 1