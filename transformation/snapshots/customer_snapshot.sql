{% snapshot customer_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='account_id',
        strategy='timestamp',
        updated_at='lastmodifieddate'
    )
}}

select *
from {{ ref('dim_customer') }}

{% endsnapshot %}