-- Check quality of data
-- 1. Check if primary keys do not have any null or duplicates.
-- 2. Catch dupliceates with the oldest date from base.
-- 3. Search for incorrectly entered values. In this case, it is a space before the text.

use DataWarehouse;

-- 1. Check if primary keys do not have any null or duplicates.
-- Exceptiations: No results
select 
	cst_id
	, count(*) as count_of_id
from bronze.crm_cust_info 
group by cst_id 
	having count(*) > 1

-- 1.1 Catch dupliceates with the oldest date from base.
-- Expectations: No results
select * from (
select 
*, 
ROW_NUMBER() OVER(
	PARTITION BY 
		cst_id 
		order by 
			cst_create_date desc) as flag_row 
		FROM bronze.crm_cust_info
)t where flag_row != 1;

-- 2. Search for incorrectly entered values. In this case, it is a space before and after the text.
-- Expectations: NO Resoults

select cst_lastname from bronze.crm_cust_info where cst_lastname != TRIM(cst_lastname);
select cst_firstname from bronze.crm_cust_info where cst_firstname != TRIM(cst_firstname);

-- 3. Data standardization. In this case, we replace abbreviations with full names to improve data comprehensibility.
-- Expectations: No shortucts.
-- Standaryzed full names:
-- n\a
-- Famle
-- Men
select distinct cst_gndr from bronze.crm_cust_info;