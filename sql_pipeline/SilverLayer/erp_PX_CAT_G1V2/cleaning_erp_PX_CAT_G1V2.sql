USE DataWarehouse

-- Deleting lines to avoid adding duplicates.
TRUNCATE TABLE [DataWarehouse].[silver].[erp_PX_CAT_G1V2];

INSERT INTO [DataWarehouse].[silver].[erp_PX_CAT_G1V2] (
    [ID]
    ,[CAT]
    ,[SUBCAT]
    ,[MAINTENANCE]
)
SELECT
    [ID]
    ,[CAT]
    ,[SUBCAT]
    ,[MAINTENANCE]
FROM [DataWarehouse].[bronze].[erp_PX_CAT_G1V2]
