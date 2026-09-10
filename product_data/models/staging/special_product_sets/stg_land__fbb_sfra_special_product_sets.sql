select
    PRODUCTSET_ID as SPECIAL_PRODUCT_SET_ID
    , DISPLAY_NAME as DISPLAY_NAME
    , nullif(trim(replace(LONG_DESCRIPTION, chr(0), '')), '') as LONG_DESCRIPTION
    , URL as URL
    , nullif(trim(replace(CLASSIFICATION_CATEGORY, chr(0), '')), '') as CLASSIFICATION_CATEGORY
    , nullif(trim(replace(PRIMARY_CATEGORY, chr(0), '')), '') as PRIMARY_CATEGORY
    , IMAGE_PATH as IMAGE_PATH
    , to_boolean(IS_SPECIALPRODUCTSET) AS IS_SPECIAL_PRODUCT_SET
    , nullif(trim(replace(UBERSET_ID, chr(0), '')), '') as UBERSET_ID
    , nullif(trim(replace(LIST_PRICE, 'N/A', '')), '') as LIST_PRICE
    , nullif(trim(replace(SALE_PRICE, 'N/A', '')), '') as SALE_PRICE
    , VARIATIONGROUP as VARIATION_GROUP
    , PRODUCT_ID as PRODUCT_ID
    , COLOR_ID as COLOR_ID
    , ROW_ID as ROW_ID
    , to_boolean(ONLINE_FLAG) as ONLINE_FLAG
    , to_boolean(AVAILABLE_FLAG) as AVAILABLE_FLAG
    , to_boolean(SEARCHABLE_FLAG) as SEARCHABLE_FLAG
    , date(DATECREATED) as CREATED_AT
from
    {{source('FBB_PRODUCTS', 'SFRA_SPECIALPRODUCTSET')}}
