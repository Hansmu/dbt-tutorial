-- This one is referenced by the macro name that you create
{% macro no_nulls_in_any_table_columns(model) %}
    SELECT *
    FROM {{ model }}
    WHERE
        -- The `adapter` is built-in DBT functionality
        -- Notice the `-` at the end of the statement. This is so that any whitespace would be trimmed away.
        {% for col in adapter.get_columns_in_relation(model) -%}
            {{ col.column }} IS NULL OR
        {% endfor %}
        FALSE
{% endmacro %}