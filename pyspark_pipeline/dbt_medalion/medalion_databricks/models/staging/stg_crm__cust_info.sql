WITH remove_duplicates AS (
    {{ 
      dbt_utils.deduplicate(
        relation=source('crm_sources', 'cust_info'),
        partition_by='cst_id',
        order_by="cst_id",
      )
    }}
),
remove__nulls AS (
    SELECT *
    FROM remove_duplicates
    WHERE cst_id IS NOT NULL
)

SELECT cst_id
      ,cst_key
      ,TRIM(cst_firstname) as cst_firstname
      ,TRIM(cst_lastname) as cst_lastname
      ,{{ dev_standardization(
          ref('martial_standaryzation'), 
          'cst_marital_status') }} 
          AS cst_marital_status
          
      ,{{ dev_standardization(
          ref('gender_standaryzation'), 
          'cst_gndr') }} 
        AS cst_gndr
      ,CAST(cst_create_date AS TIMESTAMP) as cst_create_date
 FROM  remove__nulls