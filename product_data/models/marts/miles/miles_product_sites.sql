with cte_distinct_product_categories as (
    select distinct
        PRODUCT_ID
        , array_agg(distinct value:id::string) as CATEGORIES
    from
        {{ref('miles_category_products')}},
        lateral flatten(input => PARENT_CATEGORIES)
    group by PRODUCT_ID
),
cte_distinct_product_sites as (
    select distinct
        PRODUCT_ID
        , array_agg(distinct BRAND_ID) as SELLING_SITES
    from
        {{ref('miles_category_products')}}
    group by
        PRODUCT_ID
)
select
    dpc.PRODUCT_ID
    , SELLING_SITES
    , CATEGORIES
from
    cte_distinct_product_categories as dpc
    join cte_distinct_product_sites as dps on dpc.PRODUCT_ID = dps.PRODUCT_ID