select
    aps.PRODUCT_SET_ID
    , booland_agg(pr.IS_INTERNATIONAL) as IS_INTERNATIONAL
from
    {{ ref('fbb_active_product_sets') }} as aps
    join {{ref('miles_fbb_products')}} as pr on aps.PRODUCT_ID = pr.PRODUCT_ID
group by
    aps.PRODUCT_SET_ID
