{{
    config(
        materialized='incremental'
    )
}}

select
    PRODUCT_ID
    , COLOR_ID
    , VARIATION_ID
    , TITLE
    , MS_DESCRIPTION
    , IMAGE_URL
    , date(DBT_VALID_FROM) as CREATED_AT
from
    {{ ref('int_fbb_active_variations_from_snapshot') }}
where
    BRAND_CODE = 'RM'
{% if is_incremental() %}
    and VARIATION_ID not in (select VARIATION_ID from {{ this }})
{% endif %}