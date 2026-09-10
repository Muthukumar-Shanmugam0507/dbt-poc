{% macro get_variations(clearance_indicator=none, is_final_sale=none, limit=3, ascending=none, backorder=none) %}
select
    PRODUCT_ID
    , SIZE_ID
    , SELLING_PRICE
from
    {{ ref('fbb_active_styles') }}
where
    {% if backorder is none %} (QUANTITY > 0)  {% else %} (QUANTITY = 0 and BACKORDER_QUANTITY > 0) {% endif %}
    {% if clearance_indicator is not none %} and CLEARANCE_INDICATOR = '{{ clearance_indicator }}' {% endif %}
    {% if is_final_sale is not none %} and IS_FINAL_SALE = {{ is_final_sale }} {% endif %}
qualify row_number() over(
    partition by PRODUCT_ID
    order by SELLING_PRICE {% if ascending is none %} desc {% else %} asc {% endif %},
             QUANTITY desc,
             SIZE_ID) <= {{ limit }}
{% endmacro %}