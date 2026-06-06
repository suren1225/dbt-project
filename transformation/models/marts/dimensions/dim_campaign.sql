{{ config(
    materialized='table',
    tags=['mart','dimension']
) }}

select
    campaign_key,
    campaign_id,
    campaign_name,
    campaign_type,
    status,
    startdate,
    enddate,
    budgetedcost,
    actualcost
from {{ ref('int_campaign_performance') }}