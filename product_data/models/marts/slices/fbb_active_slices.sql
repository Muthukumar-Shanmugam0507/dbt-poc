select
    PRODUCT_ID
    , COLOR_ID
    , SLICE_ID
    , date(DBT_VALID_FROM) as CREATED_AT
from
    {{ ref('int_fbb_active_slices_from_snapshot') }}
