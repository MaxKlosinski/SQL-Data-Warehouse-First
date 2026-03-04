use DataWarehouse;

/*
=============================================
DATA QUALITY & INTEGRITY CHECKS
Context: Validating data in the Silver Layer (CRM)
=============================================

Checking whether any that are to be 
identifiers are contained only in the 
subarray and not in the main array.
*/
SELECT
    REPLACE([CID],'-','') AS CID
    ,[CNTRY]
FROM [DataWarehouse].[silver].[erp_LOC_A101]
WHERE REPLACE([CID],'-','') NOT IN 
(SELECT cst_key FROM silver.crm_cust_info);

-- Data standaryzation & Consistency
SELECT
    DISTINCT [CNTRY]
FROM [DataWarehouse].[silver].[erp_LOC_A101]
ORDER BY [CNTRY];