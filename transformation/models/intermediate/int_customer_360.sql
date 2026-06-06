{{ config(
    materialized='view',
    tags=['intermediate','customer']
) }}

with account as (
    select *
    from {{ ref('stg_salesforce__account') }}
),

contact as (
    select *
    from {{ ref('stg_salesforce__contact') }}
),

priority as (
    select *
    from {{ ref('customer_priority') }}
)
,
primary_contact as (
    select
        accountid,
        contact_id,
        concat(firstname,' ',lastname) as contact_name,
        email,
        phone,
		
        row_number() over(
            partition by accountid
            order by createddate
        ) as rn
    from contact
)

select
    {{ dbt_utils.generate_surrogate_key(['a.account_id']) }}
        as customer_key,
    a.account_id,
    a.name as account_name,
    a.type as account_type,

    a.industry,
    a.annualrevenue,
    a.numberofemployees,

    a.billingcity,
    a.billingstate,
    a.billingcountry,

    a.customerpriority__c,
    a.sla__c,
    a.active__c,
    a.ownerid,

    pc.contact_id as primary_contact_id,
    pc.contact_name as primary_contact_name,
    pc.email as primary_contact_email,
    pc.phone as primary_contact_phone,

    a.createddate,
    a.lastmodifieddate,
	p.priority_name
from account a
left join priority p
    on a.customerpriority__c = p.priority_code
left join primary_contact pc
    on a.account_id = pc.accountid
   and pc.rn = 1