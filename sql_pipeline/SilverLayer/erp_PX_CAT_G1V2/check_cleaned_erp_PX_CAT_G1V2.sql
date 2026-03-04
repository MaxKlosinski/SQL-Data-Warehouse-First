USE DataWarehouse;

/*
=============================================
DATA QUALITY & INTEGRITY CHECKS
Context: Validating data in the Silver Layer (ERP)
=============================================
*/

/*
1. Referential Integrity Check
Purpose: Identify 'orphan' IDs in the ERP table that do not have a corresponding match
in the CRM product info table. Returns IDs that might break relationships.
*/
SELECT
    [ID]
FROM [DataWarehouse].[silver].[erp_PX_CAT_G1V2]
WHERE [ID] NOT IN (SELECT DISTINCT [cat_id] FROM [DataWarehouse].[silver].[crm_prd_info]);

/*
2. Data Hygiene: Whitespace Validation
Purpose: Detect rows where specific text columns contain unwanted leading or trailing spaces.
The query compares the original value against the TRIM() value; if they differ, the row is flagged for cleaning.
*/
SELECT
    [ID]
    ,[CAT]
    ,[SUBCAT]
    ,[MAINTENANCE]
FROM [DataWarehouse].[silver].[erp_PX_CAT_G1V2]
WHERE
    [ID] != TRIM([ID]) OR
    [CAT] != TRIM([CAT]) OR
    [SUBCAT] != TRIM([SUBCAT]) OR
    [MAINTENANCE] != TRIM([MAINTENANCE]);

/*
3. Standardization & Consistency Analysis
Purpose: List all unique values in the 'MAINTENANCE' column to spot data anomalies.
Use this to check for duplicates caused by case sensitivity (e.g., 'Yes' vs 'yes') or typos.
*/
SELECT
    DISTINCT MAINTENANCE
FROM [DataWarehouse].[silver].[erp_PX_CAT_G1V2];