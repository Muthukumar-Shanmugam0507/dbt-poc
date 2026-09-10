with cte_mp_active_slices as (
    {{ get_active_slices(is_mp=true) }}
)
select
    sl.PRODUCT_ID
    , sl.COLOR_ID
    , sl.SLICE_ID
    , ( {{ get_active_slices_key() }} ) as HASH_KEY
from
    cte_mp_active_slices as sl