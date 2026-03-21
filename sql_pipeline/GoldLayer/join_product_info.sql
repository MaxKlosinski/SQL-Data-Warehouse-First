/*
==================================================
AGGREGATE PRODUCTS TABLES
==================================================

Warrning!!!
This code must be executed in parts because the structure creating 
the view does not allow it to be executed. The code fragments checking 
the given data have not been saved in other files because these code 
fragments are not very complicated or complex, and this would contribute 
to the additional complexity of the entire project.

*/

USE DataWarehouse;
GO

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pd.prd_start_dt, pd.prd_key) AS product_key
	,pd.prd_id AS product_id
	,pd.cat_id AS category_id
	,ex.CAT AS category
	,ex.SUBCAT AS subcategory
	,ex.MAINTENANCE AS maintance
	,pd.prd_key AS product_number
	,pd.prd_nm AS product_name
	,pd.prd_cost AS product_cost
	,pd.prd_line AS product_line
	,pd.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pd
LEFT JOIN silver.erp_PX_CAT_G1V2 AS ex
ON ex.ID = pd.cat_id
WHERE pd.prd_end_dt is NULL;

/*
----------------------------------
Check duplicates after aggreagate
----------------------------------
*/
SELECT prd_key, COUNT(*) FROM (
SELECT 
	pd.prd_id
	,pd.cat_id
	,pd.prd_key
	,pd.prd_nm
	,pd.prd_cost
	,pd.prd_line
	,pd.prd_start_dt
FROM silver.crm_prd_info AS pd
LEFT JOIN silver.erp_PX_CAT_G1V2 AS ex
ON ex.ID = pd.cat_id
WHERE pd.prd_end_dt is NULL
) AS t 
GROUP BY prd_key 
	HAVING COUNT(*) > 1;