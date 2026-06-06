select child.*
from {{ ref('stg_salesforce__account') }} child
left join {{ ref('stg_salesforce__account') }} parent
    on child.parentid = parent.parentid
where child.parentid is not null
  and parent.parentid is null