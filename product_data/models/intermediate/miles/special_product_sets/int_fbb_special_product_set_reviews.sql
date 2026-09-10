select
    SPECIAL_PRODUCT_SET_ID
    , PRODUCT_ID
    , REVIEW_AVERAGE
    , REVIEW_COUNT
from
    {{ ref('stg_land__fbb_turn_to_product_set_reviews') }} as psr
    join {{ ref('stg_land__fbb_sfra_special_product_sets') }} as sps on psr.PRODUCT_SET_ID = sps.UBERSET_ID