SELECT
    PRODUCTID as PRODUCT_ID
    , MFMASTERITEMID as MF_MASTER_ITEM_ID
    , BRANDID as BRAND_ID
    , nullif(replace(trim(TITLE), chr(0), ''), '') as TITLE
    , nullif(replace(trim(DESCRIPTION), chr(0), ''), '') as DESCRIPTION
    , to_boolean(ISPURGED) as IS_PURGED
    , "Status" as STATUS
    , MFSELLINGDEPTID as MF_DEPARTMENT
    , CLASSIFICATIONID as CLASSIFICATION_ID
    , nullif(replace(trim(PCMTITLE), chr(0), ''), '') as PCM_TITLE
    , nullif(replace(trim(MFTITLE), chr(0), ''), '') as MF_TITLE
    , nullif(replace(trim(MSSHORTNAME), chr(0), ''), '') as MS_SHORT_NAME
    , nullif(replace(trim(MSLONGNAME), chr(0), ''), '') as MS_LONG_NAME
    , nullif(replace(trim(MSDESCRIPTION), chr(0), ''), '') as MS_DESCRIPTION
    , nullif(replace(trim(PCMDESCRIPTION), chr(0), ''), '') as PCM_DESCRIPTION
    , VENDORID as VENDOR_ID
    , nullif(replace(trim(VENDORNAME), chr(0), ''), '') as VENDOR_NAME
    , nullif(replace(trim(PRIVATELABEL), chr(0), ''), '') as PRIVATE_LABEL
    , nullif(replace(trim(NATIONALBRAND), chr(0), ''), '') as NATIONAL_BRAND
    , nullif(replace(trim(EXTRAPOSTAGECODE), chr(0), ''), '') as EXTRA_POSTAGE_CODE
    , nullif(replace(trim(TAXCLASS), chr(0), ''), '') as TAX_CLASS
    , FULFILLMENTINDICATOR as FULFILLMENT_INDICATOR
    , PRODUCTTYPE as PRODUCT_TYPE
    , to_boolean(ISMONOGRAMMED) as IS_MONOGRAMMED
    , to_boolean(ISEXPEDITED) as IS_EXPEDITED
    , to_boolean(ISHEMMED) as IS_HEMMED
    , to_boolean(ISINTERNATIONAL) as IS_INTERNATIONAL
    , to_boolean(ISPROMOTIONEXCLUDED) as IS_PROMOTION_EXCLUDED
    , to_boolean(ISGROUNDSHIPPING) as IS_GROUND_SHIPPING
    , to_boolean(ISPOBOXEXCLUDED) as IS_POBOX_EXCLUDED
    , to_boolean(ISFREEEXCHANGE) as IS_FREE_EXCHANGE
    , to_boolean(ISNATIONALBRAND) as IS_NATIONAL_BRAND
    , to_boolean(ISPROP65) as IS_PROP_65
    , nullif(replace(trim(MODIFIEDBY), chr(0), ''), '') as MODIFIED_BY
    , nullif(replace(trim(UPC), chr(0), ''), '') as UPC
    , nullif(replace(trim(PCMBRAND), chr(0), ''), '') as PCM_BRAND
    , nullif(replace(trim(PCMCLASSIFICATIONID), chr(0), ''), '') as PCM_CLASSIFICATION_ID
    , nullif(replace(trim(PCMSEODESCRIPTION), chr(0), ''), '') as PCM_SEO_DESCRIPTION
    , nullif(replace(trim(PCMSEOPAGETITLE), chr(0), ''), '') as PCM_SEO_PAGE_TITLE
    , nullif(replace(trim(PCMSEOKEYWORDS), chr(0), ''), '') as PCM_SEO_KEY_WORDS
    , nullif(replace(trim(FABRICCONTENT), chr(0), ''), '') as FABRIC_CONTENT
    , MFSOURCE as MF_SOURCE
    , nullif(replace(trim(GOOGLEPRODUCTCATEGORY), chr(0), ''), '') as GOOGLE_PRODUCT_CATEGORY
    , nullif(replace(trim(MPITEMGROUPID), chr(0), ''), '') as MP_ITEM_GROUP_ID
    , zeroifnull(try_to_decimal(CUSTOMERREVIEWCOUNT)) as CUSTOMER_REVIEW_COUNT
    , zeroifnull(try_to_decimal(CUSTOMERREVIEWAVERAGE, 3, 1)) as CUSTOMER_REVIEW_AVERAGE
    , zeroifnull(try_to_number(FITREVIEWCOUNT)) as FIT_REVIEW_COUNT
    , nullif(replace(trim(FITREVIEWDETAIL), chr(0), ''), '') as FIT_REVIEW_DETAIL
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as UPDATED_AT
    , date(STARTTIME) as START_TIME
    , date(ENDTIME) as END_TIME
    , date(PCMDATECHANGED) as PCM_CHANGED_AT
    , date(MFDATECHANGED) as MF_CHANGED_AT
 FROM
    {{source('MP_PRODUCTS', 'MP_PRODUCT')}}
