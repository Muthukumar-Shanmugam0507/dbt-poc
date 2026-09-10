select
    distinct
    st.BRAND_ID
    , st.BRAND_CODE
    , st.PRODUCT_ID
    , st.COLOR_ID
    , st.COLOR
    , st.PRODUCT_ID || '_'  || st.COLOR_ID as VARIATION_ID
    , st.TITLE
    , st.MS_DESCRIPTION
    , st.PCM_SEO_DESCRIPTION
    , st.PCM_BRAND
    , st.PRODUCT_URL
    , st.IMAGE_URL
    , ld.IMAGE_URL as LAYDOWN_IMAGE_URL
from
    {{ref('int_fbb_styles_joined_with_colors')}} as st
    join {{ref('int_sfra_products_join_active_sfra_categories')}} as sfp on sfp.PRODUCT_ID = to_varchar(st.PRODUCT_ID)
    left join {{ref('stg_laydown__images')}} as ld on st.PRODUCT_ID = ld.PRODUCT_ID and st.COLOR_ID = ld.COLOR_ID
where
    STYLE_STATUS = 1
    and SIZE_STATUS = 1
    and PRICE_STATUS = 1
    and PRODUCT_STATUS = 1
    and INVENTORY_STATUS = 1
    and COLOR_IMAGE_STATUS = 1
    and IMAGE_TYPE_ID = 5
    and TITLE is not null
    and QUANTITY + BACKORDER_QUANTITY > 0