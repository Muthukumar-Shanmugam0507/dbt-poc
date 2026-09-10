select
    PRODUCTID AS PRODUCT_ID
    , split(trim(BRANDS), ',') as BRANDS
    , try_to_decimal(MINBRWPRICE, 10, 2) AS MIN_BRW_PRICE
    , try_to_decimal(MAXBRWPRICE, 10, 2) AS MAX_BRW_PRICE
    , try_to_decimal(MINCLRPRICE, 10, 2) AS MIN_CLR_PRICE
    , try_to_decimal(MAXCLRPRICE, 10, 2) AS MAX_CLR_PRICE
    , try_to_decimal(MINFSPRICE, 10, 2) AS MIN_FS_PRICE
    , try_to_decimal(MAXFSPRICE, 10, 2) AS MAX_FS_PRICE
    , BRWLISTPRICE AS BRW_LIST_PRICE
    , BRWSALEPRICE AS BRW_SALE_PRICE
    , CLRLISTPRICE AS CLR_LIST_PRICE
    , CLRSALEPRICE AS CLR_SALE_PRICE
    , FSLISTPRICE AS FS_LIST_PRICE
    , FSSALEPRICE AS FS_SALE_PRICE
    , try_to_decimal(MINBRWONLYPRICE, 10, 2) AS MIN_BRW_ONLY_PRICE
    , try_to_decimal(MAXBRWONLYPRICE, 10, 2) AS MAX_BRW_ONLY_PRICE
    , try_to_decimal(MINCLRONLYPRICE, 10, 2) AS MIN_CLR_ONLY_PRICE
    , try_to_decimal(MAXCLRONLYPRICE, 10, 2) AS MAX_CLR_ONLY_PRICE
    , nullif(replace(trim(BRWPROMOID), chr(0), ''), '') as BRW_PROMO_ID
    , nullif(replace(trim(CLRPROMOID), chr(0), ''), '') as CLR_PROMO_ID
    , nullif(replace(trim(FSPROMOID), chr(0), ''), '') as FS_PROMO_ID
    , nullif(replace(trim(BRWPLPSS), chr(0), ''), '') as BRW_PLP_SS
    , nullif(replace(trim(CLRPLPSS), chr(0), ''), '') as CLR_PLP_SS
    , nullif(replace(trim(FSPLPSS), chr(0), ''), '') as FS_PLP_SS
    , nullif(replace(trim(BRWONLYPLPSS), chr(0), ''), '') AS BRW_ONLY_PLP_SS
    , nullif(replace(trim(CLRONLYPLPSS), chr(0), ''), '') AS CLR_ONLY_PLP_SS
    , to_boolean(ISPRICERANGE) AS IS_PRICE_RANGE
    , to_boolean(ISDELTA) AS ID_DELTA
    , date(DATECREATED) AS CREATED_AT
    , date(DATECHANGED) AS UPDATED_AT
from
    {{source('FBB_PRODUCTS', 'SFRA_FINALPRICEPROMO')}}
