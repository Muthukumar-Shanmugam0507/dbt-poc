SELECT
    COLORID as COLOR_ID
    , PRODUCTID as PRODUCT_ID
    , nullif(replace(trim(upper(COLOR)), chr(0), ''), '') as COLOR
    , nullif(replace(trim(PANTONE), chr(0), ''), '') as PANTONE
    , to_boolean(ISPRINT) as IS_PRINT
    , STATUS as STATUS
    , date(DATECREATED) as CREATED_AT
    , date(DATECHANGED) as UPDATED_AT
    , MODIFIEDBY as MODIFIED_BY
FROM
    {{source('MP_PRODUCTS', 'MP_COLOR')}}