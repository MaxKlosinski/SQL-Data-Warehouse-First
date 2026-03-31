WITH clean_data AS (
    SELECT
        CASE
            WHEN CID like 'NAS%' THEN
                SUBSTRING(CID, 4, LEN(CID))
            ELSE CID
        END AS CID
        ,CASE
            WHEN BDATE > GETDATE() THEN
                NULL
            ELSE BDATE
        END AS BDATE
        ,CASE UPPER(TRIM(GEN))
            WHEN 'F' THEN 'Female'
            WHEN 'M' THEN 'Male'
            WHEN 'Male' THEN 'Male'
            WHEN 'Female' THEN 'Female'
            ELSE 'n/a'
        END AS GEN
    FROM {{ source('erp_sources', 'cust_az12') }}
),

remove_duplicates AS (
    SELECT
        CID
        ,BDATE
        ,GEN
        ,ROW_NUMBER() OVER (PARTITION BY CID, BDATE, GEN ORDER BY BDATE DESC) AS rn
    FROM clean_data
)

SELECT CID
    ,BDATE
    ,GEN
  FROM remove_duplicates
  WHERE rn = 1