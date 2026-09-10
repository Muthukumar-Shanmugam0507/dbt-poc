{{
    config(
        materialized='incremental'
    )
}}

select
    PRODUCT_ID
    , COLOR_ID
    , IS_DIA
    , sysdate() as LAUNCH_DATE
from
    {{ ref('int_mp_active_variation_inventory') }}
{% if is_incremental() %}
    where (PRODUCT_ID, COLOR_ID) not in (select PRODUCT_ID, COLOR_ID from {{ this }})
{% endif %}