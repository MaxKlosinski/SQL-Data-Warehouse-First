/*
==========================================================
lOAD DATA TO SILVER
==========================================================

Show info:
After executing a given piece of code, this file will display 
information about how long each operation took.
*/

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
BEGIN TRY
	DECLARE @start_time DATETIME, @end_time DATETIME;
	DECLARE @total_start_time DATETIME, @total_end_time DATETIME;

    SET @end_time = GETDATE();

    PRINT '==========================================================';
    SET @start_time = GETDATE();
    PRINT 'Truncating table: crm_cust_info';
    -- Deleting lines to avoid adding duplicates.
    TRUNCATE TABLE DataWarehouse.silver.crm_cust_info;

    PRINT 'Insarting to table: crm_cust_info';
    INSERT INTO DataWarehouse.silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )

    SELECT [cst_id]
          ,[cst_key]
/*
----------------------------------
TRIM BLANK CHARS
----------------------------------
*/
          ,TRIM(cst_firstname) as cst_firstname
          ,TRIM(cst_lastname) as cst_lastname
/*
----------------------------------
Data standardization
----------------------------------
*/
          ,CASE
            WHEN UPPER(TRIM([cst_marital_status])) = 'S' THEN 'Single'
            WHEN UPPER(TRIM([cst_marital_status])) = 'M' THEN 'Married'
            WHEN cst_gndr is null THEN 'n/a'
          END cst_marital_status
