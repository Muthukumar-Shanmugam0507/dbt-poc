select
    PRODUCTSET_ID as PRODUCT_SET_ID
    , PRODUCT_ID as PRODUCT_ID
    , trim(replace(DISPLAY_NAME, chr(0), '')) as DISPLAY_NAME
    , nullif(trim(replace(LONG_DESCRIPTION, chr(0), '')), '') as LONG_DESCRIPTION
    , URL as URL
    , nullif(trim(BRAND), '') as BRAND
    , nullif(trim(replace(CLASSIFICATION_CATEGORY, chr(0), '')), '') as CLASSIFICATION_CATEGORY
    , nullif(trim(replace(PRIMARY_CATEGORY, chr(0), '')), '') as PRIMARY_CATEGORY
    , nullif(trim(replace(MANUFACTURER, chr(0), '')), '') as MANUFACTURER
    , nullif(trim(replace(LIST_PRICE, 'N/A', '')), '') as LIST_PRICE
    , nullif(trim(replace(SALE_PRICE, 'N/A', '')), '') as SALE_PRICE
    , trim(SITEID) as SITE_ID
    , to_boolean(ONLINE_FLAG) as ONLINE_FLAG
    , to_boolean(AVAILABLE_FLAG) as AVAILABLE_FLAG
    , to_boolean(SEARCHABLE_FLAG) as SEARCHABLE_FLAG
    , date(DATECREATED) as CREATED_AT
from
    {{source('FBB_PRODUCTS', 'SFRA_PRODUCTSET')}}
