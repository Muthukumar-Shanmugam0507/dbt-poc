select
    st.PRODUCT_ID
    , st.COLOR_ID
    , st.FULFILLMENT_INDICATOR
    , sum(st.QUANTITY) as QUANTITY
    , sum(st.BACKORDER_QUANTITY) as BACKORDER_QUANTITY
    , st.IS_DIA
from
    {{ ref('int_mp_styles_joined_with_colors') }} as st
    join {{ ref('int_sfra_products_join_active_sfra_categories') }} as sfp on sfp.PRODUCT_ID = to_varchar(st.PRODUCT_ID)
where
    STYLE_STATUS = 1
    and SIZE_STATUS = 1
    and PRICE_STATUS = 1
    and PRODUCT_STATUS = 1
    and INVENTORY_STATUS = 1
    and COLOR_IMAGE_STATUS = 1
    and IMAGE_TYPE_ID = 5
    and TITLE is not null
group by
    st.PRODUCT_ID
    , st.COLOR_ID
    , st.FULFILLMENT_INDICATOR
    , st.IS_DIA