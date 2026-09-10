with mp_active_styles_from_snapshot as (
    select
        *
        , row_number() over (partition by PRODUCT_ID, STYLE_ID, SIZE_ID order by DBT_UPDATED_AT desc ) as RN
    from
        {{ ref('snapshot_mp_active_styles') }}
    where DBT_VALID_TO is null
)
select
    *
from
    mp_active_styles_from_snapshot
where
    RN = 1
