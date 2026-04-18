WITH base_data AS (
    SELECT prd_id
        ,REPLACE(SUBSTRING(prd_key,1,5),'-','_') as cat_id
        ,SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key
        ,prd_nm
        ,prd_cost
        ,{{ dev_standardization(
            ref('product_line_standaryzation'), 
            'prd_line') }} as prd_line
        ,prd_start_dt
        ,LEAD(prd_start_dt,1,NULL) over(partition by prd_key order by prd_start_dt) as prd_end_dt 
    FROM {{ref('stg_crm__prd_info')}}
)

SELECT 
    *
FROM 
    base_data