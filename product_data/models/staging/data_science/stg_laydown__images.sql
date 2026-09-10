select
    PRODUCT_ID
    , COLOR_ID
    , IMAGE_URL
from
    {{source('ELOQUII_LAYDOWN_IMAGES', 'LAYDOWN_IMAGES')}}
where
    IMAGE_URL is not null

union

select
    PRODUCT_ID
    , COLOR_ID
    , IMAGE_URL
from
    {{source('WW_LAYDOWN_IMAGES', 'LAYDOWN_IMAGES')}}
where
    IMAGE_URL is not null