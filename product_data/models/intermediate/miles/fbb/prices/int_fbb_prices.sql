with cte_active_promos as ( 
    select 
        PRODUCT_ID
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
        {{ ref('stg_land__fbb_sfra_final_price_promos') }} 
{#    where CREATED_AT >= current_date() - 1#}
),
cte_min_max_prices as (
    select
        pc.PRODUCT_ID
        , pc.MIN_CLR_PRICE as PRICE
        , case
            when coalesce(pc.MIN_BRW_PRICE, 0) > coalesce(pc.MIN_CLR_PRICE, 999999999) then pc.MIN_CLR_PRICE
            when coalesce(pc.MIN_CLR_PRICE, 0) = 0 and coalesce(pc.MIN_BRW_PRICE, 0) != 0 then pc.MIN_BRW_PRICE
            else coalesce(pc.MIN_BRW_PRICE, pc.MIN_CLR_PRICE, pc.MIN_FS_PRICE)
        end as MIN_BROWSE_PRICE
        , pc.MIN_CLR_PRICE as MIN_CLEARANCE_PRICE
        , pc.MIN_FS_PRICE as MIN_FINAL_SALE_PRICE
        , coalesce(sfp.MIN_BRW_PRICE, pc.MIN_BRW_PRICE, pc.MIN_CLR_PRICE) as MIN_BRW_PRICE
        , coalesce(sfp.MAX_BRW_PRICE, pc.MAX_BRW_PRICE, pc.MAX_CLR_PRICE) as MAX_BRW_PRICE
        , coalesce(sfp.MIN_CLR_PRICE, pc.MIN_CLR_PRICE) as MIN_CLR_PRICE
        , coalesce(sfp.MAX_CLR_PRICE, pc.MAX_CLR_PRICE) as MAX_CLR_PRICE
        , coalesce(sfp.MIN_FS_PRICE, pc.MIN_FS_PRICE, pc.MIN_CLR_PRICE, pc.MIN_BRW_PRICE) as MIN_FS_PRICE
        , coalesce(sfp.MAX_FS_PRICE, pc.MAX_FS_PRICE, pc.MAX_CLR_PRICE, pc.MAX_BRW_PRICE) as MAX_FS_PRICE
        , coalesce(pc.MIN_BRW_LIST_PRICE, pc.MIN_CLR_LIST_PRICE) as MIN_BRW_LIST_PRICE
        , coalesce(pc.MAX_BRW_LIST_PRICE, pc.MAX_CLR_LIST_PRICE) as MAX_BRW_LIST_PRICE
        , pc.MIN_CLR_LIST_PRICE as MIN_CLR_LIST_PRICE
        , pc.MAX_CLR_LIST_PRICE as MAX_CLR_LIST_PRICE
        , coalesce(pc.MIN_FS_LIST_PRICE, pc.MIN_CLR_LIST_PRICE) as MIN_FS_LIST_PRICE
        , coalesce(pc.MAX_FS_LIST_PRICE, pc.MAX_CLR_LIST_PRICE) as MAX_FS_LIST_PRICE
    from
        {{ ref('int_fbb_min_max_prices') }} as pc
        left join cte_active_promos as sfp on pc.PRODUCT_ID = sfp.PRODUCT_ID
),
cte_min_max_only_prices as (
    select
        pc.PRODUCT_ID
        , coalesce(sfp.MIN_BRW_ONLY_PRICE, pc.MIN_BRW_ONLY_PRICE, pc.MIN_CLR_PRICE) as MIN_BRW_ONLY_PRICE
        , coalesce(sfp.MAX_BRW_ONLY_PRICE, pc.MAX_BRW_ONLY_PRICE, pc.MAX_CLR_PRICE) as MAX_BRW_ONLY_PRICE
        , coalesce(sfp.MIN_CLR_ONLY_PRICE, pc.MIN_CLR_ONLY_PRICE, pc.MIN_CLR_PRICE) as MIN_CLR_ONLY_PRICE
        , coalesce(sfp.MAX_CLR_ONLY_PRICE, pc.MAX_CLR_ONLY_PRICE, pc.MAX_CLR_PRICE) as MAX_CLR_ONLY_PRICE
        , coalesce(pc.MIN_BRW_ONLY_LIST_PRICE, pc.MIN_CLR_LIST_PRICE) as MIN_BRW_ONLY_LIST_PRICE
        , coalesce(pc.MAX_BRW_ONLY_LIST_PRICE, pc.MAX_CLR_LIST_PRICE) as MAX_BRW_ONLY_LIST_PRICE
        , coalesce(pc.MIN_CLR_ONLY_LIST_PRICE, pc.MIN_CLR_LIST_PRICE) as MIN_CLR_ONLY_LIST_PRICE
        , coalesce(pc.MAX_CLR_ONLY_LIST_PRICE, pc.MAX_CLR_LIST_PRICE) as MAX_CLR_ONLY_LIST_PRICE
    from
        {{ ref('int_fbb_min_max_prices') }} as pc
        left join cte_active_promos as sfp on pc.PRODUCT_ID = sfp.PRODUCT_ID
)
select
    ap.PRODUCT_ID
    , mm.PRICE
    , mm.MIN_BROWSE_PRICE
    , mm.MIN_CLEARANCE_PRICE
    , mm.MIN_FINAL_SALE_PRICE
    , mm.MIN_BRW_PRICE
    , mm.MAX_BRW_PRICE
    , mm.MIN_CLR_PRICE
    , mm.MAX_CLR_PRICE
    , mm.MIN_FS_PRICE
    , mm.MAX_FS_PRICE
    , mmo.MIN_BRW_ONLY_PRICE
    , mmo.MAX_BRW_ONLY_PRICE
    , mmo.MIN_CLR_ONLY_PRICE
    , mmo.MAX_CLR_ONLY_PRICE
    , mmo.MIN_BRW_ONLY_LIST_PRICE
    , mmo.MAX_BRW_ONLY_LIST_PRICE
    , mmo.MIN_CLR_ONLY_LIST_PRICE
    , mmo.MAX_CLR_ONLY_LIST_PRICE
    , rp.BRW_LIST_PRICE
    , rp.CLR_LIST_PRICE
    , rp.FS_LIST_PRICE
    , rp.BRW_SALE_PRICE
    , rp.CLR_SALE_PRICE
    , rp.FS_SALE_PRICE
    , rp.BRW_ONLY_SALE_PRICE
    , rp.CLR_ONLY_SALE_PRICE
    , rp.BRW_ONLY_LIST_PRICE
    , rp.CLR_ONLY_LIST_PRICE
from
    {{ ref('fbb_active_products') }} as ap
    left join cte_min_max_prices as mm on ap.PRODUCT_ID = mm.PRODUCT_ID
    left join cte_min_max_only_prices as mmo on ap.PRODUCT_ID = mmo.PRODUCT_ID
    left join {{ ref('int_fbb_ranged_prices') }} as rp on ap.PRODUCT_ID = rp.PRODUCT_ID