select distinct
    sc.MF_SIZE_ID
    , sc.SIZE_SEQUENCE_2
    , br.BR_DISPLAY_SIZE
from
    {{ ref('stg_land__mp_size_conversions') }} as sc
    join {{ ref('stg_land__fbb_br_size_conversions') }} as br ON sc.SIZE_SEQUENCE_2 = br.MF_DISPLAY_SIZE
where
    br.GROUP_ID = 5
