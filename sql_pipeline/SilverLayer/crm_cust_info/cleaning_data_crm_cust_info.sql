-- =============================================
-- DATA QUALITY & INTEGRITY CHECKS
-- Context: Validating data in the Silver Layer (CRM)
-- =============================================

USE DataWarehouse

-- Deleting lines to avoid adding duplicates.
TRUNCATE TABLE DataWarehouse.silver.crm_cust_info;

INSERT INTO DataWarehouse.silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)

SELECT [cst_id]
      ,[cst_key]
      ,TRIM(cst_firstname) as cst_firstname
      ,TRIM(cst_lastname) as cst_lastname
      ,CASE
        WHEN UPPER(TRIM([cst_marital_status])) = 'S' THEN 'Single'
        WHEN UPPER(TRIM([cst_marital_status])) = 'M' THEN 'Married'
        WHEN cst_gndr is null THEN 'n\a'
      END cst_marital_status
      ,CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Men'
        WHEN cst_gndr is null THEN 'n\a'
      END cst_gndr
      ,[cst_create_date]
 FROM (
 SELECT 
 *, 
 ROW_NUMBER() 
    OVER(
        PARTITION BY 
            cst_id 
        ORDER BY cst_create_date DESC) as flag_duplicates 
        FROM bronze.crm_cust_info
 )t where flag_duplicates = 1 and 
          cst_id is not null;