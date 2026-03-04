use DataWarehouse;

-- Deleting lines to avoid adding duplicates.
TRUNCATE TABLE [DataWarehouse].[silver].[erp_CUST_AZ12];

INSERT INTO [DataWarehouse].[silver].[erp_CUST_AZ12](
[CID]
,[BDATE]
,[GEN]
)
SELECT

-- Remove the NAS part from the words contained in this column.
    CASE
        WHEN CID like 'NAS%' THEN
            SUBSTRING(CID, 4, LEN(CID))
        ELSE CID
    END AS CID
    ,CASE
        WHEN [BDATE] > GETDATE() THEN
            NULL
        ELSE [BDATE]
    END AS BDATE
    ,CASE UPPER(TRIM([GEN]))
        WHEN 'F' THEN 'Female'
        WHEN 'M' THEN 'Male'
        WHEN 'Male' THEN 'Male'
        WHEN 'Female' THEN 'Female'
        ELSE 'n/a'
    END AS GEN
  FROM [DataWarehouse].[bronze].[erp_CUST_AZ12]