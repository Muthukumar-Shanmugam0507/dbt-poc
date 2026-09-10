select
    nullif(replace(trim(SFCC_PRODUCT_ID), chr(0), ''), '') as SFCC_PRODUCT_ID
    , nullif(replace(trim(VIEW_TYPE), chr(0), ''), '') as VIEW_TYPE
    , nullif(replace(trim(VARIATION_VALUE), chr(0), ''), '') as VARIATION_VALUE
    , nullif(replace(trim(IMAGE_PATH), chr(0), ''), '') as IMAGE_PATH
    , nullif(replace(trim(PRODUCTID), chr(0), ''), '') as PRODUCT_ID
    , nullif(replace(trim(SITEID), chr(0), ''), '') as SITE_ID
    , nullif(replace(trim(CLEARANCEINDICATOR), chr(0), ''), '') as CLEARANCE_INDICATOR
    , nullif(replace(trim(IMAGE_NAME), chr(0), ''), '') as IMAGE_NAME
    , nullif(replace(trim(IMAGE_CODE), chr(0), ''), '') as IMAGE_CODE
    , to_boolean(ISFINALSALE) as IS_FINAL_SALE
    , date(DATECREATED) as CREATED_AT
from
    {{ source('FBB_PRODUCTS', 'SFRA_IMAGES') }}
