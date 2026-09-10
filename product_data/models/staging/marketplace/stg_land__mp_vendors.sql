select
    trim(VENDORGROUP) as VENDOR_GROUP
    , lpad(trim(MPVENDORID), 6, '0') as MP_VENDOR_ID
    , trim(MFVENDORID) as MF_VENDOR_ID
    , nullif(replace(trim(VENDORNAME), chr(0), ''), '') as VENDOR_NAME
    , to_boolean(ENABLEDSTAGING) as ENABLED_STAGING
    , to_boolean(ENABLEDPRODUCTION) as ENABLED_PRODUCTION
    , STATUS as STATUS
    , nullif(replace(trim(BADGENAME), chr(0), ''), '') as BADGE_NAME
    , BADGESTATUS as BADGE_STATUS
    , nullif(replace(trim(ORIGINADDRESS), chr(0), ''), '') as ORIGIN_ADDRESS
    , nullif(replace(trim(ORIGINADDRESS2), chr(0), ''), '') as ORIGIN_ADDRESS_2
    , nullif(replace(trim(ORIGINCITY), chr(0), ''), '') as ORIGIN_CITY
    , nullif(replace(trim(ORIGINSTATE), chr(0), ''), '') as ORIGIN_STATE
    , ORIGINZIP as ORIGIN_ZIP
    , ORIGINZIPPLUS4 as ORIGIN_ZIP_PLUS_4
    , nullif(replace(trim(COMMISSIONRATE), chr(0), ''), '') as COMMISSION_RATE
    , to_boolean(ISFLTAX) as IS_FL_TAX
    , to_boolean(ISKSTAX) as IS_KS_TAX
    , to_boolean(ISMOTAX) as IS_MO_TAX
    , date(DATECREATED) as CREATED_AT
    , date(LASTINVENTORYUPDATE) as INVENTORY_UPDATED_AT
    , date(BADGEDATESTART) as BADGE_STARTED_AT
    , date(BADGEDATESTOP) as BADGE_STOPPED_AT
from
    {{source('MP_PRODUCTS', 'MP_VENDOR')}}