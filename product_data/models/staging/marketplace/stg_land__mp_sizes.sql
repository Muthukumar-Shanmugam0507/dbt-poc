select
    SIZEID AS SIZE_ID
    , STYLEID AS STYLE_ID
    , nullif(replace(trim(upper(MFSIZEID)), chr(0), ''), '') as MF_SIZE_ID
    , nullif(replace(trim(DISPLAYSIZE), chr(0), ''), '') as DISPLAY_SIZE
    , SIZESEQUENCE AS SIZE_SEQUENCE
    , try_to_decimal(WASPRICE, 30, 4) as WAS_PRICE
    , nullif(replace(trim(WEIGHT), chr(0), ''), '') as WEIGHT
    , nullif(replace(trim(WEIGHTUNIT), chr(0), ''), '') as WEIGHT_UNIT
    , STATUS as STATUS
    , nullif(replace(trim(OFFEREDSIZE), chr(0), ''), '') as OFFERED_SIZE
    , nullif(replace(trim(UPC), chr(0), ''), '') as UPC
    , MFSOURCE as MF_SOURCE
    , nullif(replace(trim(MPSKUID), chr(0), ''), '') as MPSKU_ID
    , date(FIRSTAVAILABLESALEDATE) as FIRST_AVAILABLE_SALE_DATE
    , date(FIRSTEXPECTEDRECEIVEDDATE) as FIRST_EXPECTED_RECEIVED_DATE
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as CHANGED_AT
    , date(MFDATECHANGED) as MF_CHANGED_AT
    , nullif(replace(trim(MODIFIEDBY), chr(0), ''), '') as MODIFIED_BY
FROM
    {{source('MP_PRODUCTS', 'MP_SIZE')}}
