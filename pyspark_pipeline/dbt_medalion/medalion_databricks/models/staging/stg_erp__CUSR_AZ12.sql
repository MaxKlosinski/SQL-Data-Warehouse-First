WITH prepare_data AS (
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
        ,{{ dev_standardization(
          ref('gender_standaryzation'), 
          'GEN') }} AS GEN
    FROM {{ source('erp_sources', 'cust_az12') }}
),
remove_duplicates AS (
    {{ 
      dbt_utils.deduplicate(
        relation="prepare_data",
        partition_by='CID',
        order_by="CID",
      )
    }}
)

SELECT 
    CID
    ,BDATE
    ,GEN
FROM 
    remove_duplicates