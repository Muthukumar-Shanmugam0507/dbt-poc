{% macro generate_cte(cte_name, order_by, array_alias, params_dict) %}
    {{ cte_name }} as (
        select
            a.PRODUCT_ID,
            array_agg(SIZE_ID) within group (order by {{ order_by }}, SIZE_ID) as {{ array_alias }}
        from (
            {%- for params in params_dict %}
                {%- if not loop.first %} union {% endif %}
                {{ get_variations(**params) }}
            {%- endfor %}
        ) as a
        group by
            a.PRODUCT_ID
    )
{% endmacro %}