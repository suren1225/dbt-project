{{ config(
    materialized='table',
    tags=['mart','fact']
) }}

select
    lead_key,
    lead_id,
    company,
    industry,
    leadsource,
    rating,
    annualrevenue,
    status,
    isconverted,
    lead_status,
    days_to_convert,
    createddate,
    converteddate
from {{ ref('int_lead_conversion') }}