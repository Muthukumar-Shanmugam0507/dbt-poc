select
    BRAND_ID
    , BRAND_CODE
    , st.PRODUCT_ID
    , MF_MASTER_ITEM_ID
    , MF_ITEM_ID
    , TITLE
    , STYLE_ID
    , MF_STYLE_ID
    , STYLE_TYPE
    , COLOR_ID
    , COLOR
    , IS_PRINT
    , SIZE_ID
    , MF_SIZE_ID
    , DISPLAY_SIZE
    , OFFERED_SIZE
    , SIZE_SEQUENCE
    , WAS_PRICE
    , SELLING_DEPARTMENT
    , MEDIA_KEY
    , SELLING_PRICE
    , SELLING_PRICE_START_DATE
    , SELLING_PRICE_END_DATE
    , IMAGE_URL
    , PRODUCT_URL
    , QUANTITY
    , BACKORDER_QUANTITY
    , ( {{ get_mp_active_styles_key() }} ) as HASH_KEY
from
    {{ ref('int_mp_styles_joined_with_colors') }} as st
    join {{ref('int_sfra_products_join_active_sfra_categories')}} as sfp on sfp.PRODUCT_ID = to_varchar(st.PRODUCT_ID)
where
    STYLE_STATUS = 1
    and SIZE_STATUS = 1
    and PRICE_STATUS = 1
    and PRODUCT_STATUS = 1
    and INVENTORY_STATUS = 1
    and COLOR_IMAGE_STATUS = 1
    and IMAGE_TYPE_ID = 5
    and VENDOR_STATUS = 1
    and ENABLED_PRODUCTION = 1
    and TITLE is not null
    and QUANTITY + BACKORDER_QUANTITY > 0
