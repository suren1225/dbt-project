{{ config(
    materialized='table',
    tags=['mart','fact']
) }}

select
    opportunity_key,
    customer_key,
    user_key,
    campaignid,
    opportunity_id,
    opportunity_name,
    stagename,
    sales_status,
    amount,
    probability,
    expected_pipeline_amount,
    customer_segment,
    closedate,
    forecastcategory,
    createddate,
    lastmodifieddate
from {{ ref('int_opportunity_enriched') }}