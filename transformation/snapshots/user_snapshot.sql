{% snapshot user_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='user_id',
        strategy='timestamp',
        updated_at='lastmodifieddate'
    )
}}

select *
from {{ ref('dim_user') }}

{% endsnapshot %}