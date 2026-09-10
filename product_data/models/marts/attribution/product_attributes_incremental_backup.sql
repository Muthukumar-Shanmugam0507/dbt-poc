{{ config(
    materialized='incremental'
) }}

select
    PRODUCT_ID,
    ATTRIBUTE_NAME,
    ATTRIBUTE_VALUE,
    CREATED_AT
from
    {{ ref('stg_pdm__product_attributes') }}
{% if is_incremental() %}
where
    (PRODUCT_ID, ATTRIBUTE_VALUE) not in (
        select
            PRODUCT_ID,
            ATTRIBUTE_VALUE
        from
            {{this}}
    )
{% endif %}