with fbb_active_gift_cards_from_snapshot as (
    select
        *
        , row_number() over (partition by PRODUCT_ID order by DBT_UPDATED_AT desc ) as RN
    from
        {{ ref('snapshot_fbb_active_gift_cards') }}
    where DBT_VALID_TO is null
)
select
    *
from
    fbb_active_gift_cards_from_snapshot
where
    RN = 1