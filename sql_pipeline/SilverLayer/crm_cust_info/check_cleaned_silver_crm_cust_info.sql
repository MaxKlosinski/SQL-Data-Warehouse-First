-- =============================================
-- DATA QUALITY & INTEGRITY CHECKS
-- Context: Validating data in the Silver Layer (CRM)
-- =============================================

use DataWarehouse;

-- =====================================================================================
-- 1. Primary Key Check: Uniqueness
-- Purpose: Verify that 'cst_id' is unique across the table.
-- Expectation: This query should return NO results.
-- =====================================================================================
select 
	cst_id
	, count(*) as count_of_id
from silver.crm_cust_info 
group by cst_id 
	having count(*) > 1

-- =====================================================================================
-- 1.1. Duplicate Identification Strategy
-- Purpose: Identify duplicate records to keep the most recent one (Golden Record).
-- Logic: Assigns a rank (ROW_NUMBER) to entries with the same 'cst_id'.
--        Ordered by 'cst_create_date' DESC means the newest record gets row_num = 1.
--        We filter for 'flag_row != 1' to find the OLDER duplicates (the ones to drop/audit).
-- Expectation: No results (if the data is already clean).
-- =====================================================================================
select * from (
select 
*, 
ROW_NUMBER() OVER(
	PARTITION BY 
		cst_id 
		order by 
			cst_create_date desc) as flag_row 
		FROM silver.crm_cust_info
)t where flag_row != 1;

-- =====================================================================================
-- 2. Data Cleaning: Whitespace Validation
-- Purpose: Detect string values that have leading or trailing spaces.
-- Logic: Compares the original column value against the TRIMmed version.
--        If they are not equal, the data contains unnecessary spaces.
-- Expectation: No results.
-- =====================================================================================

-- Check Last Name
select cst_lastname from silver.crm_cust_info where cst_lastname != TRIM(cst_lastname);

-- Check First Name
select cst_firstname from silver.crm_cust_info where cst_firstname != TRIM(cst_firstname);

-- =====================================================================================
-- 3. Data Standardization Audit
-- Purpose: Review unique values in categorical columns to ensure consistency.
--          (e.g., ensuring we don't have both 'M' and 'Male' or 'F' and 'Female').
-- Expectation: A clean list of standardized categories (No abbreviations/shortcuts).
-- =====================================================================================
select distinct cst_gndr from silver.crm_cust_info;