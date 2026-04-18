SELECT 
    CID
    ,BDATE
    ,GEN
FROM 
    {{ ref('stg_erp__CUSR_AZ12') }}