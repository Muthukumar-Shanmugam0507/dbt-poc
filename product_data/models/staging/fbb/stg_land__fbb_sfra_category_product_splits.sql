select
    CATEGORY_ID as CATEGORY_ID
    , trim(PRODUCT_ID) as PRODUCT_ID
    , trim(COLOR_ID) as COLOR_ID
from
    {{source('FBB_PRODUCTS', 'SFRA_CATEGORY_PRODUCTSPLIT')}}
