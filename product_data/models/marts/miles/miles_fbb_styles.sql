select
    BRAND_ID
    , BRAND_CODE
    , st.PRODUCT_ID
    , MF_MASTER_ITEM_ID
    , st.MF_ITEM_ID
    , st.STYLE_ID
    , st.MF_STYLE_ID
    , st.STYLE_TYPE
    , st.COLOR_ID
    , st.COLOR
    , st.SIZE_ID
    , st.MF_SIZE_ID
    , SIZE_SEQUENCE
    , st.SELLING_DEPARTMENT
    , to_decimal(WAS_PRICE, 10, 2) as WAS_PRICE
    , to_decimal(SELLING_PRICE, 10, 2) as SELLING_PRICE
    , QUANTITY
    , BACKORDER_QUANTITY
    , msz.SIZE_FAMILY
    , msz.MILES_DISPLAY_SIZE
    , msz.SHOE_SIZE
    , msz.SHOE_WIDTH
    , msz.BRA_CUP_SIZE
    , msz.BRA_BAND_SIZE
    , msz.BRA_SIZE
    , msz.BACKORDER_INDICATOR
    , msz.CLEARANCE_INDICATOR
    , msz.IS_FINAL_SALE
    , mst.COLOR_GROUP
    , mst.COLOR_SORT_ORDER
    , mst.COLOR_SORT_DEFAULT_SKU
    , mst.VARIANT_ON_HOVER_IMAGE
    , ( {{ get_style_thumb_image('st.SIZE_ID', 'st.BRAND_CODE') }} ) as THUMB_IMAGE
    , THUMB_IMAGE || '?colorid=' || st.COLOR_ID as THUMB_IMAGE_COLOR_ID
    , ( {{ get_color_swatch_image('st.SIZE_ID', 'st.BRAND_CODE') }} ) as SWATCH_IMAGE
    , mst.DEFAULT_SKU
    , mst.MAIN_COLOR_ID
    , mst.MAIN_IMAGE_URL
    , mst.SFCC_MAIN_IMAGE_URL
from
    {{ ref('fbb_active_styles') }} as st
    left join {{ ref('int_fbb_miles_sizes') }} as msz on st.SIZE_ID = msz.SIZE_ID
    left join {{ ref('int_fbb_miles_styles') }} as mst on st.PRODUCT_ID = mst.PRODUCT_ID and st.COLOR_ID = mst.COLOR_ID and st.SIZE_ID = mst.SIZE_ID
