{% macro active_flag(column_name) %}

case
    when {{ column_name }} = true
        then 'Active'
    else 'Inactive'
end

{% endmacro %}