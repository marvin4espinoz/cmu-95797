-- grab year column and calcuate current age, and also create null values for age where age is greater than 100 years old

{% macro calculate_age(birth_year_column) %}
    CASE
        WHEN {{ birth_year_column }} IS NOT NULL AND (CAST(EXTRACT(YEAR FROM CURRENT_DATE) - CAST({{ birth_year_column }} AS INT) AS INT)) <= 100
        THEN CAST(EXTRACT(YEAR FROM CURRENT_DATE) - CAST({{ birth_year_column }} AS INT) AS INT)
        ELSE NULL
    END
{% endmacro %}