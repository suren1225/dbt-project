{{ config(
    materialized='table',
    tags=['mart','fact']
) }}

select
    opportunity_stage_key,
    opportunityid,
    previous_stage,
    current_stage,
    stage_start_date,
    days_in_previous_stage,
    amount,
    probability
from {{ ref('int_opportunity_stage_history') }}