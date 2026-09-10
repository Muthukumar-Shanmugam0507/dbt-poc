with cte_prices as (
    select
        PRODUCT_ID
        , min(SELLING_PRICE) as MIN_SELLING_PRICE
        , max(SELLING_PRICE) as MAX_SELLING_PRICE
        , min(LIST_PRICE) as MIN_LIST_PRICE
        , max(LIST_PRICE) as MAX_LIST_PRICE
    from {{ ref('int_fbb_base_prices')}}
    group by PRODUCT_ID
),
cte_non_fs_prices as (
    select
        PRODUCT_ID
        , min(SELLING_PRICE) as MIN_BRW_PRICE
        , max(SELLING_PRICE) as MAX_BRW_PRICE
        , min(LIST_PRICE) as MIN_BRW_LIST_PRICE
        , max(LIST_PRICE) as MAX_BRW_LIST_PRICE
    from
        {{ ref('int_fbb_base_prices')}}
    where
        IS_FINAL_SALE = 0
    group by PRODUCT_ID
),
cte_fs_prices as (
    select
        PRODUCT_ID
        , min(SELLING_PRICE) as MIN_FS_PRICE
        , max(SELLING_PRICE) as MAX_FS_PRICE
        , min(LIST_PRICE) as MIN_FS_LIST_PRICE
        , max(LIST_PRICE) as MAX_FS_LIST_PRICE
    from
        {{ ref('int_fbb_base_prices')}}
    where
        IS_FINAL_SALE = 1 and CLEARANCE_INDICATOR = 'C'
    group by PRODUCT_ID
),
cte_brw_only_prices as (
    select
        pc.PRODUCT_ID
        , min(pc.SELLING_PRICE) as MIN_BRW_ONLY_PRICE
        , max(pc.SELLING_PRICE) as MAX_BRW_ONLY_PRICE
        , min(pc.LIST_PRICE) as MIN_BRW_ONLY_LIST_PRICE
        , max(pc.LIST_PRICE) as MAX_BRW_ONLY_LIST_PRICE
    from
        {{ ref('int_fbb_base_prices')}} pc
    where
        pc.CLEARANCE_INDICATOR = 'B' and pc.IS_FINAL_SALE = 0
    group by pc.PRODUCT_ID
),
cte_clr_only_prices as (
    select
        pc.PRODUCT_ID
        , min(pc.SELLING_PRICE) as MIN_CLR_ONLY_PRICE
        , max(pc.SELLING_PRICE) as MAX_CLR_ONLY_PRICE
        , min(pc.LIST_PRICE) as MIN_CLR_ONLY_LIST_PRICE
        , max(pc.LIST_PRICE) as MAX_CLR_ONLY_LIST_PRICE
    from
        {{ ref('int_fbb_base_prices')}} pc
    where
        pc.CLEARANCE_INDICATOR = 'C' and pc.IS_FINAL_SALE = 0
    group by pc.PRODUCT_ID
)
select
    ap.PRODUCT_ID
    , pc.MIN_SELLING_PRICE as MIN_CLR_PRICE
    , pc.MAX_SELLING_PRICE as MAX_CLR_PRICE
    , pc.MIN_LIST_PRICE as MIN_CLR_LIST_PRICE
    , pc.MAX_LIST_PRICE as MAX_CLR_LIST_PRICE
    , nfs.MIN_BRW_PRICE
    , nfs.MAX_BRW_PRICE
    , nfs.MIN_BRW_LIST_PRICE
    , nfs.MAX_BRW_LIST_PRICE
    , fs.MIN_FS_PRICE
    , fs.MAX_FS_PRICE
    , fs.MIN_FS_LIST_PRICE
    , fs.MAX_FS_LIST_PRICE
    , brw.MIN_BRW_ONLY_PRICE
    , brw.MAX_BRW_ONLY_PRICE
    , brw.MIN_BRW_ONLY_LIST_PRICE
    , brw.MAX_BRW_ONLY_LIST_PRICE
    , clr.MIN_CLR_ONLY_PRICE
    , clr.MAX_CLR_ONLY_PRICE
    , clr.MIN_CLR_ONLY_LIST_PRICE
    , clr.MAX_CLR_ONLY_LIST_PRICE
from
    {{ ref('fbb_active_products') }} as ap
    left join cte_prices as pc on ap.PRODUCT_ID = pc.PRODUCT_ID
    left join cte_non_fs_prices as nfs on ap.PRODUCT_ID = nfs.PRODUCT_ID
    left join cte_fs_prices as fs on ap.PRODUCT_ID = fs.PRODUCT_ID
    left join cte_brw_only_prices as brw on ap.PRODUCT_ID = brw.PRODUCT_ID
    left join cte_clr_only_prices as clr on ap.PRODUCT_ID = clr.PRODUCT_ID