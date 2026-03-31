SELECT
    ID
    ,CAT
    ,SUBCAT
    ,MAINTENANCE
FROM {{ source('erp_sources', 'px_cat_g1v2') }}