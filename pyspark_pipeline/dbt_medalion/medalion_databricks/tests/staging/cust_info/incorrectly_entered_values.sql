-- Search for incorrectly entered values. In this case, it is a space before and after the text.
-- Expectations: NO Resoults

select 
  cst_lastname, 
  cst_firstname 
from 
  {{source('crm_sources', 'cust_info')}}
  where 
    cst_lastname != TRIM(cst_lastname) OR 
    cst_firstname != TRIM(cst_firstname)