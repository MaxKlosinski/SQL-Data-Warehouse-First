
-- Use the `ref` function to select from other models

select *
from {{ ref('bronze.crm.bronze_crm_cust_info') }}
where id = 1
