/*
=============================================
DATA QUALITY & INTEGRITY CHECKS
Context: Validating data in the Silver Layer (CRM)
=============================================
*/

use DataWarehouse;

-- Checking that no errors have crept into the dates as they have been recorded.
select 
-- Replacing duplicates and zeros with null values. This marking is necessary so that the data 
-- clearly indicates whether it is an error or missing data.
	NULLIF(sls_ship_dt, 0) AS sls_ship_dt
from DataWarehouse.silver.crm_sales_details
-- Since the date is given as an integer, it is susceptible to several errors.
where 
	-- This condition checks for errors such as the date not being negative or equal to zero.
	sls_ship_dt <= 0 OR
	-- This condition checks whether the date has been entered using 9 digits.
	LEN(sls_ship_dt) != 8 OR
	sls_ship_dt > 20500101 OR
	sls_ship_dt < 19000101;

-- Checking whether the order date is earlier than the shipping date or the invoice date.
SELECT
	*
FROM DataWarehouse.silver.crm_sales_details
WHERE
	[sls_order_dt] > [sls_due_dt] OR 
	[sls_order_dt] > [sls_ship_dt];

-- Check whether the sale price is equal to the price plus the quantity of items purchased.
-- Check whether the values are positive or not zero and whether they are not null values.

SELECT
	[sls_ord_num],
	[sls_sales]
    ,[sls_quantity]
    ,[sls_price]
FROM DataWarehouse.silver.crm_sales_details
WHERE
	[sls_sales] <> [sls_quantity] * [sls_price] OR
	[sls_sales] IS NULL OR [sls_quantity] IS NULL OR [sls_price] IS NULL OR
	[sls_sales] <= 0 OR [sls_quantity] <= 0 OR [sls_price] <= 0;