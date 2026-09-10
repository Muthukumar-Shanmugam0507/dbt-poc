{% macro raise_update_exception() %}
    {% set failures_query %}
        select count(*) from {{ ref("fbb_failed_model_updates") }}
    {% endset %}
    {% set failures = run_query(failures_query) %}
    {% if failures is not none %}
        {% for row in failures %}
            {% if row[0] > 0 %}
                {{ exceptions.raise_compiler_error("Models with erroneous updates: " ~ row[0]) }}
            {% endif %}
        {% endfor %}
    {% endif %}
{% endmacro %}