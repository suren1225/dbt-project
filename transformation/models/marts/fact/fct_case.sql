{{ config(
    materialized='table',
    tags=['mart','fact']
) }}

select
    case_key,
    case_id,
    accountid,
    ownerid,
    casenumber,
    priority,
    origin,
    status,
    isclosed,
    isescalated,
    case_age_days,
    sla_breach_flag,
    escalation_flag,
    createddate,
    closeddate
from {{ ref('int_case_lifecycle') }}