select
    distinct
    max(case when ATTRIBUTE_NAME = 'DIVISION' then ATTRIBUTE_VALUE end) as DIVISION,
    max(case when ATTRIBUTE_NAME = 'CATEGORY' then ATTRIBUTE_VALUE end) as CATEGORY,
    max(case when ATTRIBUTE_NAME = 'SUBCATEGORY' then ATTRIBUTE_VALUE end) as SUBCATEGORY
from
    {{ ref('stg_pdm__product_attributes') }}
where
    ATTRIBUTE_NAME IN ('DIVISION', 'CATEGORY', 'SUBCATEGORY')
group by
    PRODUCT_ID
order by
    DIVISION, CATEGORY, SUBCATEGORY