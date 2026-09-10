with active_products as (
    select distinct
        PRODUCT_ID
    from
        {{ ref('miles_mp_styles') }} as ap
),
price as (
    select
        PRODUCT_ID
        , min(SELLING_PRICE) as MIN_SALE_PRICE
        , max(SELLING_PRICE) as MAX_SALE_PRICE
        , min(WAS_PRICE) as MIN_LIST_PRICE
        , max(WAS_PRICE) as MAX_LIST_PRICE
    from
        {{ ref('miles_mp_styles') }} as active
    where
        QUANTITY > 0
    group by
        PRODUCT_ID
)
select
    ap.PRODUCT_ID
    , MIN_SALE_PRICE as PRICE
    , MIN_SALE_PRICE as MIN_BROWSE_PRICE
    , MIN_SALE_PRICE as MIN_BRW_PRICE
    , MAX_SALE_PRICE as MAX_BRW_PRICE
    , MIN_SALE_PRICE as MIN_CLR_PRICE
    , MAX_SALE_PRICE as MAX_CLR_PRICE
    , MIN_SALE_PRICE as MIN_FS_PRICE
    , MAX_SALE_PRICE as MAX_FS_PRICE
    , iff(
        (MIN_LIST_PRICE = MAX_LIST_PRICE) or MIN_LIST_PRICE is null,
        MIN_LIST_PRICE::varchar,
        (MIN_LIST_PRICE || ' - ' || MAX_LIST_PRICE)::varchar)
    as BRW_LIST_PRICE
    , iff(
        (MIN_SALE_PRICE = MAX_SALE_PRICE) or MIN_SALE_PRICE is null,
        MIN_SALE_PRICE::varchar,
        (MIN_SALE_PRICE || ' - ' || MAX_SALE_PRICE)::varchar)
    as BRW_SALE_PRICE
    , BRW_LIST_PRICE as CLR_LIST_PRICE
    , BRW_LIST_PRICE as FS_LIST_PRICE
    , BRW_SALE_PRICE as CLR_SALE_PRICE
    , BRW_SALE_PRICE as FS_SALE_PRICE
from
    active_products as ap
    left join price on ap.PRODUCT_ID = price.PRODUCT_ID
