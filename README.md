# 🛒 Central Superstore Data Warehouse & Analytics

An end-to-end, data-driven SQL Server Data Warehouse designed to evaluate retail operations, product profit margins, and customer ordering patterns. This project processes raw sales data into an optimized Star Schema model, enabling detailed business analysis and regional performance benchmarking.

## Project Overview :-

This project leverages Python and Microsoft SQL Server to construct a dimensional Data Warehouse for a central superstore. It handles the entire ETL pipeline—from cleaning raw data and establishing relational integrity to executing bulk database loading—allowing business stakeholders to analyze profitability drivers, delivery class performance, and geographical growth trends.

## Data Warehouse Architecture :-

- **Fact Table:** `fact_order`
- **Dimension Tables:** `dim_date`, `dim_customer`, `dim_product`, `dim_ship_mode`, and `dim_location`
- **Star Schema Diagram:** 👉 [Click Here to View Schema Diagram](data_warehouse&schema/star_schema.jpg)

## Tools Used :-

- **Languages:** Python, T-SQL
- **Python Libraries:** `pandas`, `numpy`, `sqlalchemy`, `pyodbc`
- **Database Engine:** Microsoft SQL Server (Transact-SQL)
- **SQL Techniques:** DDL/DML, CTEs, Window Functions (`RANK`, `LAG`, `NTILE`, `OVER`), Stored Procedures, Analytical Views, and Aggregations


## Project Objectives :-

- **ETL Pipeline & Modeling:** Clean raw retail data, standardize SQL data types, create primary/foreign key relationships, and build a scalable Star Schema.
- **Magnitude & Ranking Analysis:** Identify top and bottom 5 revenue-generating products, key client segments, and high-performing cities.
- **Time-Series Analysis:** Measure Month-Over-Month (MoM) and Year-Over-Year (YoY) sales growth using automated Stored Procedures.
- **Cumulative & Performance Metrics:** Calculate running total sales, moving average unit prices, and profit margin percentages by category and state.
- **Data Segmentation & Reporting:** Categorize products into price/seller groups, classify customer value tiers, evaluate discount impacts, and compute Average Order Profit (AOP).
