select
    PRODUCTID as PRODUCT_ID
    , MFITEMID as MF_ITEM_ID
    , STYLEID as STYLE_ID
    , MFSTYLEID as MF_STYLE_ID
    , nullif(trim(STYLETYPE), '') as STYLE_TYPE
    , COLORID as COLOR_ID
    , nullif(trim(COLOR), '') as COLOR
    , nullif(trim(SELLINGDEPT), '') as SELLING_DEPARTMENT
    , STATUS as STATUS
    , to_boolean(trim(ISPURGED)) as IS_PURGED
    , to_boolean(trim(ISPRINT)) as IS_PRINT
    , to_boolean(trim(ISFINALSALE)) as IS_FINAL_SALE
    , nullif(trim(CLEARANCEINDICATOR), '') as CLEARANCE_INDICATOR
    , nullif(trim(replace(GENDER, chr(0), '')), '') as GENDER
    , nullif(trim(replace(KNITWOVEN, chr(0), '')), '') as KNITWOVEN
    , nullif(trim(replace(PANTONE, chr(0), '')), '') as PANTONE
    , nullif(trim(replace(HTS, chr(0), '')), '') as HTS
    , nullif(trim(replace(COUNTRYOFORIGIN, chr(0), '')), '') as COUNTRY_OF_ORIGIN
    , try_to_decimal(STANDARDCOST, 30,  4) as STANDARD_COST
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as UPDATED_AT
    , date(MFDATECHANGED) as MF_UPDATED_AT
    , date(STARTTIME) as START_TIME
    , date(ENDTIME) as END_TIME
    , MODIFIEDBY as MODIFIED_BY
from
    {{source('FBB_PRODUCTS', 'STYLE')}}