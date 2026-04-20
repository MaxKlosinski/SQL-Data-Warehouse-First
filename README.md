# End-to-End Data Pipeline (SQL Server & Databricks & dbt)

This project demonstrates a Data Engineering pipeline. It implements an ETL/ELT process to ingest, process, and transform data using a Medallion Architecture (Bronze, Silver, Gold). The project is divided into two distinct implementations: a foundational phase using Microsoft SQL Server, and a modern, cloud-native phase utilizing Databricks, PySpark, and dbt.

**Tech Stack:**

- **Modern Stack** Databricks, dbt (a database management tool), PySpark, Unity Catalog
- **Traditional Stack:** Microsoft SQL Server, T-SQL
- **Methodology:** Medallion Architecture, ETL/ELT, Data Governance, Schema Evolution
- **Orchestration:** Databricks Workflows / Jobs, Auto Loader

---

## Project Architecture

The project is structured around two main technological approaches to building a data warehouse:

1. **SQL Server Pipeline (`sql_pipeline/`):**
   - A traditional approach building the Medallion schema entirely within Microsoft SQL Server using T-SQL.
   - Focuses on raw SQL implementation, data modeling, and creating a comprehensive data catalog.

2. **Databricks & dbt Pipeline (`pyspark_pipeline/`):**

- **Ingestion:** Leverages **Databricks Auto Loader** for efficient, incremental ingestion into Delta tables, ensuring robust handling of schema evolution.
- **Transformation:** Uses **dbt** to manage the transformation logic. Data is refined through Bronze, Silver, and Gold layers using modular SQL models.
- **Orchestration:** Fully automated via Databricks Workflows.

---

## Repository Structure

- `sql_pipeline/`: Contains T-SQL scripts defining the Bronze, Silver, and Gold layers, along with project naming conventions and a detailed `Data catalog.md`.
- `pyspark_pipeline/databricks_pipeline/`: Contains Python/PySpark notebooks responsible for data ingestion and initial processing in Databricks.
- `pyspark_pipeline/dbt_medalion/`: Contains the dbt project, including configuration (`dbt_project.yml`, `packages.yml`, `package-lock.yml`), macros, and SQL models for data transformation.

---

## Key Skills & Competencies

### Data Modeling & SQL Fundamentals

- **Architectural Design:** Designed a multi-layered warehouse following Medallion principles to ensure data quality.
- **Documentation:** Created a detailed Data Catalog to maintain clear definitions and metadata, making data understandable for stakeholders and end users.

### Modern Data Stack (Databricks & dbt)

- **Data Governance:** Implemented structured data management within **Unity Catalog**, ensuring secure and organized data access.
- **Efficient Ingestion:** Leveraged **PySpark Structured Streaming** and **Databricks Auto Loader** for robust, incremental data ingestion into **Delta Lake** tables. Implemented schema inference, strict schema evolution controls, and checkpointing for fault-tolerant pipelines.
- **Modern dbt Practices:**
  - **Data Quality & Validation:** Implemented rigorous data validation using native dbt tests alongside advanced testing frameworks (`dbt_expectations`, `dbt_utils`) to ensure data integrity.
  - **Historical Tracking:** Utilized YAML-based snapshot configurations to implement **Slowly Changing Dimensions (SCD Type 2)**, maintaining a complete audit trail of dimension changes.
  - **Data Standardization:** Leveraged **dbt seeds** for static mapping tables to standardize inconsistent data formats (e.g., country codes, gender).
  - **SLA Monitoring:** Configured source freshness checks to monitor data latency and ensure timely pipeline execution.
  - **DRY Engineering:** Developed **custom dbt macros** and integrated `dbt_utils` to keep the codebase DRY and scalable.
  - Established secure connections via `profiles.yml` and utilized environment variables for best-practice security.
- **Workflow Automation:** Orchestrated complex pipelines using Databricks Jobs, ensuring reliable end-to-end execution.

---

## Summary

This project served as a practical sandbox to develop my data engineering skills across both traditional and modern data environments. By independently building the same ETL pipeline in SQL Server and then migrating it to Databricks and dbt, I gained hands-on experience with the complete data lifecycle—from ingestion and transformation to documentation and orchestration.

---
**Inspiration and Sources**: This project was inspired by and serves as an educational extension of the Data with Baraa methodology ([YouTube Link](https://www.youtube.com/watch?v=9GVqKuTVANE&t=9350s)).