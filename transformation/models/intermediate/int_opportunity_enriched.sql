{{ config(
    materialized='view',
    tags=['intermediate','sales']
) }}

with opportunity as (
    select *
    from {{ ref('stg_salesforce__opportunity') }}
),

customer as (
    select *
    from {{ ref('int_customer_360') }}
),

sales_rep as (
    select *
    from {{ ref('int_user_hierarchy') }}
),

campaign as (
    select *
    from {{ ref('stg_salesforce__campaign') }}
)

select

    {{ dbt_utils.generate_surrogate_key(
        ['o.opportunity_id']
    ) }}
        as opportunity_key,

    o.opportunity_id,
    c.customer_key,
    s.user_key,
    o.accountid,
    o.contactid,
    o.campaignid,
    camp.name as campaign_name,
    o.name as opportunity_name,
    o.stagename,

    case
        when o.iswon = true
            then 'Won'

        when o.isclosed = true
            then 'Lost'

        else 'Open'
    end as sales_status,

    o.amount,
    o.probability,

    (
        o.amount * o.probability
    ) / 100 as expected_pipeline_amount,

    {{ customer_segment('c.annualrevenue') }}
    as customer_segment,

    o.closedate,
    o.forecastcategory,
    s.user_name as sales_rep_name,
    o.createddate,
    o.lastmodifieddate

from opportunity o
left join customer c
    on o.accountid = c.account_id
left join sales_rep s
    on o.ownerid = s.user_id
left join campaign camp
    on o.campaignid = camp.campaign_id