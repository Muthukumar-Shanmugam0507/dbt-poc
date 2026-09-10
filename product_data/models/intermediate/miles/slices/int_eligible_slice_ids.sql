with cte_eligible_colors as (
    select
        c.SF_PRODUCT_ID
        , c.SF_COLOR_ID
        , sum(c.QUANTITY) + sum(c.BACKORDER_QUANTITY) > 0 as QUANTITY
    from
        {{ ref('int_eligible_sizes') }} as c
    group by
        c.SF_PRODUCT_ID
        , c.SF_COLOR_ID
)
, cte_default_colors as (
    {{ get_default_colors() }}
    union
    {{ get_default_colors(is_mp=TRUE) }}
)
select distinct
    sl.PRODUCT_ID
    , sl.COLOR_ID
    , c.QUANTITY
from
    {{ ref('stg_land__fbb_sfra_category_product_splits') }} as sl
    join cte_eligible_colors as c on sl.PRODUCT_ID = c.SF_PRODUCT_ID and sl.COLOR_ID = c.SF_COLOR_ID
    left join cte_default_colors as dc on sl.PRODUCT_ID = dc.PRODUCT_ID and sl.COLOR_ID = dc.COLOR_ID
where
    dc.COLOR_ID is null