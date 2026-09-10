with cte_fbb_active_product_sets_from_snapshot as (
    select
        *
        , row_number() over (partition by PRODUCT_SET_ID, PRODUCT_ID order by DBT_UPDATED_AT desc ) as RN
    from
        {{ ref('snapshot_fbb_active_product_sets') }}
    where DBT_VALID_TO is null
)
select
    *
from
    cte_fbb_active_product_sets_from_snapshot
where
    RN = 1