select
    a.PRODUCT_ID
    , a.BRAND_CODE
    , a.ATTRIBUTE_NAME
    , a.ATTRIBUTE_VALUE
    , a.ANNOTATED_BY
    , a.CREATED_AT
    , a.UPDATED_AT
from
    {{ ref('int_unpivoted_kobe_product_level_attributes') }} as a
{% if is_incremental() %}
left join {{ this }} as b
on a.PRODUCT_ID = b.PRODUCT_ID
and a.ATTRIBUTE_NAME = b.ATTRIBUTE_NAME
and a.ATTRIBUTE_VALUE = b.ATTRIBUTE_VALUE
where b.PRODUCT_ID is null
{% endif %}