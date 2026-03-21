/*
==================================================
AGGREGATE CUSTOMER TABLES
==================================================

Warrning!!!
This code must be executed in parts because the structure creating 
the view does not allow it to be executed. The code fragments checking 
the given data have not been saved in other files because these code 
fragments are not very complicated or complex, and this would contribute 
to the additional complexity of the entire project.
*/

use DataWarehouse;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cci.cst_id ASC) AS customer_surrogate_id
	,cci.cst_id AS customer_id
	,cci.cst_key AS customer_key
	,cci.cst_firstname AS firstname
	,cci.cst_lastname AS lastname
	,ela.CNTRY AS country
	,cci.cst_marital_status AS marital_status
	,CASE 
		WHEN cci.cst_gndr != 'n/a' THEN cci.cst_gndr
		ELSE COALESCE(eca.GEN, 'n/a')
	END gender
	,cci.cst_create_date AS create_date
	,eca.BDATE AS birthday
FROM silver.crm_cust_info AS cci
LEFT JOIN silver.erp_CUST_AZ12 AS eca
ON cci.cst_key = eca.CID
LEFT JOIN silver.erp_LOC_A101 AS ela
ON cci.cst_key = ela.CID

/*
----------------------------------
Check duplicates after aggreagate
----------------------------------
*/
SELECT cst_key, COUNT(*) AS id_count
FROM 
	(SELECT 
		cci.cst_id
		,cci.cst_key
		,cci.cst_firstname
		,cci.cst_lastname
		,cci.cst_marital_status
		,cci.cst_gndr
		,cci.cst_create_date
		,eca.BDATE
		,eca.GEN
		,ela.CNTRY
	FROM silver.crm_cust_info AS cci
	LEFT JOIN silver.erp_CUST_AZ12 AS eca
	ON cci.cst_key = eca.CID
	LEFT JOIN silver.erp_LOC_A101 AS ela
	ON cci.cst_key = ela.CID)
AS t
GROUP BY cst_key HAVING COUNT(*) > 1;

EXEC silver.load_silver;

/*
----------------------------------
Check data integration
----------------------------------
*/
SELECT DISTINCT
	cci.cst_gndr
	,eca.GEN
	,CASE 
		WHEN cci.cst_gndr != 'n/a' THEN cci.cst_gndr
		ELSE COALESCE(eca.GEN, 'n/a')
	END new_cst_gndr
FROM silver.crm_cust_info AS cci
LEFT JOIN silver.erp_CUST_AZ12 AS eca
ON cci.cst_key = eca.CID
LEFT JOIN silver.erp_LOC_A101 AS ela
ON cci.cst_key = ela.CID
ORDER BY cst_gndr;