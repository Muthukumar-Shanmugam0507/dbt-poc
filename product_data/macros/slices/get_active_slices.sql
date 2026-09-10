{% macro get_active_slices(is_mp=none) %}
with cte_active_slices as (
    select distinct
        ps.PRODUCT_ID
        , ps.COLOR_ID
    from
        {{ ref('stg_land__fbb_sfra_category_product_splits') }} as ps
        join
        {% if is_mp is not none %}
            {{ ref('mp_active_variations') }}
        {% else %}
            {{ ref('fbb_active_variations') }}
        {% endif %}
        as st on ps.PRODUCT_ID = st.PRODUCT_ID and ps.COLOR_ID = st.COLOR_ID
), cte_default_colors as (
    {{ get_default_colors(is_mp) }}
)
select
    sl.PRODUCT_ID
    , sl.COLOR_ID
    , concat(sl.PRODUCT_ID, '_', sl.COLOR_ID) as SLICE_ID
from
    cte_active_slices as sl
    left join cte_default_colors as acsr on sl.COLOR_ID = acsr.COLOR_ID
where
    acsr.COLOR_ID is null
{% endmacro %}