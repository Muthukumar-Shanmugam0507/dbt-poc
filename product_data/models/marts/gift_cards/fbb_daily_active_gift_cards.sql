with cte_urls as (
    select
        PRODUCT_ID
        , BRAND_CODE
        , PRODUCT_URL
        , IMAGE_NAME
    from
        {{ref('int_fbb_gift_card_images')}} img
    where
        IMAGE_NAME like '%_mm_%'
)
select
    ap.GIFT_CARD_ID as PRODUCT_ID
    , ap.MF_ITEM_ID
    , ap.BRAND_ID
    , ap.PRODUCT_TYPE_ID
    , ap.TITLE
    , ap.DESCRIPTION
    , ap.BRAND_CODE
    , ap.BRAND_NAME
    , url.PRODUCT_URL
    , url.PRODUCT_URL as IMAGE_URL
    , ( {{ get_active_gift_cards_key() }} ) as HASH_KEY
from
    {{ ref('int_fbb_active_gift_cards') }} as ap
    left join cte_urls as url on ap.GIFT_CARD_ID = url.PRODUCT_ID and ap.BRAND_CODE = url.BRAND_CODE