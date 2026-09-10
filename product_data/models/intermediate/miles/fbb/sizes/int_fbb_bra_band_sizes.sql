select distinct 
    sc.MF_SIZE_ID
    , sc.MF_DISPLAY_SIZE
    , sc.GROUP_ID as GROUP_ID_4
    , case
        when
            cl.GROUP_ID = 2
            or (cl.GROUP_ID = 0 and pr.CLASSIFICATION_ID in (42, 44, 45)
            and pr.MF_DEPARTMENT in (17, 33)) then sc.SPLIT_SIZE_1
        else
            null
    end as bra_band_size
from
    {{ ref('stg_land__fbb_size_conversions') }} as sc
    join {{ ref('stg_land__fbb_classifications') }} as cl on cl.GROUP_ID = sc.GROUP_ID
    join {{ ref('stg_land__fbb_products') }} as pr on pr.CLASSIFICATION_ID = cl.CLASSIFICATION_ID
where
    GROUP_ID_4 = 2
