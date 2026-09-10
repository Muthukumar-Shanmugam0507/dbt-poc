select
    SFCC_PRODUCT_ID as SFCC_PRODUCT_ID
    , PRODUCTID::VARCHAR as PRODUCT_ID
    , nullif(replace(trim(BRAND), chr(0), ''), '') as BRAND
    , nullif(replace(trim(DISPLAY_NAME), chr(0), ''), '') as DISPLAY_NAME
    , nullif(replace(trim(DESCRIPTION), chr(0), ''), '') as DESCRIPTION
    , nullif(replace(trim(URL), chr(0), ''), '') as URL
    , nullif(replace(trim(SITEID), chr(0), ''), '') as SITE_ID
    , nullif(replace(trim(CLASSIFICATION_CATEGORY), chr(0), ''), '') as CLASSIFICATION_CATEGORY
    , nullif(replace(trim(PRIMARY_CATEGORY), chr(0), ''), '') as PRIMARY_CATEGORY
    , nullif(replace(trim(MANUFACTURER), chr(0), ''), '') as MANUFACTURER
    , BROWSECOUNT as BROWSE_COUNT
    , CLEARANCECOUNT as CLEARANCE_COUNT
    , FINALSALECOUNT as FINAL_SALE_COUNT
    , date(DATECREATED) as DATE_CREATED
    , HASH(*) as HASH_KEY
from
    {{source('FBB_PRODUCTS', 'SFRA_PRODUCT')}}