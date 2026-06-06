{{ config(
    materialized='view',
    tags=['intermediate','sales']
) }}

with history as (
    select *
    from {{ ref('stg_salesforce__opportunity_history') }}
),

stage_history as (

    select
        opportunityid,
        stagename,
        createddate,
        amount,
        probability,

        lag(stagename)
            over (
                partition by opportunityid
                order by createddate
            ) as previous_stage,

        lag(createddate)
            over (
                partition by opportunityid
                order by createddate
            ) as previous_stage_date,

        row_number()
            over (
                partition by opportunityid
                order by createddate desc
            ) as latest_stage_rank

    from history
)

select

    {{ dbt_utils.generate_surrogate_key([
        'opportunityid',
        'createddate'
    ]) }} as opportunity_stage_key,

    opportunityid,
    previous_stage,
    stagename as current_stage,
    previous_stage_date,
    createddate as stage_start_date,

    datediff(
        'day',
        previous_stage_date,
        createddate
    ) as days_in_previous_stage,

    amount,
    probability,
    latest_stage_rank
from stage_history