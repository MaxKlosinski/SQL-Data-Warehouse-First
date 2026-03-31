SELECT prd_id
      ,REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id
      ,SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key
      ,prd_nm
      ,COALESCE(prd_cost,0) as prd_cost
      ,CASE UPPER(TRIM(prd_line))
            WHEN 'M' THEN 'Mountain'
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'other Sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'n\a'
        END as prd_line
      ,prd_start_dt
      ,LEAD(prd_start_dt,1,NULL) over(partition by prd_key order by prd_start_dt) as prd_end_dt 
  FROM {{ source('crm_sources', 'prd_info') }}