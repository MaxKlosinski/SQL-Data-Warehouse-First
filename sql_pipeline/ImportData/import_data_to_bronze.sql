/*
==========================================================
IMPORT DATA TO BRONZE
==========================================================
*/

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	DECLARE @total_start_time DATETIME, @total_end_time DATETIME;
	BEGIN TRY

		PRINT '===============================================================';
		PRINT 'Loading CRM';
		PRINT '===============================================================';

		SET @total_start_time = GETDATE();

		SET @start_time = GETDATE();
		TRUNCATE TABLE DataWarehouse.bronze.crm_cust_info;
		BULK INSERT DataWarehouse.bronze.crm_cust_info
		FROM 'C:\Users\Joint\Desktop\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT CONCAT('time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));

		SET @start_time = GETDATE();
		TRUNCATE TABLE DataWarehouse.bronze.crm_prd_info;
		BULK INSERT DataWarehouse.bronze.crm_prd_info
		FROM 'C:\Users\Joint\Desktop\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT CONCAT('time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));

		SET @start_time = GETDATE();
		TRUNCATE TABLE DataWarehouse.bronze.crm_sales_details;
		BULK INSERT DataWarehouse.bronze.crm_sales_details
		FROM 'C:\Users\Joint\Desktop\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT CONCAT('time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));

		PRINT '===============================================================';
		PRINT 'Loading ERP';
		PRINT '===============================================================';

		SET @start_time = GETDATE();
		TRUNCATE TABLE DataWarehouse.bronze.erp_CUST_AZ12;
		BULK INSERT DataWarehouse.bronze.erp_CUST_AZ12
		FROM 'C:\Users\Joint\Desktop\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT CONCAT('time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));

		SET @start_time = GETDATE();
		TRUNCATE TABLE DataWarehouse.bronze.erp_LOC_A101;
		BULK INSERT DataWarehouse.bronze.erp_LOC_A101
		FROM 'C:\Users\Joint\Desktop\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT CONCAT('time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));

		SET @start_time = GETDATE();
		TRUNCATE TABLE DataWarehouse.bronze.erp_PX_CAT_G1V2;
		BULK INSERT DataWarehouse.bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\Joint\Desktop\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT CONCAT('time that has passed in seconds: ', DATEDIFF(second, @start_time, @end_time));

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