select distinct
    aps.SPECIAL_PRODUCT_SET_ID,
    array_agg(distinct pav.ATTRIBUTE_VALUE) as PRODUCT_TYPE
from
    {{ ref('fbb_active_special_product_sets') }} as aps
    join {{source('SPS_PRODUCT_TYPES', 'SPS_PRODUCT_TYPE')}} as pav on aps.SPECIAL_PRODUCT_SET_ID = pav.SPS_ID
group by SPECIAL_PRODUCT_SET_ID