with cte_inventory as (
    select 
        st.STYLE_ID
        , sum(inv.BACKORDER_QUANTITY + inv.QUANTITY) as QUANTITY
    from {{ ref('stg_land__fbb_products') }} as pr
        inner join {{ ref('stg_land__fbb_styles') }} as st on pr.PRODUCT_ID = st.PRODUCT_ID
        inner join {{ ref('stg_land__fbb_sizes') }} as sz on st.STYLE_ID = sz.STYLE_ID
        inner join {{ ref('stg_land__fbb_inventory') }} as inv on sz.SIZE_ID = inv.SIZE_ID
    where 
        pr.STATUS = 1
        and st.STATUS = 1
        and sz.STATUS = 1
        and inv.STATUS = 1
    group by st.STYLE_ID
),
cte_excluded_styles as (
    select distinct
        pr.PRODUCT_ID
        , st.STYLE_ID
    from {{ ref('stg_land__fbb_products') }} as pr
        inner join {{ ref('stg_land__fbb_styles') }} as st on pr.PRODUCT_ID = st.PRODUCT_ID
        inner join {{ ref('stg_land__fbb_sizes') }} as sz on st.STYLE_ID = sz.STYLE_ID
        left join {{ ref('stg_land__fbb_color_images') }} as swatch on st.COLOR_ID = swatch.COLOR_ID and swatch.IMAGE_TYPE_ID = 6 and swatch.STATUS in (1, 2)
        left join {{ ref('stg_land__fbb_color_images') }} as colorized on st.COLOR_ID = colorized.COLOR_ID and colorized.IMAGE_TYPE_ID = 5 and colorized.STATUS in (1, 2)
        inner join cte_inventory inv on st.STYLE_ID = inv.STYLE_ID
    where
        colorized.IMAGE_ID is null
        and pr.STATUS = 1
        and st.STATUS = 1
        and sz.STATUS = 1
        and coalesce(inv.QUANTITY, 0) >= 0
)
select
    PRODUCT_ID
    , STYLE_ID
from cte_excluded_styles