{{ config(
    materialized='view',
    tags=['intermediate','marketing']
) }}

with campaign as (
    select *
    from {{ ref('stg_salesforce__campaign') }}
),

opportunity as (
    select *
    from {{ ref('stg_salesforce__opportunity') }}
)

select

    {{ dbt_utils.generate_surrogate_key([
        'c.campaign_id'
    ]) }} as campaign_key,

    c.campaign_id,
    c.name as campaign_name,
    c.type as campaign_type,
    c.status,
    c.startdate,
    c.enddate,
    c.budgetedcost,
    c.actualcost,
    c.expectedrevenue,
    c.numberofleads,
    c.numberofconvertedleads,
    c.numberofopportunities,
    c.numberofwonopportunities,
    c.amountallopportunities,
    c.amountwonopportunities,

    case
        when c.actualcost > 0
        then
            (
                c.amountwonopportunities
                - c.actualcost
            ) / c.actualcost
    end as roi

from campaign c