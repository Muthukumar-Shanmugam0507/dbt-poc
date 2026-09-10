select
    BRAND_ID
    , BRAND_CODE
    , st.PRODUCT_ID
    , MF_MASTER_ITEM_ID
    , TITLE
    , MS_DESCRIPTION
    , PCM_BRAND
    , PCM_SEO_DESCRIPTION
    , CUSTOMER_REVIEW_COUNT
    , CUSTOMER_REVIEW_AVERAGE
    , any_value(IMAGE_URL) as IMAGE_URL
    , MP_VENDOR_ID
    , IS_DIA
    , GENDER
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
group by
    BRAND_ID
    , BRAND_CODE
    , st.PRODUCT_ID
    , MF_MASTER_ITEM_ID
    , TITLE
    , MS_DESCRIPTION
    , PCM_BRAND
    , MP_VENDOR_ID
    , IS_DIA
    , GENDER
    , PCM_SEO_DESCRIPTION
    , CUSTOMER_REVIEW_COUNT
    , CUSTOMER_REVIEW_AVERAGE
