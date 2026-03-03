use DataWarehouse;

/*
====================================================================================
PURPOSE: Load the SILVER layer (Cleaned Data) from the BRONZE layer (Raw Data).
KEY OPERATIONS:
1. Standardization: Converting raw integer/string dates to SQL DATE format.
2. Data Quality: Handling invalid dates, zero values, and text lengths.
3. Business Logic: Recalculating inconsistent Sales and Prices to ensure mathematical accuracy.
====================================================================================
*/

-- Deleting lines to avoid adding duplicates.
TRUNCATE TABLE [DataWarehouse].[silver].[crm_sales_details];

INSERT INTO [DataWarehouse].[silver].[crm_sales_details] (
    [sls_ord_num]
    ,[sls_prd_key]
    ,[sls_cust_id]
    ,[sls_order_dt]
    ,[sls_ship_dt]
    ,[sls_due_dt]
    ,[sls_sales]
    ,[sls_quantity]
    ,[sls_price]
)
SELECT 
    -- Direct mapping of identifiers (no transformation required)
    [sls_ord_num]
    ,[sls_prd_key]
    ,[sls_cust_id]

    /*
    ----------------------------------------------------------------------
    DATE TRANSFORMATION SECTION
    Logic: Validate raw input. If the date is '0' or does not have 8 digits (YYYYMMDD),
    treat it as NULL. Otherwise, convert to DATE type (Style 105 = dd-mm-yyyy).
    ----------------------------------------------------------------------
    */
    ,   CASE
            WHEN [sls_order_dt] = 0 OR LEN([sls_order_dt]) != 8 THEN NULL
            ELSE CONVERT(date, CONVERT(nvarchar(50), sls_order_dt), 105)
        END AS sls_order_dt
    ,   CASE
            WHEN [sls_ship_dt] = 0 OR LEN([sls_ship_dt]) != 8 THEN NULL
            ELSE CONVERT(date, CONVERT(nvarchar(50), [sls_ship_dt]), 105)
        END AS sls_ship_dt
    ,   CASE
            WHEN [sls_due_dt] = 0 OR LEN([sls_due_dt]) != 8 THEN NULL
            ELSE CONVERT(date, CONVERT(nvarchar(50), [sls_due_dt]), 105)
        END AS sls_due_dt

    /*
    ----------------------------------------------------------------------
    SALES AMOUNT VALIDATION (Data Quality Rule)
    Logic: Check for data integrity issues. If 'Sales' is NULL, negative, or 
    mathematically inconsistent with the formula (Price * Quantity), recalculate it.
    We use ABS() to fix potential negative sign errors in source data.
    ----------------------------------------------------------------------
    */
    ,	CASE 
			WHEN [sls_sales] IS NULL OR [sls_sales] <= 0 OR [sls_sales] <> ABS([sls_price] * [sls_quantity])
				THEN [sls_quantity] * ABS([sls_price])
			ELSE [sls_sales]
		END AS sls_sales

    -- Quantity is passed through without modification
    ,[sls_quantity]

    /*
    ----------------------------------------------------------------------
    PRICE IMPUTATION
    Logic: If 'Price' is missing or invalid (<=0), reverse-calculate it 
    by dividing Total Sales by Quantity.
    NULLIF is used to prevent 'Divide by Zero' errors.
    ----------------------------------------------------------------------
    */
    ,   CASE
			WHEN [sls_price] IS NULL OR [sls_price] <= 0
				THEN ABS([sls_sales] / NULLIF([sls_quantity],0))
			ELSE [sls_price]
		END AS sls_price

  FROM [DataWarehouse].[bronze].[crm_sales_details]