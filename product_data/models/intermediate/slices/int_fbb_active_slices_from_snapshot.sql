with cte_fbb_active_slices_from_snapshot as (
    select
        *
        , row_number() over (partition by SLICE_ID order by DBT_UPDATED_AT desc) as RN
    from
        {{ ref('snapshot_fbb_active_slices') }}
    where DBT_VALID_TO is null
)
select
    *
from
    cte_fbb_active_slices_from_snapshot
where
    RN = 1