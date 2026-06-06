{{ config(
    materialized='table',
    tags=['mart','dimension']
) }}

select
    customer_key,
    account_id,
    account_name,
    account_type,
    industry,
    annualrevenue,
    numberofemployees,
    billingcity,
    billingstate,
    billingcountry,
    customerpriority__c,
    sla__c,
    active__c,
    ownerid,
    primary_contact_id,
    primary_contact_name,
    primary_contact_email,
    primary_contact_phone,
    createddate,
    lastmodifieddate
from {{ ref('int_customer_360') }}