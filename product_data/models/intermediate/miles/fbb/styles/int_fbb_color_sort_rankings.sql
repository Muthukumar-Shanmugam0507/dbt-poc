with cte_distinct_color_sort_rankings as (
    select
        PRODUCT_ID
        , COLOR_ID
        , COLOR_SORT_ORDER
    from
        {{ ref('stg_land__fbb_color_sort_order_skus') }}
    qualify
        row_number() over (partition by COLOR_ID order by COLOR_SORT_ORDER desc) = 1
),
cte_lowest_rankings as (
    select
        PRODUCT_ID
        , COLOR_ID
    from
        cte_distinct_color_sort_rankings
    qualify
        row_number() over (partition by PRODUCT_ID order by COLOR_SORT_ORDER asc) = 1
)
select
    cl.PRODUCT_ID
    , cl.COLOR_ID
    , csd.COLOR_SORT_ORDER
    , iff(clr.COLOR_ID is not null, true, false) as LOWEST_COLOR_SORT
from
    {{ ref('stg_land__fbb_colors') }} as cl
    left join cte_distinct_color_sort_rankings as csd on cl.PRODUCT_ID = csd.PRODUCT_ID and cl.COLOR_ID = csd.COLOR_ID
    left join cte_lowest_rankings as clr on cl.PRODUCT_ID = clr.PRODUCT_ID and cl.COLOR_ID = clr.COLOR_ID
