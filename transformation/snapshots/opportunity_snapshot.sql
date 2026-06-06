{% snapshot opportunity_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='opportunity_id',
        strategy='timestamp',
        updated_at='lastmodifieddate'
    )
}}

select *
from {{ ref('fct_opportunity') }}

{% endsnapshot %}