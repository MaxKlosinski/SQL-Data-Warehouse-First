WITH source_data AS (
    {{ 
      dbt_utils.deduplicate(
        relation=source('erp_sources', 'loc_a101'),
        partition_by='CID, CNTRY',
        order_by="CID",
      )
    }}
)

SELECT
    REPLACE(CID,'-','') AS CID
    ,CASE
        WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
        WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(CNTRY) = '' OR TRIM(CNTRY) IS NULL THEN 'n/a'
        ELSE TRIM(CNTRY)
    END AS CNTRY
FROM source_data