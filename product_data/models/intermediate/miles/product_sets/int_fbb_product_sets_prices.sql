with cte_active_product_sets as (
    select distinct
        PRODUCT_SET_ID
    from
        {{ ref('fbb_active_product_sets') }}
),
cte_sale_price as (
    select
        PRODUCT_SET_ID
        , PRODUCT_SALE_PRICE
    from
        {{ ref('int_fbb_active_product_sets') }} as aps
    qualify row_number() over(partition by PRODUCT_SET_ID order by PRODUCT_SALE_PRICE asc) = 1
),
cte_set_prices as (
    select
        PRODUCT_SET_ID
        , SALE_PRICE
        , LIST_PRICE
        , iff(position('-', LIST_PRICE) = 0, try_to_decimal(LIST_PRICE, 10, 2), try_to_decimal(split_part(LIST_PRICE, '-', 1), 10, 2)) as MIN_LIST_PRICE
        , iff(position('-', LIST_PRICE) = 0, try_to_decimal(LIST_PRICE, 10, 2), try_to_decimal(split_part(LIST_PRICE, '-', 2), 10, 2)) as MAX_LIST_PRICE
        , iff(position('-', SALE_PRICE) = 0, try_to_decimal(SALE_PRICE, 10, 2), try_to_decimal(split_part(SALE_PRICE, '-', 1), 10, 2)) as MIN_SALE_PRICE
        , iff(position('-', SALE_PRICE) = 0, try_to_decimal(SALE_PRICE, 10, 2), try_to_decimal(split_part(SALE_PRICE, '-', 2), 10, 2)) as MAX_SALE_PRICE
    from
        {{ ref('stg_land__fbb_sfra_product_sets') }}
    group by
        PRODUCT_SET_ID
        , SALE_PRICE
        , LIST_PRICE
)
select
    aps.PRODUCT_SET_ID
    , PRODUCT_SALE_PRICE as PRICE
    , PRICE as MIN_BROWSE_PRICE
    , MIN_SALE_PRICE as MIN_BRW_PRICE
    , MAX_SALE_PRICE as MAX_BRW_PRICE
    , MIN_SALE_PRICE as MIN_CLR_PRICE
    , MAX_SALE_PRICE as MAX_CLR_PRICE
    , MIN_SALE_PRICE as MIN_FS_PRICE
    , MAX_SALE_PRICE as MAX_FS_PRICE
    , MIN_SALE_PRICE as MIN_BRW_ONLY_PRICE
    , MAX_SALE_PRICE as MAX_BRW_ONLY_PRICE
    , MIN_SALE_PRICE as MIN_CLR_ONLY_PRICE
    , MAX_SALE_PRICE as MAX_CLR_ONLY_PRICE
    , LIST_PRICE as BRW_LIST_PRICE
    , SALE_PRICE as BRW_SALE_PRICE
    , LIST_PRICE as CLR_LIST_PRICE
    , SALE_PRICE as CLR_SALE_PRICE
    , LIST_PRICE as FS_LIST_PRICE
    , SALE_PRICE as FS_SALE_PRICE
    , LIST_PRICE as BRW_ONLY_LIST_PRICE
    , SALE_PRICE as BRW_ONLY_SALE_PRICE
    , LIST_PRICE as CLR_ONLY_LIST_PRICE
    , SALE_PRICE as CLR_ONLY_SALE_PRICE
from
    cte_active_product_sets as aps
    join cte_sale_price as slp on aps.PRODUCT_SET_ID = slp.PRODUCT_SET_ID
    join cte_set_prices as sp on aps.PRODUCT_SET_ID = sp.PRODUCT_SET_ID
