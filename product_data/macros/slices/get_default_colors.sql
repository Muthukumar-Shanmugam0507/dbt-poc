{% macro get_default_colors(is_mp=none) %}
select
    csku.PRODUCT_ID as PRODUCT_ID
    , csku.COLOR_ID as COLOR_ID
    , csku.COLOR_SORT_ORDER as COLOR_SORT_ORDER
from
    {{ ref('stg_land__fbb_color_sort_order_skus') }} as csku
    join
    {% if is_mp is not none %}
        {{ ref('mp_active_variations') }}
    {% else %}
        {{ ref('fbb_active_variations') }}
    {% endif %}
    as st on csku.COLOR_ID = st.COLOR_ID
qualify
    row_number() over (partition by csku.PRODUCT_ID order by COLOR_SORT_ORDER asc) = 1
{% endmacro %}