select
    st.BRAND_ID
    , st.BRAND_CODE
    , st.PRODUCT_ID
    , st.COLOR_ID
    , st.COLOR
    , st.VARIATION_ID
    , st.TITLE
    , st.MS_DESCRIPTION
    , st.PCM_SEO_DESCRIPTION
    , st.PCM_BRAND
    , st.PRODUCT_URL
    , st.IMAGE_URL
    , st.LAYDOWN_IMAGE_URL
    , ali.ALT_IMAGES
from
    {{ref('int_mp_active_variations_joined_with_laydowns')}} as st
    left join {{ref('int_mp_alt_images')}} as ali on ali.PRODUCT_ID = st.PRODUCT_ID