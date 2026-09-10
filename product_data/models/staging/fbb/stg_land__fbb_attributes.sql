select
    ATTRIBUTEID as ATTRIBUTE_ID
     , nullif(replace(trim(ATTRIBUTENAME), chr(0), ''), '') as ATTRIBUTE_NAME
     , nullif(replace(trim(BLOOMREACHATTRIBUTENAME), chr(0), ''), '') as BLOOMREACH_ATTRIBUTE_NAME
     , ATTRIBUTEGROUPID as ATTRIBUTE_GROUPID
     , date(DATECREATED) AS CREATED_AT
     , date(DATECHANGED) AS UPDATED_AT
     , STATUS as STATUS
from
    {{source('FBB_PRODUCTS', 'ATTRIBUTE')}}
