with cte_promo_prices as (
    select
        sfp.PRODUCT_ID
        , MIN_BRW_PRICE
        , MAX_BRW_PRICE
        , MIN_CLR_PRICE
        , MAX_CLR_PRICE
        , MIN_FS_PRICE
        , MAX_FS_PRICE
        , BRW_LIST_PRICE
        , BRW_SALE_PRICE
        , CLR_LIST_PRICE
        , CLR_SALE_PRICE
        , FS_LIST_PRICE
        , FS_SALE_PRICE
        , MIN_BRW_ONLY_PRICE
        , MAX_BRW_ONLY_PRICE
        , MIN_CLR_ONLY_PRICE
        , MAX_CLR_ONLY_PRICE
    from
        {{ ref('stg_land__fbb_sfra_final_price_promos') }} as sfp
{#    where#}
{#        sfp.CREATED_AT >= current_date() - 1#}
),
cte_list_sale_only_prices as (
    select
        ap.PRODUCT_ID
        , iff(
            mm.MIN_BRW_ONLY_PRICE is null or (mm.MIN_BRW_ONLY_PRICE = mm.MAX_BRW_ONLY_PRICE),
            coalesce(mm.MIN_BRW_ONLY_PRICE::varchar, ({{ get_product_ranged_prices(min_price="mm.MIN_CLR_PRICE", max_price="mm.MAX_CLR_PRICE") }})::varchar),
            mm.MIN_BRW_ONLY_PRICE::varchar || ' - ' || mm.MAX_BRW_ONLY_PRICE::varchar
          ) as BRW_ONLY_SALE_PRICE
        , iff(
            mm.MIN_CLR_ONLY_PRICE is null or (mm.MIN_CLR_ONLY_PRICE = mm.MAX_CLR_ONLY_PRICE),
            coalesce(mm.MIN_CLR_ONLY_PRICE::varchar, ({{ get_product_ranged_prices(min_price="mm.MIN_CLR_PRICE", max_price="mm.MAX_CLR_PRICE") }})::varchar),
            mm.MIN_CLR_ONLY_PRICE::varchar || ' - ' || mm.MAX_CLR_ONLY_PRICE::varchar
          ) as CLR_ONLY_SALE_PRICE
        , iff(
            mm.MIN_BRW_ONLY_PRICE is null or (mm.MIN_BRW_ONLY_PRICE = mm.MAX_BRW_ONLY_PRICE),
            coalesce(mm.MIN_BRW_ONLY_PRICE::varchar, ({{ get_product_ranged_prices(min_price="mm.MIN_CLR_PRICE", max_price="mm.MAX_CLR_PRICE") }})::varchar),
            mm.MIN_BRW_ONLY_PRICE::varchar || ' - ' || mm.MAX_BRW_ONLY_PRICE::varchar
          ) as BRW_ONLY_LIST_PRICE
        , iff(
            mm.MIN_CLR_ONLY_PRICE is null or (mm.MIN_CLR_ONLY_PRICE = mm.MAX_CLR_ONLY_PRICE),
            coalesce(mm.MIN_CLR_ONLY_PRICE::varchar, ({{ get_product_ranged_prices(min_price="mm.MIN_CLR_PRICE", max_price="mm.MAX_CLR_PRICE") }})::varchar),
            mm.MIN_CLR_ONLY_PRICE::varchar || ' - ' || mm.MAX_CLR_ONLY_PRICE::varchar
          ) as CLR_ONLY_LIST_PRICE
    from
        {{ ref('fbb_active_products') }} as ap
        left join {{ ref('int_fbb_min_max_prices') }} as mm on ap.PRODUCT_ID = mm.PRODUCT_ID
),
cte_list_sale_prices as (
    select
        ap.PRODUCT_ID
        , iff(
            mm.MIN_BRW_PRICE is null or (mm.MIN_BRW_PRICE = mm.MAX_BRW_PRICE),
            coalesce(mm.MIN_BRW_PRICE::varchar, mm.MIN_CLR_PRICE::varchar),
            mm.MIN_BRW_PRICE::varchar || ' - ' || mm.MAX_BRW_PRICE::varchar
          ) as BRW_SALE_PRICE
        , iff(
            mm.MIN_CLR_PRICE is null or (mm.MIN_CLR_PRICE = mm.MAX_CLR_PRICE),
            coalesce(mm.MIN_CLR_PRICE::varchar, mm.MIN_CLR_PRICE::varchar),
            mm.MIN_CLR_PRICE::varchar || ' - ' || mm.MAX_CLR_PRICE::varchar
          ) as CLR_SALE_PRICE
        , iff(
            mm.MIN_FS_PRICE is null or (mm.MIN_FS_PRICE = mm.MAX_FS_PRICE),
            coalesce(mm.MIN_FS_PRICE::varchar, mm.MIN_CLR_PRICE::varchar),
            mm.MIN_FS_PRICE::varchar || ' - ' || mm.MAX_FS_PRICE::varchar
          ) as FS_SALE_PRICE
        , iff(
            mm.MIN_BRW_LIST_PRICE is null or (mm.MIN_BRW_LIST_PRICE = mm.MAX_BRW_LIST_PRICE) ,
            coalesce(mm.MIN_BRW_LIST_PRICE::varchar, mm.MIN_CLR_LIST_PRICE::varchar),
            mm.MIN_BRW_LIST_PRICE::varchar || ' - ' || mm.MAX_BRW_LIST_PRICE::varchar
          ) as BRW_LIST_PRICE
        , iff(
            mm.MIN_CLR_LIST_PRICE is null or (mm.MIN_CLR_LIST_PRICE = mm.MAX_CLR_LIST_PRICE),
            coalesce(mm.MIN_CLR_LIST_PRICE::varchar, mm.MIN_CLR_LIST_PRICE::varchar),
            mm.MIN_CLR_LIST_PRICE::varchar || ' - ' || mm.MAX_CLR_LIST_PRICE::varchar
          ) as CLR_LIST_PRICE
        , iff(
            mm.MIN_FS_LIST_PRICE is null or (mm.MIN_FS_LIST_PRICE = mm.MAX_FS_LIST_PRICE),
            coalesce(mm.MIN_FS_LIST_PRICE::varchar, mm.MIN_CLR_LIST_PRICE::varchar),
            mm.MIN_FS_LIST_PRICE::varchar || ' - ' || mm.MAX_FS_LIST_PRICE::varchar
          ) as FS_LIST_PRICE
    from
        {{ ref('fbb_active_products') }} as ap
        left join {{ ref('int_fbb_min_max_prices') }} as mm on ap.PRODUCT_ID = mm.PRODUCT_ID
)
select
    ap.PRODUCT_ID
    , coalesce(sfp.BRW_LIST_PRICE, lsp.BRW_LIST_PRICE, lsp.CLR_LIST_PRICE, lsp.FS_LIST_PRICE) as BRW_LIST_PRICE
    , coalesce(sfp.CLR_LIST_PRICE, lsp.CLR_LIST_PRICE, lsp.BRW_LIST_PRICE, lsp.FS_LIST_PRICE) as CLR_LIST_PRICE
    , coalesce(sfp.FS_LIST_PRICE, lsp.FS_LIST_PRICE, lsp.CLR_LIST_PRICE, lsp.BRW_LIST_PRICE) as FS_LIST_PRICE
    , coalesce(sfp.BRW_SALE_PRICE, lsp.BRW_SALE_PRICE, lsp.CLR_SALE_PRICE, lsp.FS_SALE_PRICE) as BRW_SALE_PRICE
    , coalesce(sfp.CLR_SALE_PRICE, lsp.CLR_SALE_PRICE, lsp.BRW_SALE_PRICE, lsp.FS_SALE_PRICE) as CLR_SALE_PRICE
    , coalesce(sfp.FS_SALE_PRICE, lsp.FS_SALE_PRICE, lsp.CLR_SALE_PRICE, lsp.BRW_SALE_PRICE) as FS_SALE_PRICE
    , lsop.BRW_ONLY_SALE_PRICE
    , lsop.CLR_ONLY_SALE_PRICE
    , lsop.BRW_ONLY_LIST_PRICE
    , lsop.CLR_ONLY_LIST_PRICE
from
    {{ ref('fbb_active_products') }} as ap
    left join cte_list_sale_prices as lsp on ap.PRODUCT_ID = lsp.PRODUCT_ID
    left join cte_list_sale_only_prices as lsop on ap.PRODUCT_ID = lsop.PRODUCT_ID
    left join cte_promo_prices as sfp on ap.PRODUCT_ID = sfp.PRODUCT_ID