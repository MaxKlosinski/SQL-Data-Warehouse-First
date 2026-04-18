SELECT
    ID
    ,CAT
    ,SUBCAT
    ,MAINTENANCE
FROM {{ref('stg_erp__PX_CAT_G1V2')}}