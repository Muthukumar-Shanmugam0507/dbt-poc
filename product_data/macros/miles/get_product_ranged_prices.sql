{% macro get_product_ranged_prices(min_price, max_price, default_price=none) %}
{% if default_price is not none %}
coalesce(
        {{ default_price }}::varchar,
{% endif %}
        iff(
            ({{ min_price }} = {{ max_price }}) or {{ min_price }} is null,
            {{ min_price }}::varchar,
            ({{ min_price }} || ' - ' || {{ max_price }})::varchar)
{% if default_price is not none %}
)
{% endif %}
{% endmacro %}