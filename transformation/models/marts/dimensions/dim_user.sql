{{ config(
    materialized='table',
    tags=['mart','dimension']
) }}

select
    user_key,
    user_id,
    user_name,
    email,
    department,
    title,
    role_name,
    manager_id,
    manager_name,
    isactive,
    createddate,
    lastmodifieddate
from {{ ref('int_user_hierarchy') }}