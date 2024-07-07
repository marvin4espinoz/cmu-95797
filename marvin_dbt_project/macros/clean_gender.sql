-- macro takes in gender column (1=male, 2=female) and convert them to "male" and "female" or "null" values

{% macro clean_gender(gender_column) %}
    CASE
        WHEN {{ gender_column }} = '1' THEN 'male'
        WHEN {{ gender_column }} = '2' THEN 'female'
        ELSE NULL
    END
{% endmacro %}