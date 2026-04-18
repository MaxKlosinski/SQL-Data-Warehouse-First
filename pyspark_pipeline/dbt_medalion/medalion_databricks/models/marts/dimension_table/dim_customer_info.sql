SELECT 
	ROW_NUMBER() OVER (ORDER BY cci.cst_id ASC) AS customer_surrogate_id
	,cci.cst_id AS customer_id
	,cci.cst_key AS customer_key
	,cci.cst_firstname AS firstname
	,cci.cst_lastname AS lastname
	,ela.CNTRY AS country
	,cci.cst_marital_status AS marital_status
	,eca.GEN AS gender
	,cci.cst_create_date AS create_date
	,eca.BDATE AS birthday
FROM {{ref('int_crm__cust_info')}} AS cci
LEFT JOIN {{ref('int_erp__CUSR_AZ12')}} AS eca
ON cci.cst_key = eca.CID
LEFT JOIN {{ref("int_erp__LOC_A101")}} AS ela
ON cci.cst_key = ela.CID