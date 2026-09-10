with cte_fbb_product_sets_partitioned as (
    select
        PRODUCT_SET_ID
        , PRODUCT_ID
        , DISPLAY_NAME
        , URL
        , LIST_PRICE
        , SALE_PRICE
        , SITE_ID
        , row_number() over (partition by PRODUCT_SET_ID, PRODUCT_ID order by CREATED_AT) as RN
    from
        {{ ref('stg_land__fbb_sfra_product_sets') }}
    where
        SEARCHABLE_FLAG
        and ONLINE_FLAG
        and AVAILABLE_FLAG
)
select
    *
from
    cte_fbb_product_sets_partitioned
where
    RN = 1