/*
----------------------------------
Data standardization
----------------------------------
*/
          ,CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Men'
            WHEN cst_gndr is null THEN 'n/a'
          END cst_gndr
          ,[cst_create_date]
     FROM (
     SELECT 
     *,
     /*
        Add only data that is not duplicated for a given user to our table.
     */
     ROW_NUMBER() 
        OVER(
            PARTITION BY 
                cst_id 
            ORDER BY cst_create_date DESC) as flag_duplicates 
            FROM bronze.crm_cust_info
     )t where flag_duplicates = 1 and 
              cst_id is not null;

    SET @end_time = GETDATE();

    PRINT CONCAT('Time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));

    PRINT '==========================================================';

    PRINT '==========================================================';
    SET @start_time = GETDATE();

    PRINT 'Truncating table: crm_sales_details';
    -- Deleting lines to avoid adding duplicates.
    TRUNCATE TABLE [DataWarehouse].[silver].[crm_sales_details];

    PRINT 'Insarting to table: crm_sales_details';
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
        [sls_ord_num]
        ,[sls_prd_key]
        ,[sls_cust_id]
        /*
        ----------------------------------------------------------------------
        DATE TRANSFORMATION SECTION
        ----------------------------------------------------------------------

        Logic: Validate raw input. If the date is '0' or does not have 8 digits (YYYYMMDD),
        treat it as NULL. Otherwise, convert to DATE type (Style 105 = dd-mm-yyyy).
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
        ----------------------------------------------------------------------

        Logic: Check for data integrity issues. If 'Sales' is NULL, negative, or 
        mathematically inconsistent with the formula (Price * Quantity), recalculate it.
        We use ABS() to fix potential negative sign errors in source data.
        */
        ,	CASE 
			    WHEN [sls_sales] IS NULL OR [sls_sales] <= 0 OR [sls_sales] <> ABS([sls_price] * [sls_quantity])
				    THEN [sls_quantity] * ABS([sls_price])
			    ELSE [sls_sales]
		    END AS sls_sales
        ,[sls_quantity]
        /*
        ----------------------------------------------------------------------
        PRICE IMPUTATION
        ----------------------------------------------------------------------

        Logic: If 'Price' is missing or invalid (<=0), reverse-calculate it 
        by dividing Total Sales by Quantity.
        NULLIF is used to prevent 'Divide by Zero' errors.
        */
        ,   CASE
			    WHEN [sls_price] IS NULL OR [sls_price] <= 0
				    THEN ABS([sls_sales] / NULLIF([sls_quantity],0))
			    ELSE [sls_price]
		    END AS sls_price

      FROM [DataWarehouse].[bronze].[crm_sales_details]
      SET @end_time = GETDATE();

      PRINT CONCAT('Time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));
    PRINT '==========================================================';

    PRINT '==========================================================';
    SET @start_time = GETDATE();

    PRINT 'Truncating table: crm_prd_info';
    -- Deleting lines to avoid adding duplicates.
    TRUNCATE TABLE silver.crm_prd_info;

    PRINT 'Insarting to table: crm_prd_info';
    INSERT INTO silver.crm_prd_info (
        prd_id
        ,cat_id
        ,prd_key
        ,prd_nm
        ,prd_cost
        ,prd_line
        ,prd_start_dt
        ,prd_end_dt
    )
    SELECT [prd_id]
    /*
    --------------------------------
    Separating multiple pieces of information contained in a single column.
    --------------------------------
    Separation and standardization of the primary key because a given column 
    contains several pieces of information.
    */
          ,REPLACE(SUBSTRING([prd_key],1,5),'-','_') as cat_id
          ,SUBSTRING([prd_key],7,LEN([prd_key])) as prd_key
          ,[prd_nm]
/*
---------------------------------------------------------------
Standardization of values indicating missing data.
---------------------------------------------------------------
In this case, missing data will be indicated by the number zero.
*/
          ,ISNULL([prd_cost],0) as prd_cost

/*
----------------------------------
Data standardization
----------------------------------
*/
          ,CASE UPPER(TRIM([prd_line]))
                WHEN 'M' THEN 'Mountain'
                WHEN 'R' THEN 'Road'
                WHEN 'S' THEN 'other Sales'
                WHEN 'T' THEN 'Touring'
                ELSE 'n/a'
            END as [prd_line]
          ,[prd_start_dt]
          ,LEAD(DATEADD(day, -1, prd_start_dt),1,NULL) over(partition by prd_key order by prd_start_dt) as prd_end_dt 
      FROM [DataWarehouse].[bronze].[crm_prd_info]
      SET @end_time = GETDATE();

      PRINT CONCAT('time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));
    PRINT '==========================================================';

    PRINT '==========================================================';
    SET @start_time = GETDATE();

    PRINT 'Truncating table: erp_CUST_AZ12';
    -- Deleting lines to avoid adding duplicates.
    TRUNCATE TABLE [DataWarehouse].[silver].[erp_CUST_AZ12];

    PRINT 'Insarting to table: erp_CUST_AZ12';
    INSERT INTO [DataWarehouse].[silver].[erp_CUST_AZ12](
    [CID]
    ,[BDATE]
    ,[GEN]
    )
    SELECT
    -- Remove the part of the NAS from the words contained in this column.
        CASE
            WHEN CID like 'NAS%' THEN
                SUBSTRING(CID, 4, LEN(CID))
            ELSE CID
        END AS CID
        ,CASE
            WHEN [BDATE] > GETDATE() THEN
                NULL
            ELSE [BDATE]
        END AS BDATE

/*
----------------------------------
Data standardization
----------------------------------
*/
        ,CASE UPPER(TRIM([GEN]))
            WHEN 'F' THEN 'Female'
            WHEN 'M' THEN 'Male'
            WHEN 'Male' THEN 'Male'
            WHEN 'Female' THEN 'Female'
            ELSE 'n/a'
        END AS GEN
      FROM [DataWarehouse].[bronze].[erp_CUST_AZ12]
      SET @end_time = GETDATE();

      PRINT CONCAT('Time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));
    PRINT '==========================================================';

    PRINT '==========================================================';
        SET @start_time = GETDATE();

        PRINT 'Truncating table: erp_LOC_A101';
        -- Deleting lines to avoid adding duplicates.
        TRUNCATE TABLE [DataWarehouse].[silver].[erp_LOC_A101];

        PRINT 'Insarting to table: erp_CUST_AZ12';
        INSERT INTO [DataWarehouse].[silver].[erp_LOC_A101] (
            CID
            ,[CNTRY]
        )
        SELECT
            REPLACE([CID],'-','') AS CID
            ,CASE
                WHEN TRIM([CNTRY]) = 'DE' THEN 'Germany'
                WHEN TRIM([CNTRY]) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM([CNTRY]) = '' OR TRIM([CNTRY]) IS NULL THEN 'n/a'
                ELSE TRIM([CNTRY])
            END AS CNTRY
        FROM [DataWarehouse].[bronze].[erp_LOC_A101]
        SET @end_time = GETDATE();

        PRINT CONCAT('time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));
    PRINT '==========================================================';

    PRINT '==========================================================';
        SET @start_time = GETDATE();

        PRINT 'Truncating table: erp_PX_CAT_G1V2';
        -- Deleting lines to avoid adding duplicates.
        TRUNCATE TABLE [DataWarehouse].[silver].[erp_PX_CAT_G1V2];

        PRINT 'Insarting to table: erp_PX_CAT_G1V2';
        INSERT INTO [DataWarehouse].[silver].[erp_PX_CAT_G1V2] (
            [ID]
            ,[CAT]
            ,[SUBCAT]
            ,[MAINTENANCE]
        )
        SELECT
            [ID]
            ,[CAT]
            ,[SUBCAT]
            ,[MAINTENANCE]
        FROM [DataWarehouse].[bronze].[erp_PX_CAT_G1V2]
        SET @end_time = GETDATE();
        PRINT CONCAT('time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));
    PRINT '==========================================================';

    SET @total_end_time = GETDATE();

    PRINT '=========================================='
	    PRINT CONCAT('Total time that has passed in seconds: ', DATEDIFF(second, @total_start_time, @total_end_time));
	PRINT '=========================================='
END TRY
BEGIN CATCH
	PRINT '===========================================================';
	PRINT CONCAT('Error massage: ', ERROR_MESSAGE());
	PRINT CONCAT('Error number: ', ERROR_NUMBER());
	PRINT CONCAT('Error procedure: ', ERROR_PROCEDURE());
	PRINT CONCAT('Error servenity: ', ERROR_SEVERITY());
	PRINT CONCAT('Error state: ', ERROR_STATE());
	PRINT '===========================================================';
END CATCH
END;