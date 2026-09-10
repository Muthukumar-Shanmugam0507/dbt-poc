select
    STYLEID as STYLE_ID
    , PRODUCTID as PRODUCT_ID
    , MFITEMID as MF_ITEM_ID
    , MFSTYLEID as MF_STYLE_ID
    , to_boolean(ISPURGED) as IS_PURGED
    , nullif(replace(trim(CLEARANCEINDICATOR), chr(0), ''), '') CLEARANCE_INDICATOR
    , nullif(trim(SELLINGDEPT), '') as SELLING_DEPARTMENT
    , COLORID as COLOR_ID
    , nullif(replace(trim(upper(COLOR)), chr(0), ''), '') as COLOR
    , nullif(replace(trim(PANTONE), chr(0), ''), '') as PANTONE
    , to_boolean(ISPRINT) as IS_PRINT
    , nullif(replace(trim(STYLETYPE), chr(0), ''), '') STYLE_TYPE
    , STATUS as STATUS
    , nullif(replace(trim(STANDARDCOST), chr(0), ''), '') as STANDARD_COST
    , nullif(replace(trim(GENDER), chr(0), ''), '') as GENDER
    , nullif(replace(trim(KNITWOVEN), chr(0), ''), '') as KNIT_WOVEN
    , nullif(replace(trim(HTS), chr(0), ''), '') as HTS
    , nullif(replace(trim(COUNTRYOFORIGIN), chr(0), ''), '') as COUNTRY_OF_ORIGIN
    , MFSOURCE as MF_SOURCE
    , to_boolean(ISFINALSALE) as IS_FINAL_SALE
    , nullif(replace(trim(COLORMAP), chr(0), ''), '') as COLOR_MAP
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as CHANGED_AT
    , date(MFDATECHANGED) as MF_CHANGED_AT
    , date(STARTTIME) as START_TIME
    , date(ENDTIME) as END_TIME
    , nullif(replace(trim(MODIFIEDBY), chr(0), ''), '') as MODIFIED_BY
from
    {{source('MP_PRODUCTS', 'MP_STYLE')}}