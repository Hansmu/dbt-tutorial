-- Remember, the expected result of a test is that it returns 0 rows, so the condition is inverted to the title.
-- It is a positive value if there are no below 1 values, so try and find every below 1 value.
{% test positive_integer_value(model, column_name) %}
    SELECT *
    FROM {{ model }}
    WHERE {{ column_name}} < 1
{% endtest %}