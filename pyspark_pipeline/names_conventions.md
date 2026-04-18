# Naming Conventions

This document outlines the naming conventions used across the project based on the existing file structure and database models, with a specific focus on the `pyspark_pipeline` and `dbt` project.

## General Conventions

- **File Names:** All file names strictly follow the `snake_case` convention.
- **Folder Names (PySpark/DBT):** Follow `snake_case` (e.g., `dbt_medalion`, `dimension_table`).
- **Folder Names (SQL Pipeline):** Generally follow `CamelCase` (e.g., `SilverLayer`, `GoldLayer`), with specific source table subfolders using `snake_case`.

---

## PySpark & DBT Pipeline (Medallion Architecture)

The DBT project models are organized and named using prefixes that clearly denote their layer in the data processing flow (Staging, Intermediate, Marts).

### 1. Staging Layer (Bronze to Silver)
- **Prefix:** `stg_`
- **Pattern:** `stg_<source_system>__<table_name>.sql` (Note the **double underscore** `__` separating the source system from the table name).
- **Examples:** 
  - `stg_crm__cust_info.sql`
  - `stg_crm__sales_details.sql`
  - `stg_erp__LOC_A101.sql`

### 2. Intermediate Layer (Silver)
- **Prefix:** `int_`
- **Pattern:** `int_<source_system>__<table_name>.sql` (Using the double underscore separator).
- **Examples:**
  - `int_crm__cust_info.sql`
  - `int_erp__CUSR_AZ12.sql`

### 3. Marts Layer (Gold)
- **Dimension Tables Prefix:** `dim_`
  - **Pattern:** `dim_<entity_name>.sql`
  - **Examples:** `dim_customer_info.sql`, `dim_product_info.sql`
- **Fact Tables Prefix:** `fact_`
  - **Pattern:** `fact_<business_process>.sql`
  - **Examples:** `fact_sales.sql`

### 4. Configuration & Properties Files
- YAML property files for testing, documentation, and configuration reflect the layer and source system.
- **Pattern:** `<layer>_<source>__properties.yml` or `<layer>_properties.yml`.
- **Examples:** 
  - `stg_crm__properties.yml`
  - `int_erp_properties.yml`
  - `mart_properties.yml`

### 5. Seeds
- **Pattern:** `<attribute>_standaryzation.csv`
- **Examples:** 
  - `country_standaryzation.csv`
  - `gender_standaryzation.csv`

---

## SQL Pipeline Conventions (Reference)

For consistency with the pure SQL processes defined in `sql_pipeline`, the following rules are observed:

- **Bronze Tables:** `<source_system>_<entity>` (e.g., `crm_cust_info`), where the entity name matches the source exactly.
- **Silver Processing Scripts:** Named based on the action, such as `cleaning_data_<source>_<table_name>.sql` or `cleaning_<source>_<table_name>.sql`. Check scripts use `check_cleaned_<source>_<table_name>.sql`.
- **Gold Processing Scripts:** Named based on the target entity or action, such as `join_<entity>_info.sql`.
- **Stored Procedures:** Prefix with `load_` followed by the target layer (e.g., `load_bronze`, `load_silver`).
