{% macro get_kobe_variants_from_snapshot(prefix) %}
with kobe_variants_from_snapshot as (
    select
        *
        , row_number() over (partition by VARIANT_ID order by DBT_UPDATED_AT desc ) as RN
    from
        {{ ref('snapshot_' ~ prefix ~ '_kobe_variants') }}
    where DBT_VALID_TO is null
)
select
    *
from
    kobe_variants_from_snapshot
where
    RN = 1
{% endmacro %}