{% macro dev_standardization(
    standaryztion,
    column_name) %}

    {%- set column_values_sql -%}
        select
            *
        from {{standaryztion}}
    {%- endset -%}

    {# 
    The run_query function is only available during the 'run' phase of dbt.
    During the 'compile' phase, we cannot execute SQL queries, so we will not have
    access to the results of the query. To handle this, we can use a conditional statement 
    to check if we are in the 'run' phase before attempting to execute the query and access its results.

    Why I need this?
    This condition is necessary to ensure that data is retrieved only when 
    absolutely necessary. This is because the `run_query` function may be called
    at various points in the code, such as during compilation or when generating 
    documentation.    
    #}

    {% if flags.WHICH != "run" %}
        {%- set results = run_query(column_values_sql) %}
    {% endif %}
    
    CASE

    {% for key, valu in results %}
        WHEN UPPER(TRIM({{column_name}})) = '{{key}}' THEN '{{valu}}'
    {% endfor %}
    WHEN TRIM({{column_name}}) = '' THEN 'N\\A'
    WHEN UPPER(TRIM({{column_name}})) is null THEN 'N\\A'
    ELSE TRIM({{column_name}})
    END
{% endmacro %}