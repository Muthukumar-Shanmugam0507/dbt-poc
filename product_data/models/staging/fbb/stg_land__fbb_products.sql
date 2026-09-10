select
     PRODUCTID as PRODUCT_ID
    , MFMASTERITEMID as MF_MASTER_ITEM_ID
    , BRANDID as BRAND_ID
    , MFSELLINGDEPTID as MF_DEPARTMENT
    , nullif(replace(trim(CLASSIFICATIONID), chr(0), ''), '') as CLASSIFICATION_ID
    , nullif(replace(trim(SFCC_CATEGORY_ID), chr(0), ''), '') as SFFC_CATEGORY_ID
    , nullif(regexp_replace(trim(TITLE), '[\u0000\u00A0\u200B\u200C\u200D]', ''), '') as TITLE
    , SFCC_URL as SFCC_URL
    , nullif(replace(trim(MFTITLE), chr(0), ''), '') as MF_TITLE
    , nullif(replace(trim(MSSHORTNAME), chr(0), ''), '') as MS_SHORT_NAME
    , nullif(replace(trim(MSLONGNAME), chr(0), ''), '') as MS_LONG_NAME
    , nullif(regexp_replace(trim(MSDESCRIPTION), '[\u0000\u00A0\u200B\u200C\u200D]', ''), '') as MS_DESCRIPTION
    , nullif(replace(trim(VENDORID), chr(0), ''), '') as VENDOR_ID
    , nullif(replace(trim(VENDORNAME), chr(0), ''), '') as VENDOR_NAME
    , nullif(replace(trim(PRIVATELABEL), chr(0), ''), '') as PRIVATE_LABEL
    , nullif(replace(trim(NATIONALBRAND), chr(0), ''), '') as NATIONAL_BRAND
    , nullif(replace(trim(EXTRAPOSTAGECODE), chr(0), ''), '') as EXTRA_POSTAGE_CODE
    , nullif(replace(trim(TAXCLASS), chr(0), ''), '') as TAX_CLASS
    , try_to_number(FULFILLMENTINDICATOR) as FULFILLMENT_INDICATOR
    , try_to_number(PRODUCTTYPE) as PRODUCT_TYPE
    , to_boolean(trim(ISMONOGRAMMED)) as IS_MONOGRAMMED
    , to_boolean(trim(ISEXPEDITED)) as IS_EXPEDITED
    , to_boolean(trim(ISHEMMED)) as IS_HEMMED
    , to_boolean(trim(ISINTERNATIONAL)) as IS_INTERNATIONAL
    , to_boolean(trim(ISPROMOTIONEXCLUDED)) as IS_PROMOTION_EXCLUDED
    , to_boolean(trim(ISGROUNDSHIPPING)) as IS_GROUND_SHIPPING
    , to_boolean(trim(ISPOBOXEXCLUDED)) as IS_POBOX_EXCLUDED
    , to_boolean(trim((ISFREEEXCHANGE))) as IS_FREE_EXCHANGE
    , to_boolean(trim(ISNATIONALBRAND)) as IS_NATIONAL_BRAND
    , to_boolean(trim(ISPROP65)) as IS_PROP65
    , nullif(replace(trim(UPC), chr(0), ''), '') as UPC
    , nullif(replace(trim(PCMBRAND), chr(0), ''), '') as PCM_BRAND
    , nullif(replace(trim(PCMCLASSIFICATIONID), chr(0), ''), '') as PCM_CLASSIFICATION_ID
    , nullif(replace(trim(PCMSEODESCRIPTION), chr(0), ''), '') as PCM_SEO_DESCRIPTION
    , nullif(replace(trim(PCMSEOPAGETITLE), chr(0), ''), '') as PCM_SEO_PAGE_TITLE
    , nullif(replace(trim(PCMSEOKEYWORDS), chr(0), ''), '') as PCM_SEO_KEYWORDS
    , nullif(replace(trim(FABRICCONTENT), chr(0), ''), '') as FABRIC_CONTENT
    , nullif(replace(trim(DESCRIPTION), chr(0), ''), '') as DESCRIPTION
    , zeroifnull(try_to_decimal(CUSTOMERREVIEWCOUNT)) as CUSTOMER_REVIEW_COUNT
    , zeroifnull(try_to_decimal(CUSTOMERREVIEWAVERAGE, 3, 1)) as CUSTOMER_REVIEW_AVERAGE
    , zeroifnull(try_to_number(FITREVIEWCOUNT)) as FIT_REVIEW_COUNT
    , nullif(replace(trim(FITREVIEWDETAIL), chr(0), ''), '') as FIT_REVIEW_DETAIL
    , to_boolean(trim(ISPURGED)) as IS_PURGED
    , "Status" as STATUS
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as UPDATED_AT
    , date(MFDATECHANGED) as MF_UPDATED_AT
    , date(PCMDATECHANGED) as PCM_UPDATED_AT
    , MODIFIEDBY as MODIFIED_BY
from
    {{source('FBB_PRODUCTS', 'PRODUCT')}}
