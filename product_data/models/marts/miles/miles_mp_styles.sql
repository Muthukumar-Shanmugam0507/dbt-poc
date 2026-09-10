select
    mst.BRAND_ID
    , mst.BRAND_CODE
    , mst.PRODUCT_ID
    , mst.MF_MASTER_ITEM_ID
    , mst.MF_ITEM_ID
    , mst.STYLE_ID
    , mst.MF_STYLE_ID
    , mst.COLOR_ID
    , mst.COLOR
    , mst.COLOR_GROUP
    , mst.SIZE_ID
    , mst.MF_SIZE_ID
    , mst.SIZE_SEQUENCE
    , mst.SELLING_DEPARTMENT
    , mst.WAS_PRICE
    , mst.SELLING_PRICE
    , mst.QUANTITY
    , mst.BACKORDER_QUANTITY
    , mst.LARGE_IMAGE
    , mst.THUMBNAIL_IMAGE
    , mst.THUMBNAIL_IMAGE_URL
    , mst.SWATCH_IMAGE
    , mst.MILES_DISPLAY_SIZE
    , mst.SIZE_FAMILY
    , mst.SHOE_SIZE
    , mst.SHOE_WIDTH
    , mst.BACKORDER_INDICATOR
    , mst.CLEARANCE_INDICATOR
    , mst.IS_FINAL_SALE
    , mst.COLOR_SORT_ORDER
    , mst.LOWEST_COLOR_SORT
from
    {{ ref('int_miles_mp_styles') }} as mst
