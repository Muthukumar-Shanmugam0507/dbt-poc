{{
    config(
        materialized='incremental'
    )
}}

select
    PRODUCT_ID
    , COLOR_ID
    , VARIATION_ID
    , BRAND_CODE
    , LAYDOWN_IMAGE_URL
    , null as RESIZED_LAYDOWN_IMAGE_URL
    , null as UPLOADED_AT
from
    {{ ref('fbb_active_variations') }}
where
    LAYDOWN_IMAGE_URL is not null
{% if is_incremental() %}
    and VARIATION_ID not in (select VARIATION_ID from {{ this }})
{% endif %}