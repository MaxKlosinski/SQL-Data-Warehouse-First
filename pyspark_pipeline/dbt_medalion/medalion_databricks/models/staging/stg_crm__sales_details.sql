WITH source_data AS (
    SELECT 
        * 
    FROM 
        {{ source('crm_sources', 'sales_details') }}
),

deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY sls_ord_num
            ORDER BY sls_ord_num DESC
        ) as row_num
    FROM source_data
)

SELECT 
    sls_ord_num
    ,sls_prd_key
    ,sls_cust_id
    ,sls_order_dt
    ,sls_ship_dt
    ,sls_due_dt
    ,sls_sales
    ,sls_quantity
    ,sls_price
FROM 
    deduplicated 
WHERE 
    row_num = 1