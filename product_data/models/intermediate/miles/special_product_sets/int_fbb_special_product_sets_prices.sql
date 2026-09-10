with cte_active_special_product_sets as (
    select distinct
        sps.SPECIAL_PRODUCT_SET_ID
    from
        {{ ref('fbb_active_special_product_sets') }} as sps
),
cte_price_sums as (
    select
        SPECIAL_PRODUCT_SET_ID
        , sum(COLOR_SALE_PRICE) as SUM_COLOR_PRICE
    from
        {{ ref('int_fbb_active_special_product_sets') }}
    group by
        SPECIAL_PRODUCT_SET_ID
),
cte_set_prices as (
    select
        SPECIAL_PRODUCT_SET_ID
        , SALE_PRICE
        , LIST_PRICE
        , iff(position('-', LIST_PRICE) = 0, try_to_decimal(LIST_PRICE, 10, 2), try_to_decimal(split_part(LIST_PRICE, '-', 1), 10, 2)) as MIN_LIST_PRICE
        , iff(position('-', LIST_PRICE) = 0, try_to_decimal(LIST_PRICE, 10, 2), try_to_decimal(split_part(LIST_PRICE, '-', 2), 10, 2)) as MAX_LIST_PRICE
        , iff(position('-', SALE_PRICE) = 0, try_to_decimal(SALE_PRICE, 10, 2), try_to_decimal(split_part(SALE_PRICE, '-', 1), 10, 2)) as MIN_SALE_PRICE
        , iff(position('-', SALE_PRICE) = 0, try_to_decimal(SALE_PRICE, 10, 2), try_to_decimal(split_part(SALE_PRICE, '-', 2), 10, 2)) as MAX_SALE_PRICE
    from
        {{ ref('int_fbb_active_special_product_sets') }}
    group by
        SPECIAL_PRODUCT_SET_ID
        , SALE_PRICE
        , LIST_PRICE
)
select
    aps.SPECIAL_PRODUCT_SET_ID
    , to_decimal(SUM_COLOR_PRICE, 10, 2) as PRICE
    , to_decimal(SUM_COLOR_PRICE, 10, 2) as MIN_BROWSE_PRICE
    , MIN_SALE_PRICE as MIN_BRW_PRICE
    , MAX_SALE_PRICE as MAX_BRW_PRICE
    , MIN_SALE_PRICE as MIN_CLR_PRICE
    , MAX_SALE_PRICE as MAX_CLR_PRICE
    , MIN_SALE_PRICE as MIN_FS_PRICE
    , MAX_SALE_PRICE as MAX_FS_PRICE
    , LIST_PRICE as BRW_LIST_PRICE
    , SALE_PRICE as BRW_SALE_PRICE
    , LIST_PRICE as CLR_LIST_PRICE
    , SALE_PRICE as CLR_SALE_PRICE
    , LIST_PRICE as FS_LIST_PRICE
    , SALE_PRICE as FS_SALE_PRICE
from
    cte_active_special_product_sets as aps
    join cte_price_sums on aps.SPECIAL_PRODUCT_SET_ID = cte_price_sums.SPECIAL_PRODUCT_SET_ID
    join cte_set_prices on aps.SPECIAL_PRODUCT_SET_ID = cte_set_prices.SPECIAL_PRODUCT_SET_ID
