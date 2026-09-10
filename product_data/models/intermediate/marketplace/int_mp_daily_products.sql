select
    ap.BRAND_ID
    , ap.BRAND_CODE
    , ap.PRODUCT_ID
    , ap.MF_MASTER_ITEM_ID
    , ap.TITLE
    , ap.MS_DESCRIPTION
    , ap.PCM_BRAND
    , ap.PCM_SEO_DESCRIPTION
    , ap.CUSTOMER_REVIEW_COUNT
    , ap.CUSTOMER_REVIEW_AVERAGE
    , any_value(ap.IMAGE_URL) as IMAGE_URL
from
    {{ ref('int_mp_styles_joined_with_colors') }} as ap
group by
    BRAND_ID
    , BRAND_CODE
    , ap.PRODUCT_ID
    , MF_MASTER_ITEM_ID
    , TITLE
    , MS_DESCRIPTION
    , PCM_BRAND
    , PCM_SEO_DESCRIPTION
    , CUSTOMER_REVIEW_COUNT
    , CUSTOMER_REVIEW_AVERAGE
