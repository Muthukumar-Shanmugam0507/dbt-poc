{{
    config(
        materialized='incremental'
    )
}}

select
    PRODUCT_ID
    , COLOR_ID
    , sysdate() as DATE_ADDED
from
    {{ ref('int_fbb_active_variation_inventory') }}
{% if is_incremental() %}
    where (PRODUCT_ID, COLOR_ID) not in (select PRODUCT_ID, COLOR_ID from {{ this }})
{% endif %}