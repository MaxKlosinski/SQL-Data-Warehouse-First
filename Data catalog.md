# Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics.

# gold.dim_customers

- **Purpose:** It contains basic information about a given person, as well as demographic and geographic data pertaining to that person.
- **Columns:**

| Column name           | Column type  | Description                                                                           |
| --------------------- | ------------ | ------------------------------------------------------------------------------------- |
| customer_surrogate_id | INTEGER      | Surrogate key uniquely identifying each customer record in the dimension table.       |
| customer_key          | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing. |
| customer_id           | INTEGER      | Unique numerical identifier assigned to each customer.                                |
| firstname             | NVARCHAR(50) | The customer's first name, as recorded in the system.                                 |
| lastname              | NVARCHAR(50) | The customer's last name or family name.                                              |
| country               | NVARCHAR(50) | The country of residence for the customer (e.g., 'Unitet States').                    |
| marital_status        | NVARCHAR(50) | The marital status of the customer (e.g., 'Married', 'Single').                       |
| create_date           | DATE         | The date and time when the customer record was created in the system.                 |
| birthday              | DATE         | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).        |

# gold.dim_products

- **Purpose:** It contains a description and all of its characteristics.
- **Columns:**

| Column name    | Column type  | Description                                                                                                                   |
| -------------- | ------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| product_key    | INTEGER      | Surrogate key uniquely identifying each product record in the product dimension table.                                        |
| product_id     | INTEGER      | A unique identifier assigned to the product for internal tracking and referencing.                                            |
| category_id    | NVARCHAR(50) | This is a unique identifier used to quickly distinguish between categories and subcategories of a given product.              |
| category       | NVARCHAR(50) | This is the main category to which the product belongs.                                                                       |
| subcategory    | NVARCHAR(50) | And this is an additional category used to better classify a given item.                                                      |
| maintance      | NVARCHAR(50) | Indicates which items require maintenance.                                                                                    |
| product_number | NVARCHAR(50) | It is an alphanumeric code that represents a given product, most often used for categorization or inventory purposes.         |
| product_name   | NVARCHAR(50) | This is the full name of the product, which includes the full names of items that contain descriptions such as color or size. |
| product_cost   | INTEGER      | A number indicating the price per unit of a given item.                                                                       |
| product_line   | NVARCHAR(50) | Describes the type of travel for which the product is intended.                                                               |
| start_date     | DATE         | The date when the product became available for sale or use, stored in                                                         |

# gold.fact_sales

- **Purpose:** It stores information about a given transaction.
- **Columns:**

| Column name           | Column type  | Description                                                                                 |
| --------------------- | ------------ | ------------------------------------------------------------------------------------------- |
| customer_surrogate_id | INTEGER      | Surrogate key linking the order to the customer dimension table.                            |
| product_key           | INTEGER      | Surrogate key linking the order to the product dimension table.                             |
| order_number          | NVARCHAR(50) | Unique Alpha numeric order key (e.g. ‘SO43697’)                                             |
| order_date            | DATE         | Order start date.                                                                           |
| shipping_date         | DATE         | The date on which the order was delivered.                                                  |
| due_date              | DATE         | The date on which payments for the product were made.                                       |
| sales_amount          | INTEGER      | The total monetary value of the sale for the line item, in whole currency units (e.g., 25). |
| quantity              | INTEGER      | Number of products purchased.                                                               |
| price                 | INTEGER      | Price per single item.                                                                      |

