with cte_kobe_fbb_daily_variants as ( {{ get_daily_variants('mp') }} )
select
    BRAND_CODE
    , PRODUCT_ID
    , COLOR_ID
    , VARIANT_ID
    , COLOR_NAME
    , TITLE
    , DESCRIPTION
    , IMAGE_URL
    , PRODUCT_URL
    , IS_LIVE
    , HAS_INVENTORY
    , ( {{get_kobe_variants_key()}} ) as HASH_KEY
from
    cte_kobe_fbb_daily_variants