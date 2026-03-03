-- =============================================
-- DATA QUALITY & INTEGRITY CHECKS
-- Context: Validating data in the Silver Layer (ERP)
-- =============================================

SELECT 
    -- Normalizing the Customer ID (CID):
    -- Some legacy IDs contain a 'NAS' prefix which must be stripped 
    -- to match the format used in the CRM system.
    CASE
        WHEN CID LIKE 'NAS%' THEN
            SUBSTRING(CID, 4, LEN(CID)) -- Extract substring starting after 'NAS'
        ELSE CID
    END AS CID
    ,[BDATE]
    ,[GEN]
FROM 
    [DataWarehouse].[silver].[erp_CUST_AZ12]
WHERE 
    -- Filter condition: Select only records where the normalized CID
    -- does NOT exist in the CRM customer table.
    CASE
        WHEN CID LIKE 'NAS%' THEN
            SUBSTRING(CID, 4, LEN(CID))
        ELSE CID
    END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);


/*
    =========================================================================
    SECTION 2: Data Validity Check (Birth Dates)
    Goal: Detect outliers and impossible values in the Birth Date (BDATE) column.
    =========================================================================
*/
SELECT 
    BDATE
FROM 
    [DataWarehouse].[silver].[erp_CUST_AZ12] 
WHERE
    -- Logic checks for:
    -- 1. Unlikely ages: Dates prior to 1940 (checks for potentially obsolete data or typos).
    -- 2. Impossible values: Dates in the future (greater than the current system timestamp).
    BDATE < '1940-01-01' 
    OR 
    BDATE > GETDATE();


/*
    =========================================================================
    SECTION 3: Standardization & Consistency
    Goal: Profiling the Gender (GEN) column.
    =========================================================================

    Inspect unique values to ensure data consistency (e.g., checking for
    mixed formats like 'M'/'F' vs 'Male'/'Female' or NULLs).v
*/
SELECT 
    DISTINCT [GEN] 
FROM
    [DataWarehouse].[silver].[erp_CUST_AZ12];