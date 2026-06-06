{{ config(
    materialized='table',
    tags=['mart','dimension']
) }}

select
    product_key,
    product_id,
    product_name,
    productcode,
    family,
    type,
    productclass,
    quantityunitofmeasure,
    stockkeepingunit,
    unitprice,
    product_active,
	{{ active_flag('product_active') }} as product_status
from {{ ref('int_product_catalog') }}