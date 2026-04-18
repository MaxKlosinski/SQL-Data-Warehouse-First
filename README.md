# SQL Data Warehouse – an educational project based on the Data with Baraa methodology
Link: https://www.youtube.com/watch?v=9GVqKuTVANE&t=9350s

# The structure of my project
My project implements an ETL/ELT process. However, my entire project consists of two parts. 
- The first part involves implementing SQL code and preparing the Medallion schema. The entire project is built on Microsoft SQL Server.

- The second part implements the entire operational logic using the following technologies:
  - dbt labs for project management and preparing the appropriate data transformations.
  - Databricks + Pyspark as tools for retrieving raw data and storing it in the form of tables. I implemented this process using Auto Loader as the tool for retrieving raw data. Data processing was carried out as an ETL pipeline using the Databricks platform (Apache Spark). Databricks Jobs / Workflows were used for orchestration and automation of code execution.

# What I learned
## What I learned in the first part of the project:
1. **Data Architecture:** Designing a Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
2. **ETL Pipelines:** Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling:** Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting:** Creating SQL-based reports and dashboards for actionable insights.
5. **I learned how to create documentation:** Thanks to the content presented in the first draft, I learned what I should focus on when writing documentation and what it should include.

## What I learned in the second part of my project:
1. **Databricks Architecture:** I learned about the directory structure in the unit catalog, how to use it, and how to retrieve data from it.
2. **Auto Loader in Databricks:** I have learned how to use and properly configure the Auto Loader data retrieval technology.
3. **Implementing dbt labs in Visual Studio and using the profiles.yml file:** I learned how to set up dbt labs in Visual Studio and how to connect to Databricks, and I learned the basics of managing profiles in the file used to connect to databases; the name of this file is profiles.yml
4. **I learned how to create macros in dbt labs:** I learned how to write macros and how to use them to automate my code and speed up my work, both by writing them myself and by using pre-made macro packages like dbt.utils.
5. **Writing YAML configuration files:** I gained experience in preparing configuration files for my models, seeds, and snapshots. I also learned how to write the source file so that it would run the tests correctly and locate my data files.
6. **Proficient reading of documentation:** Thanks to the many configuration files I've created, I've learned to work efficiently with documentation.