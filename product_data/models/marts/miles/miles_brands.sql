select
    BRAND_CODE as BRAND_ID
    , BRAND_NAME
from
    {{ ref('stg_land__fbb_brands') }}
where
    BLOOMREACH_BRAND_NAME is not null