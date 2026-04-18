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
    ,{{ dev_standardization(
          ref('country_standaryzation'), 
          'CNTRY') }} AS CNTRY
FROM source_data