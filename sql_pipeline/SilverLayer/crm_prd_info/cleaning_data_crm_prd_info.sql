-- First we need get informations from columns where are more informaions in one column and needs to split to more columns
-- Columns to need split:
-- This char '->' informs us what columns will be created after the column split. 
-- This char '=>' This symbol informs us about the purpose of a given column.
-- crm_prd_info[prd_key] -> cat_id => This column will serve as the primary key for the erp_PX_CAT_G1V2 table.
-- This column describes the categories assigned to a given product.
-- crm_prd_info[prd_key] -> prd_key => This is a column containing a unique product key.

-- Now, we will standarize columns
-- crm_prd_info[prd_cost] -> This column contains null values for prices, which may cause errors in calculations, 
-- so in this case we will replace each null value with zero.

USE DataWarehouse

-- Deleting lines to avoid adding duplicates.
TRUNCATE TABLE silver.crm_prd_info;

INSERT INTO silver.crm_prd_info (
    prd_id
    ,cat_id
    ,prd_key
    ,prd_nm
    ,prd_cost
    ,prd_line
    ,prd_start_dt
    ,prd_end_dt
)
SELECT [prd_id]
      ,REPLACE(SUBSTRING([prd_key],1,5),'-','_') as cat_id
      ,SUBSTRING([prd_key],7,LEN([prd_key])) as prd_key
      ,[prd_nm]
      ,ISNULL([prd_cost],0) as prd_cost
      ,CASE UPPER(TRIM([prd_line]))
            WHEN 'M' THEN 'Mountain'
            WHEN 'R' THEN 'Road'
            WHEN 'S' THEN 'other Sales'
            WHEN 'T' THEN 'Touring'
            ELSE 'n\a'
        END as [prd_line]
      ,[prd_start_dt]
      ,LEAD(DATEADD(day, -1, prd_start_dt),1,NULL) over(partition by prd_key order by prd_start_dt) as prd_end_dt 
  FROM [DataWarehouse].[bronze].[crm_prd_info]