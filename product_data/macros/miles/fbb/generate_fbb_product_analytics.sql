{% macro generate_fbb_product_analytics() %}
    {% set site_ids = [
            'WW', 'RM', 'KS', 'BH', 'JL', 'SA', 'EL', 'CA', 'ZQ', 'CP', 'IA', 'SH', 'AA', 'OS', 'FO', 'JV'
    ] %}
    select
        SFCC_PRODUCT_ID,
        {% for site_id in site_ids %}
            sum(case when SITE_ID = '{{ site_id }}' then REVENUE - ORDER_DISCOUNT - PRODUCT_DISCOUNT else 0 end) as {{ site_id }}_REVENUE,
        {% endfor %}
        {% for site_id in site_ids %}
            sum(case when SITE_ID = '{{ site_id }}' then VIEWS else 0 end) as {{ site_id }}_VIEWS,
        {% endfor %}
        {% for site_id in site_ids %}
            sum(case when SITE_ID = '{{ site_id }}' then UNITS else 0 end) as {{ site_id }}_UNITS,
        {% endfor %}
        {% for site_id in site_ids %}
            sum(case when SITE_ID = '{{ site_id }}' then ORDERS else 0 end) as {{ site_id }}_ORDERS,
        {% endfor %}
    from
        {{ ref('stg_land__fbb_omniture_data') }}
    where
        CREATED_AT between dateadd(day, -7, current_date()) and dateadd(day, -1, current_date())
        and startswith(SFCC_PRODUCT_ID, '10')
    group by
        SFCC_PRODUCT_ID
{% endmacro %}
