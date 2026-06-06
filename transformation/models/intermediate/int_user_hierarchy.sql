{{ config(
    materialized='view',
    tags=['intermediate','user']
) }}

with users as (
    select *
    from {{ ref('stg_salesforce__user') }}
),

roles as (
    select *
    from {{ ref('stg_salesforce__user_role') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['u.user_id']) }}
        as user_key,

    u.user_id,
    concat(
        u.firstname,
        ' ',
        u.lastname
    ) as user_name,

    u.email,
    u.department,
    u.title,
    r.name as role_name,
    mgr.user_id as manager_id,

    concat(
        mgr.firstname,
        ' ',
        mgr.lastname
    ) as manager_name,

    u.isactive,
    u.createddate,
    u.lastmodifieddate

from users u
left join roles r
    on u.userroleid = r.user_role_id
left join users mgr
    on u.managerid = mgr.user_id