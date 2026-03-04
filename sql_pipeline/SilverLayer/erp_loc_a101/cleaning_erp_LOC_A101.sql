use DataWarehouse;

-- Deleting lines to avoid adding duplicates.
TRUNCATE TABLE [DataWarehouse].[silver].[erp_LOC_A101];

INSERT INTO [DataWarehouse].[silver].[erp_LOC_A101] (
    CID
    ,[CNTRY]
)
SELECT
    REPLACE([CID],'-','') AS CID
    ,CASE
        WHEN TRIM([CNTRY]) = 'DE' THEN 'Germany'
        WHEN TRIM([CNTRY]) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM([CNTRY]) = '' OR TRIM([CNTRY]) IS NULL THEN 'n/a'
        ELSE TRIM([CNTRY])
    END AS CNTRY
FROM [DataWarehouse].[bronze].[erp_LOC_A101]