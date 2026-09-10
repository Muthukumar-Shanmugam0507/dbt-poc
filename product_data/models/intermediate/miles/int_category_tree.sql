with cte_categories_with_products as (
    select distinct
        ac.CATEGORY_ID
        , ac.NAME
        , ac.BRAND_ID
        , ac.PARENT_ID
        , ac.HIDE_MASTER_PRODUCT_IN_SLICING
    from
        {{ ref('int_active_sfra_categories') }} as ac
        join {{ ref('stg_land__fbb_sfra_category_products') }} as cp on ac.CATEGORY_ID = cp.CATEGORY_ID
)

-- climb from each leaf up through its ancestors
, cte_category_tree as (
    -- base: leaf itself at level 0
    select
        l.CATEGORY_ID as LEAF_CATEGORY_ID
        , l.CATEGORY_ID as ANCESTOR_CATEGORY_ID
        , l.NAME as ANCESTOR_NAME
        , l.BRAND_ID
        , l.PARENT_ID
        , l.HIDE_MASTER_PRODUCT_IN_SLICING
        , 0 as LEVEL_FROM_LEAF
    from
        cte_categories_with_products as l

    union all

    -- recursive: move to parent of the current ancestor
    select
        t.LEAF_CATEGORY_ID
        , p.CATEGORY_ID as ANCESTOR_CATEGORY_ID
        , p.NAME as ANCESTOR_NAME
        , p.BRAND_ID
        , p.PARENT_ID
        , p.HIDE_MASTER_PRODUCT_IN_SLICING
        , t.LEVEL_FROM_LEAF + 1
    from
        cte_category_tree as t
        join {{ ref('int_active_sfra_categories') }} as p on p.CATEGORY_ID = t.PARENT_ID
    where
        p.CATEGORY_ID <> t.ANCESTOR_CATEGORY_ID
)
select
    LEAF_CATEGORY_ID
    , LEVEL_FROM_LEAF
    , ANCESTOR_CATEGORY_ID
    , ANCESTOR_NAME
    , BRAND_ID
    , PARENT_ID
    , HIDE_MASTER_PRODUCT_IN_SLICING
from
    cte_category_tree