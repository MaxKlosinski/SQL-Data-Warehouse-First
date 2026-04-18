SELECT 
    sls_ord_num AS order_number
    ,pro.product_key AS product_key
    ,cus.customer_surrogate_id AS customer_surrogate_id
    ,sls_order_dt AS order_date
    ,sls_ship_dt AS shipping_date
    ,sls_due_dt AS due_date
    ,sls_sales AS sales_amount
    ,sls_quantity AS quantity
    ,sls_price AS price
FROM {{ref('int_crm__sales_details')}} AS csd
LEFT JOIN {{ref('dim_customer_info')}} AS cus
    ON cus.customer_id = csd.sls_cust_id
LEFT JOIN {{ref('dim_product_info')}} AS pro
    ON pro.product_number = csd.sls_prd_key