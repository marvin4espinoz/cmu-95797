--macro for converting datetime string to datetime "timestamp"

{% macro cast_to_timestamp(column_name) %}
    TRY_CAST({{ column_name }} AS TIMESTAMP)
{% endmacro %}