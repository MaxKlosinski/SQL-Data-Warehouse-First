/*
=================================================================
This file creates tables for the bronze schema.
=================================================================

Warning!!!
Any table with the same name will be deleted, because each 
table checks whether it already exists and is deleted accordingly to avoid errors.

MEATDATA
Each table will contain an additional column storing the time at which a given row was created.
*/

USE DataWarehouse

IF OBJECT_ID (N'DataWarehouse.silver.crm_cust_info', N'U') IS NOT NULL
BEGIN
	DROP TABLE DataWarehouse.silver.crm_cust_info;
END;

/*
I use nvarchar not varchar because varchar have size 8 bits what is not full scope for all chars what could be used.
*/
CREATE TABLE silver.crm_cust_info (
	 cst_id             INTEGER
	,cst_key            NVARCHAR(50)
	,cst_firstname      NVARCHAR(50)
	,cst_lastname       NVARCHAR(50)
	,cst_marital_status NVARCHAR(50)
	,cst_gndr           NVARCHAR(50)
	,cst_create_date    DATE
	,dwh_create_row_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID (N'DataWarehouse.silver.crm_prd_info', N'U') IS NOT NULL
BEGIN
	DROP TABLE DataWarehouse.silver.crm_prd_info;
END;

CREATE TABLE silver.crm_prd_info (
	 prd_id       INTEGER 
	,cat_id       NVARCHAR(50)
	,prd_key      NVARCHAR(50)
	,prd_nm       NVARCHAR(50)
	,prd_cost     INTEGER 
	,prd_line     NVARCHAR(50)
	,prd_start_dt DATE
	,prd_end_dt   DATE
	,dwh_create_row_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID (N'DataWarehouse.silver.crm_sales_details', N'U') IS NOT NULL
BEGIN
	DROP TABLE DataWarehouse.silver.crm_sales_details;
END;

CREATE TABLE silver.crm_sales_details (
	 sls_ord_num  NVARCHAR(50)
	,sls_prd_key  NVARCHAR(50)
	,sls_cust_id  INTEGER
	,sls_order_dt DATE
	,sls_ship_dt  DATE
	,sls_due_dt   DATE
	,sls_sales    INTEGER 
	,sls_quantity INTEGER
	,sls_price    INTEGER
	,dwh_create_row_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID (N'DataWarehouse.silver.erp_CUST_AZ12', N'U') IS NOT NULL
BEGIN
	DROP TABLE DataWarehouse.silver.erp_CUST_AZ12;
END;

CREATE TABLE silver.erp_CUST_AZ12 (
	 CID   NVARCHAR(50)
	,BDATE DATE
	,GEN   NVARCHAR(50)
	,dwh_create_row_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID (N'DataWarehouse.silver.erp_LOC_A101', N'U') IS NOT NULL
BEGIN
	DROP TABLE DataWarehouse.silver.erp_LOC_A101;
END;

CREATE TABLE silver.erp_LOC_A101 (
	 CID   NVARCHAR(50)
	,CNTRY NVARCHAR(50)
	,dwh_create_row_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID (N'DataWarehouse.silver.erp_PX_CAT_G1V2', N'U') IS NOT NULL
BEGIN
	DROP TABLE DataWarehouse.silver.erp_PX_CAT_G1V2;
END;

CREATE TABLE silver.erp_PX_CAT_G1V2 (
	 ID          NVARCHAR(50)
	,CAT         NVARCHAR(50)
	,SUBCAT      NVARCHAR(50)
	,MAINTENANCE NVARCHAR(50)
	,dwh_create_row_date DATETIME2 DEFAULT GETDATE()
);