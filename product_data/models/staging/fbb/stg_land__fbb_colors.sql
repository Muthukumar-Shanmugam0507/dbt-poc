select
    PRODUCTID as PRODUCT_ID
    , trim(COLORID) as COLOR_ID
    , trim(COLOR) as COLOR
    , STATUS as STATUS
    , nullif(trim(replace(PANTONE, chr(0), '')), '') as PANTONE
    , to_boolean(trim(ISPRINT)) as IS_PRINT
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as UPDATED_AT
    , MODIFIEDBY as MODIFIED_BY
from
     {{source('FBB_PRODUCTS', 'COLOR')}}