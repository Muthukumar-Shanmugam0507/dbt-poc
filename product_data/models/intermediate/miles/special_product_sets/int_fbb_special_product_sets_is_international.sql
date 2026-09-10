select
    asps.SPECIAL_PRODUCT_SET_ID
    , booland_agg(pr.IS_INTERNATIONAL) as IS_INTERNATIONAL
from
    {{ ref('int_fbb_special_product_sets_joined_with_active_products') }} as asps
    join {{ ref('stg_land__fbb_sfra_special_product_sets') }} as sps on asps.SPECIAL_PRODUCT_SET_ID = sps.SPECIAL_PRODUCT_SET_ID
    join {{ ref('stg_land__fbb_products') }} as pr on sps.PRODUCT_ID = pr.PRODUCT_ID
group by
    asps.SPECIAL_PRODUCT_SET_ID
