select *
from {{ ref('stg_salesforce__contact') }}
where email is not null
  and email not like '%@%'