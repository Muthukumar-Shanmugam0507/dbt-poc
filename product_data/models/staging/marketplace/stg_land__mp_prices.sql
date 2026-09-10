select
    PRICEID as PRICE_ID
    , SIZEID as SIZE_ID
    , nullif(replace(trim(MEDIAKEY), chr(0), ''), '') as MEDIA_KEY
    , BRANDID as BRAND_ID
    , nullif(replace(trim(SELLINGPRICE), chr(0), ''), '') as SELLING_PRICE
    , STATUS as STATUS
    , date(SELLINGPRICESTARTDATE) as SELLING_PRICE_START_DATE
    , date(SELLINGPRICEENDDATE) as SELLING_PRICE_END_DATE
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as CHANGED_AT
    , date(MFDATECHANGED) as MF_CHANGED_AT
    , date(DATEPUBLISHED) as PUBLISHED_AT
    , nullif(replace(trim(MODIFIEDBY), chr(0), ''), '') as MODIFIED_AT
    , RETRYCOUNT as RETRY_COUNT 
from  
     {{source('MP_PRODUCTS', 'MP_PRICE')}}