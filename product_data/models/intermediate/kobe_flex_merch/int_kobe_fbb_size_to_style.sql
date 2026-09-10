select
    sz.STYLE_ID
    , sum(inv.QUANTITY) as QUANTITY
    , sum(inv.BACKORDER_QUANTITY) as BACKORDER_QUANTITY
from
    {{ ref('stg_land__fbb_sizes') }} as sz
    join {{ ref('stg_land__fbb_inventory') }} as inv on sz.SIZE_ID = inv.SIZE_ID
    join {{ ref('stg_land__fbb_prices') }} as pc on sz.SIZE_ID = pc.SIZE_ID
where
    sz.STATUS = 1
    and inv.STATUS = 1
    and pc.STATUS = 1
group by sz.STYLE_ID