-- macro that converts varchar long and lat into (lat, long)

{% macro format_location(latitude, longitude) %}
    concat('(', CAST({{ latitude }} AS VARCHAR), ', ', CAST({{ longitude }} AS VARCHAR), ')')
{% endmacro %}