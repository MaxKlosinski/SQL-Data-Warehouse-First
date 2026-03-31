WITH source_data AS (
    SELECT * FROM {{ source('crm_sources', 'sales_details') }}
),

deduplicated AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY sls_ord_num
            ORDER BY sls_ord_num DESC
        ) as row_num
    FROM source_data
),

final_processing AS (
    SELECT 
        sls_ord_num
        ,sls_prd_key
        ,sls_cust_id
        
        /*
        ----------------------------------------------------------------------
        DATE TRANSFORMATION SECTION
        Logic: Validate raw input. If the date is '0' or does not have 8 digits (YYYYMMDD),
        treat it as NULL. Otherwise, convert to DATE type (Style 105 = dd-mm-yyyy).
        ----------------------------------------------------------------------
        */

        ,CASE
            WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE date_format(to_date(sls_order_dt, 'yyyyMMdd'), 'yyyyMMdd')
            END AS sls_order_dt
        ,CASE
            WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE date_format(to_date(sls_ship_dt, 'yyyyMMdd'), 'yyyyMMdd')
            END AS sls_ship_dt
        ,CASE
            WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE date_format(to_date(sls_due_dt, 'yyyyMMdd'), 'yyyyMMdd')
            END AS sls_due_dt

        /*
        ----------------------------------------------------------------------
        SALES AMOUNT VALIDATION (Data Quality Rule)
        Logic: Check for data integrity issues. If 'Sales' is NULL, negative, or 
        mathematically inconsistent with the formula (Price * Quantity), recalculate it.
        We use ABS() to fix potential negative sign errors in source data.
        ----------------------------------------------------------------------
        */

        ,CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales <> ABS(sls_price * sls_quantity)
                    THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales

        ,sls_quantity

        /*
        ----------------------------------------------------------------------
        PRICE IMPUTATION
        Logic: If 'Price' is missing or invalid (<=0), reverse-calculate it 
        by dividing Total Sales by Quantity.
        NULLIF is used to prevent 'Divide by Zero' errors.
        ----------------------------------------------------------------------
        */

        ,CASE
            WHEN sls_price IS NULL OR sls_price <= 0
                    THEN ABS(sls_sales / NULLIF(sls_quantity,0))
                ELSE sls_price
            END AS sls_price

    FROM deduplicated
    WHERE row_num = 1 -- Keep only the first occurrence of duplicates
)

SELECT * FROM final_processing