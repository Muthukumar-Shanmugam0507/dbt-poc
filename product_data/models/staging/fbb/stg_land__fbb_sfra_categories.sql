select
    nullif(replace(trim(CATEGORY_ID), chr(0), ''), '') as CATEGORY_ID
     , nullif(replace(trim(PARENT), chr(0), ''), '') as PARENT
     , to_boolean(trim(ONLINE_FLAG)) as ONLINE_FLAG
     , nullif(replace(trim(BRAND_ID), chr(0), ''), '') as BRAND_ID
     , nullif(replace(trim(SITE_ID), chr(0), ''), '') as SITE_ID
     , nullif(replace(replace(trim(DISPLAY_NAME), chr(0), ''), '?', ''), '') as DISPLAY_NAME
     , POSITION as POSITION
     , ONLINE_FROM
     , ONLINE_TO
     , to_boolean(ISHIDDEN) as IS_HIDDEN
     , to_boolean(ISDELTA) as IS_DELTA
     , to_boolean(ISCLEARANCE) as IS_CLEARANCE
     , to_boolean(HIDEMASTERPRODUCTINSLICING) as HIDE_MASTER_PRODUCT_IN_SLICING
     , to_boolean(ISRETAINBRORCLPRODUCT) as IS_RETAIN_BR_OR_CL_PRODUCT
     , date(DATECREATED) as CREATED_AT
from
    {{ source('FBB_PRODUCTS', 'SFRA_CATEGORY') }}