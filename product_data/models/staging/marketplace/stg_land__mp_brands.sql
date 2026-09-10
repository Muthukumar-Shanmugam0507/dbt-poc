SELECT
    BRANDID as BRAND_ID
    , nullif(replace(trim(BRANDCODE), chr(0), ''), '') as BRAND_CODE
    , nullif(replace(trim(BRANDNAME), chr(0), ''), '') as BRAND_NAME
    , to_boolean(PCMENABLED) AS PCM_ENABLED
    , to_boolean(SFCCENABLED) AS SFCC_ENABLED
    , nullif(replace(trim(MILENNAIMAGEURL), chr(0), ''), '') as MILENNA_IMAGE_URL
    , nullif(replace(trim(SFCCSITEID), chr(0), ''), '') as SFCC_SITE_ID
    , nullif(replace(trim(SFCCMASTERCATALOG), chr(0), ''), '') as SFCC_MASTER_CATALOG
    , nullif(replace(trim(SFCCSITEURL), chr(0), ''), '') as SFCC_SITE_URL
    , nullif(replace(trim(SFCCSITECATALOG), chr(0), ''), '') as SFCC_SITE_CATALOG
    , nullif(replace(trim(SFCCDEFAULTCLEARANCECATEGORY), chr(0), ''), '') as SFCC_DEFAULT_CLEARANCE_CATEGORY
    , nullif(replace(trim(SFCCDEFAULTFINALSALECATEGORY), chr(0), ''), '') as SFCC_DEFAULT_FINAL_SALE_CATEGORY
    , nullif(replace(trim(IMAGEDOMAIN), chr(0), ''), '') as IMAGE_DOMAIN
FROM
    {{source('MP_PRODUCTS', 'MP_BRAND')}}