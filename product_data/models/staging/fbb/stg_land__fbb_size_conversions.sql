select
    trim(MFSIZEID) as MF_SIZE_ID
    , trim(MFDISPLAYSIZE) as MF_DISPLAY_SIZE
    , nullif(trim(replace(DISPLAYSIZE, chr(0), '')), '') as DISPLAY_SIZE
    , nullif(trim(replace(SPLITSIZE1, chr(0), '')), '') as SPLIT_SIZE_1
    , nullif(trim(replace(SPLITSIZE2, chr(0), '')), '') as SPLIT_SIZE_2
    , SIZESEQUENCE as SIZE_SEQUENCE
    , SIZESEQUENCE2 as SIZE_SEQUENCE_2
    , BRANDID as BRAND_ID
    , GROUPID as GROUP_ID
    , nullif(trim(replace(DATECREATED, chr(0), '')), '') as CREATED_AT
    , date(DATECHANGED) as UPDATED_AT
from
    {{ source('FBB_PRODUCTS', 'SIZECONVERSION') }}
