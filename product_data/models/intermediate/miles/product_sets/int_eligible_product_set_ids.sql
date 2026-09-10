select
    distinct ps.PRODUCT_SET_ID
from
    {{ ref('stg_land__fbb_sfra_product_sets') }} as ps
    join {{ ref('int_eligible_product_ids') }} as pr on pr.PRODUCT_ID = ps.PRODUCT_ID
where
    ps.SEARCHABLE_FLAG
    and ps.ONLINE_FLAG
    and ps.AVAILABLE_FLAG