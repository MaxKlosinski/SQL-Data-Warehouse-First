/*
==========================================================================
1. Primary Key Constraint Check
Description: Verifies that 'prd_id' is unique and contains no NULLs.
Expectation: No results returned.
==========================================================================
*/
SELECT 
    prd_id,
    COUNT(prd_id) AS record_count
FROM 
    [DataWarehouse].[silver].[crm_prd_info] 
GROUP BY 
    prd_id 
HAVING 
    COUNT(prd_id) > 1 OR prd_id IS NULL;

/*
==========================================================================
2. Whitespace Validation
Description: Checks if 'prd_key' contains unintended leading or 
trailing whitespace characters.
Expectation: No results returned.
==========================================================================
*/
SELECT
    prd_key
FROM 
    [DataWarehouse].[silver].[crm_prd_info]
WHERE
    prd_key <> TRIM(prd_key);

/*
==========================================================================
3. Null Value Check (Critical Columns)
Description: Ensures that critical columns (like Product Cost) are populated.
Expectation: No results returned.
==========================================================================
*/
SELECT
    prd_cost
FROM 
    [DataWarehouse].[silver].[crm_prd_info]
WHERE
    prd_cost IS NULL;

/*
==========================================================================
4. Data Standardization Check
Description: Lists unique values for 'prd_line' to manually audit for 
spelling errors, typos, or inconsistent naming conventions.
Expectation: A clean list of distinct product lines.
==========================================================================
*/
SELECT
    DISTINCT prd_line
FROM 
    [DataWarehouse].[silver].[crm_prd_info];

/*
==========================================================================
5. Date Logic Validity Check
Description: Ensures that the Product Start Date does not occur after 
the Product End Date.
Expectation: No results returned.
==========================================================================
*/
SELECT
    *
FROM 
    [DataWarehouse].[silver].[crm_prd_info]
WHERE
    prd_start_dt > prd_end_dt;