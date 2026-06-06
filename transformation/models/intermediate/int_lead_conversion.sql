{{ config(
    materialized='view',
    tags=['intermediate','marketing']
) }}

with leads as (
    select *
    from {{ ref('stg_salesforce__lead') }}
)

select
    {{ dbt_utils.generate_surrogate_key([
        'lead_id'
    ]) }} as lead_key,

    lead_id,
    company,
    firstname,
    lastname,
    email,
    leadsource,
    industry,
    rating,
    annualrevenue,
    numberofemployees,
    status,
    isconverted,
    converteddate,
    convertedaccountid,
    convertedcontactid,
    convertedopportunityid,

    datediff(
        'day',
		cast(createddate as date),
		cast(converteddate as date)
    ) as days_to_convert,

    case
        when isconverted = true
        then 'Converted'
        else 'Open'
    end as lead_status,

    createddate,
    lastmodifieddate

from leads