select distinct
    stc.BRAND_ID
    , stc.PRODUCT_ID
    , stc.SIZE_ID
    , to_decimal(stc.SELLING_PRICE, 10, 2) as SELLING_PRICE
    , to_decimal(stc.WAS_PRICE, 10, 2) as LIST_PRICE
    , stc.QUANTITY
    , stc.BACKORDER_QUANTITY
    , st.CLEARANCE_INDICATOR
    , st.IS_FINAL_SALE
from
    {{ref('int_fbb_styles_joined_with_colors')}} as stc
    join {{ ref('stg_land__fbb_styles') }} as st on stc.COLOR_ID = st.COLOR_ID
    join {{ref('int_sfra_products_join_active_sfra_categories')}} as sfp on sfp.PRODUCT_ID = to_varchar(st.PRODUCT_ID)
where
    STYLE_STATUS = 1
    and SIZE_STATUS = 1
    and PRICE_STATUS = 1
    and PRODUCT_STATUS = 1
    and INVENTORY_STATUS = 1
    and COLOR_IMAGE_STATUS = 1
    and IMAGE_STATUS = 1
    and IMAGE_TYPE_ID = 5
    and TITLE is not null
