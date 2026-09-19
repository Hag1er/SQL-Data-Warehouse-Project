
--Database Exploration :- 
--  Explore fact and dimension tables and the range of data


--fact table
SELECT *
FROM fact_order

SELECT *
FROM dim_customer

SELECT *
FROM dim_product

SELECT *
FROM dim_date

SELECT *
FROM dim_ship_mode

SELECT *
FROM dim_location

--data range
SELECT MIN (full_date) first_orderr
      ,MAX (full_date) last_order
FROM dim_date
