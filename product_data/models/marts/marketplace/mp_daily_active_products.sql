select
    ap.BRAND_ID
    , ap.BRAND_CODE
    , ap.PRODUCT_ID
    , ap.MF_MASTER_ITEM_ID
    , ap.TITLE
    , ap.MS_DESCRIPTION
    , ap.PCM_BRAND
    , ap.MP_VENDOR_ID
    , ap.IS_DIA
    , ap.PCM_SEO_DESCRIPTION
    , ap.CUSTOMER_REVIEW_COUNT
    , ap.CUSTOMER_REVIEW_AVERAGE
    , ap.IMAGE_URL
    , ap.GENDER
    , ( {{ get_mp_product_url('ap.PRODUCT_ID', 'ap.BRAND_CODE') }} ) as PRODUCT_URL
    , tx.DIVISION
    , tx.CATEGORY
    , tx.SUBCATEGORY
    , ({{ get_mp_active_products_key() }}) as HASH_KEY
from
    {{ ref('int_mp_active_products') }} as ap
    left join {{ ref('int_ds_product_taxonomy') }} as tx on tx.PRODUCT_ID = ap.PRODUCT_ID
