{% macro customer_segment(revenue_column) %}

case
    when {{ revenue_column }} >= 1000000 then 'Enterprise'
    when {{ revenue_column }} >= 100000 then 'Mid Market'
    else 'SMB'
end

{% endmacro %}