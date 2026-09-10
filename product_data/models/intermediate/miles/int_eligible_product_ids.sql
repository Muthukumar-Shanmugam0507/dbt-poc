select
    sz.SF_PRODUCT_ID as PRODUCT_ID
    , sum(sz.QUANTITY) + sum(sz.BACKORDER_QUANTITY) > 0 as QUANTITY
from
    {{ ref('int_eligible_sizes') }} as sz
group by
    SF_PRODUCT_ID