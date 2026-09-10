select
    SIZEID as SIZE_ID
    , STYLEID as STYLE_ID
    , trim(MFSIZEID) as MF_SIZE_ID
    , trim(DISPLAYSIZE) as DISPLAY_SIZE
    , trim(OFFEREDSIZE) as OFFERED_SIZE
    , STATUS as STATUS
    , SIZESEQUENCE as SIZE_SEQUENCE
    , try_to_decimal(WASPRICE,30,  4) as WAS_PRICE
    , WEIGHT as WEIGHT
    , WEIGHTUNIT as WEIGHT_UNIT
    , trim(UPC) as UPC
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as UPDATED_AT
    , date(MFDATECHANGED) as MF_UPDATED_AT
    , date(STARTTIME) as START_TIME
    , date(ENDTIME) as END_TIME
    , MODIFIEDBY as MODIFIED_BY
from
    {{source('FBB_PRODUCTS', 'SIZE')}}