with cte_color_sort_rankings as (
    {{ get_color_sort_rankings(is_mp=true) }}
)
select
    BRAND_ID
    , BRAND_CODE
    , ast.PRODUCT_ID
    , MF_MASTER_ITEM_ID
    , ast.MF_ITEM_ID
    , ast.STYLE_ID
    , ast.MF_STYLE_ID
    , ast.COLOR_ID
    , ast.COLOR
    , st.COLOR_MAP as COLOR_GROUP
    , ast.SIZE_ID
    , ast.MF_SIZE_ID
    , SIZE_SEQUENCE
    , ast.SELLING_DEPARTMENT
    , to_decimal(WAS_PRICE, 10, 2) as WAS_PRICE
    , to_decimal(SELLING_PRICE, 10, 2) as SELLING_PRICE
    , QUANTITY
    , BACKORDER_QUANTITY
    , coalesce(LARGE_IMAGE_URL, SFCC_LARGE_IMAGE_URL) as LARGE_IMAGE
    , ( {{ get_mp_style_thumb_image('ast.SIZE_ID') }} ) || '?colorid=' || st.COLOR_ID as THUMBNAIL_IMAGE
    , THUMBNAIL_IMAGE as THUMBNAIL_IMAGE_URL
    , ( {{ get_color_swatch_image('ast.SIZE_ID', 'ast.BRAND_CODE', 'True') }} ) as SWATCH_IMAGE
    , msz.MILES_DISPLAY_SIZE
    , msz.SIZE_FAMILY
    , msz.SHOE_SIZE
    , msz.SHOE_WIDTH
    , msz.BACKORDER_INDICATOR
    , msz.CLEARANCE_INDICATOR
    , msz.IS_FINAL_SALE
    , csr.COLOR_SORT_ORDER
    , csr.LOWEST_COLOR_SORT
from
    {{ ref('mp_active_styles') }} as ast
    join {{ ref('stg_land__mp_styles') }} as st on ast.STYLE_ID = st.STYLE_ID
    left join {{ref('int_mp_miles_sizes')}} as msz on ast.SIZE_ID = msz.SIZE_ID
    left join {{ ref('int_mp_product_thumb_image') }} as pmi on to_varchar(ast.PRODUCT_ID) = left(pmi.SFCC_PRODUCT_ID, 7)
    join cte_color_sort_rankings as csr on ast.PRODUCT_ID = csr.PRODUCT_ID and ast.COLOR_ID = csr.COLOR_ID
