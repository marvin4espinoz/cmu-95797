-- macro for rounding coordinate values that start as varchar --> round(double,2)

{% macro round_coordinates(coordinate, decimal_places) %}
    ROUND({{ coordinate }}::double, {{ decimal_places }})
{% endmacro %}