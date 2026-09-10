with color_names as (
    select distinct
        st.COLOR_ID
        , cm.GENERIC_COLOR_NAME
    from
        {{ ref('stg_land__fbb_styles') }} as st
        left join {{ ref('stg_land__fbb_color_mappings') }} as cm on cm.SPECIFIC_COLOR = st.COLOR
)
select
    cn.COLOR_ID
    , array_agg(cn.GENERIC_COLOR_NAME) as COLOR_GROUP_ARRAY
    , count(distinct cn.GENERIC_COLOR_NAME) as COLOR_GROUP_COUNT
from
    color_names as cn
group by
    cn.COLOR_ID
