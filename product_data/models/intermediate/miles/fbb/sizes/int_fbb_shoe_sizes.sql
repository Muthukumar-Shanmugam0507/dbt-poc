select distinct
    MF_SIZE_ID
    , sc.MF_DISPLAY_SIZE
    , sc.GROUP_ID as SC_GROUP_ID
    , sc.SPLIT_SIZE_1 as SPLIT_SIZE_1
    , brs.BR_DISPLAY_SIZE as BR_DISPLAY_SIZE
    , coalesce(brs.BR_DISPLAY_SIZE, sc.SPLIT_SIZE_1) as SHOE_SIZE
from 
    {{ ref('stg_land__fbb_size_conversions') }} as sc
    left join (
        select
            brs.MF_DISPLAY_SIZE
            , regexp_replace(brs.BR_DISPLAY_SIZE, '\\s+', '') as BR_DISPLAY_SIZE
        from
            {{ ref('stg_land__fbb_br_size_conversions') }} as brs
        where
            brs.GROUP_ID = 5
        qualify
            row_number() over(partition by brs.MF_DISPLAY_SIZE order by brs.MF_DISPLAY_SIZE) = 1
    ) brs on brs.MF_DISPLAY_SIZE = sc.SPLIT_SIZE_1
where
    SC_GROUP_ID = 1
