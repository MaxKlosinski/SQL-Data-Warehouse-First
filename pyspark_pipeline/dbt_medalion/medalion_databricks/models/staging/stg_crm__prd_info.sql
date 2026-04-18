SELECT prd_id
      ,prd_key
      ,prd_nm
      ,COALESCE(prd_cost,0) as prd_cost
      ,{{ dev_standardization(
          ref('product_line_standaryzation'), 
          'prd_line') }} as prd_line
      ,prd_start_dt
      ,COALESCE(prd_end_dt,"9999-12-31") as prd_end_dt
FROM {{ source('crm_sources', 'prd_info') }}

{# 
    This file's dates and structure are too unclear for me to generate 
    snapshots based on its lines. 
#}