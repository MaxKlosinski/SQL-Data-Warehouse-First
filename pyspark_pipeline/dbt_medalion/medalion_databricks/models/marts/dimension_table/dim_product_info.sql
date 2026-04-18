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
FROM {{ref('int_crm__prd_info')}} AS pd
LEFT JOIN {{ref('int_erp__PX_CAT_G1V2')}} AS ex
ON ex.ID = pd.cat_id