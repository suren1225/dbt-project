{{ config(
    materialized='view',
    tags=['intermediate','product']
) }}

with product as (
    select *
    from {{ ref('stg_salesforce__product_2') }}
),

pricebook as (
    select *
    from {{ ref('stg_salesforce__pricebook_entry') }}
)

select
    {{ dbt_utils.generate_surrogate_key([
        'p.product_id'
    ]) }} as product_key,
    p.product_id,
    p.name as product_name,
    p.productcode,
    p.family,
    p.type,
    p.productclass,
    p.quantityunitofmeasure,
    p.stockkeepingunit,
    pb.unitprice,
    pb.isactive as price_active,
    p.isactive as product_active,
    p.createddate,
    p.lastmodifieddate
from product p
left join pricebook pb
    on p.product_id = pb.product2id