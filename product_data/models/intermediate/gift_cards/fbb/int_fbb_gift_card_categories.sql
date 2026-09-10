select
    to_varchar(acp.PRODUCT_ID) as PRODUCT_ID
    , awc.BRAND_ID
    , ( {{ get_gift_card_url('acp.PRODUCT_ID', 'awc.BRAND_ID') }} ) as PRODUCT_URL
    , awc.CATEGORY_ID
    , DISPLAY_NAME as CATEGORY_NAME
    , PARENT_CATEGORIES
from
    {{ ref('int_active_categories_joined_with_category_products') }} as awc
    join {{ ref('fbb_active_gift_cards') }} as acp on awc.PRODUCT_ID = acp.PRODUCT_ID
where
    coalesce(HIDE_MASTER_PRODUCT_IN_SLICING, 0) = 0
    or (
        coalesce(HIDE_MASTER_PRODUCT_IN_SLICING, 0) = 1
        and not exists(
            select
                1
            from
                {{ ref('int_fbb_product_slices_categories') }} as psc
            where
                awc.CATEGORY_ID = psc.CATEGORY_ID and acp.PRODUCT_ID = psc.PRODUCT_ID
        )
    )