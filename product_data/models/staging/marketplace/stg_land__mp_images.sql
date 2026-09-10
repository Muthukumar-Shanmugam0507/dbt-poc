select
    IMAGEID as IMAGE_ID
    , BRANDID as BRAND_ID
    , MFDEPTID as MF_DEPT_ID
    , MFITEMID as MF_ITEM_ID
    , MFSTYLENO as MF_STYLE_NO
    , SEQUENCE as SEQUENCE
    , nullif(replace(trim(IMAGENAME), chr(0), ''), '') as IMAGE_NAME
    , IMAGETYPEID as IMAGE_TYPE_ID
    , nullif(replace(trim(IMAGECODE), chr(0), ''), '') as IMAGE_CODE
    , nullif(replace(trim(IMAGEURL), chr(0), ''), '') as IMAGE_URL
    , nullif(replace(trim(MPIMAGEURL), chr(0), ''), '') as MP_IMAGE_URL
    , nullif(replace(trim(MFVENDORID), chr(0), ''), '') as MF_VENDOR_ID
    , nullif(replace(trim(MPITEMGROUPID), chr(0), ''), '') as MP_ITEM_GROUP_ID
    , STATUS as STATUS
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as UPDATED_AT
    , MODIFIEDBY as MODIFIED_BY
from 
    {{source('MP_PRODUCTS', 'MP_IMAGE')}}