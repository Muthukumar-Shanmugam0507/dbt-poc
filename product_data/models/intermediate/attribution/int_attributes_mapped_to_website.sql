with cte_product_attributes as(
    select
        distinct
        pv.PRODUCT_ID
        , pa.ATTRIBUTE_NAME
        , pa.ATTRIBUTE_VALUE
        , pa.CREATED_AT
    from
        {{ref('stg_land__fbb_products')}} as pv
    left join
        {{ref('ds_product_level_attributes')}} as pa using(PRODUCT_ID)
    where
        ATTRIBUTE_NAME is not null
        and ATTRIBUTE_VALUE is not null
),
cte_mapped_attributes as (
    select
        cp.PRODUCT_ID
        , mw.WEBSITE_ATTRIBUTE_NAME as ATTRIBUTE_NAME
        , mw.WEBSITE_ATTRIBUTE_VALUE as ATTRIBUTE_VALUE
        , cp.CREATED_AT
    from
        cte_product_attributes as cp
    left join
        {{source('PDM', 'MAPPING_BETWEEN_APPROVED_AND_WEBSITE')}} as mw
    ON
        cp.ATTRIBUTE_NAME = mw.APPROVED_ATTRIBUTE_NAME and
        cp.ATTRIBUTE_VALUE = mw.APPROVED_ATTRIBUTE_VALUE
    where
        mw.WEBSITE_ATTRIBUTE_NAME is not null
        and mw.WEBSITE_ATTRIBUTE_VALUE is not null
        and mw.WEBSITE_ATTRIBUTE_NAME != 'Shoe Width'

    union

    select
        cp.PRODUCT_ID
        , mw.WEBSITE_ATTRIBUTE_NAME_2 as ATTRIBUTE_NAME
        , mw.WEBSITE_ATTRIBUTE_VALUE_2 as ATTRIBUTE_VALUE
        , cp.CREATED_AT
    from
        cte_product_attributes as cp
    left join
        {{source('PDM', 'MAPPING_BETWEEN_APPROVED_AND_WEBSITE')}} as mw
    ON
        cp.ATTRIBUTE_NAME = mw.APPROVED_ATTRIBUTE_NAME
        and cp.ATTRIBUTE_VALUE = mw.APPROVED_ATTRIBUTE_VALUE
    where
        mw.WEBSITE_ATTRIBUTE_NAME_2 is not null
        and mw.WEBSITE_ATTRIBUTE_VALUE_2 is not null
        and mw.WEBSITE_ATTRIBUTE_NAME_2 != 'Shoe Width'

    union

    select
        cp.PRODUCT_ID
        , mw.WEBSITE_ATTRIBUTE_NAME_3 as ATTRIBUTE_NAME
        , mw.WEBSITE_ATTRIBUTE_VALUE_3 as ATTRIBUTE_VALUE
        , cp.CREATED_AT
    from
        cte_product_attributes as cp
    left join
        {{source('PDM', 'MAPPING_BETWEEN_APPROVED_AND_WEBSITE')}} as mw
    ON
        cp.ATTRIBUTE_NAME = mw.APPROVED_ATTRIBUTE_NAME
        and cp.ATTRIBUTE_VALUE = mw.APPROVED_ATTRIBUTE_VALUE
    where
        mw.WEBSITE_ATTRIBUTE_NAME_3 is not null
        and mw.WEBSITE_ATTRIBUTE_VALUE_3 is not null
        and mw.WEBSITE_ATTRIBUTE_NAME_3 != 'Shoe Width'
)
select
    PRODUCT_ID
    , ATTRIBUTE_NAME
    , ATTRIBUTE_VALUE
    , CREATED_AT
from
    cte_mapped_attributes