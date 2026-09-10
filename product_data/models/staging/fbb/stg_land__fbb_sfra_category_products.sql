select
    nullif(trim(CATEGORY_ID), '') as CATEGORY_ID
    , nullif(trim(SFCC_PRODUCT_ID), '') as SFCC_PRODUCT_ID
    , nullif(trim(PRIMARY_CATEGORY), '') as PRIMARY_CATEGORY
    , nullif(trim(SITE_ID), '') as SITE_ID
    , nullif(trim(PRODUCT_ID), '') as PRODUCT_ID
    , to_boolean(ISDELTA) as IS_DELTA
    , nullif(trim(PRODUCT_URL), '') PRODUCT_URL
    , date(DATECREATED) as CREATED_AT
from
    {{ source('FBB_PRODUCTS', 'SFRA_CATEGORY_PRODUCT') }}