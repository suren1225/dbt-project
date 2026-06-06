{{ config(
    materialized='view',
    tags=['intermediate','support']
) }}

with cases as (
    select *
    from {{ ref('stg_salesforce__case') }}
),

history as (
    select *
    from {{ ref('stg_salesforce__case_history_2') }}
),

status_history as (
    select
        caseid,
        status,
        lastmodifieddate,
        lag(status)
            over (
                partition by caseid
                order by lastmodifieddate
            ) as previous_status,
        lag(lastmodifieddate)
            over (
                partition by caseid
                order by lastmodifieddate
            ) as previous_status_date
    from history
)

select
    {{ dbt_utils.generate_surrogate_key([
        'c.case_id'
    ]) }} as case_key,
	
    c.case_id,
    c.accountid,
    c.contactid,
    c.ownerid,
    c.casenumber,
    c.type,
    c.priority,
    c.origin,
    c.status,
    c.reason,
    c.isclosed,
    c.isescalated,
    c.createddate,
    c.closeddate,
	
    datediff(
        'day',
        c.createddate,
        coalesce(
            c.closeddate,
            current_date
        )
    ) as case_age_days,
	
    case
        when c.slaviolation__c = true
            then 'Y'
        else 'N'
    end as sla_breach_flag,
	
    case
        when c.isescalated = true
            then 'Y'
        else 'N'
    end as escalation_flag
from cases c