
--customer behavior report 

CREATE VIEW customer_behavior_report AS

WITH base_query AS (
SELECT c.customer_id
       ,c.customer_name
       ,c.segment
       ,p.product_id
       ,o.order_id 
       ,o.sales
       ,o.quantity
       ,o.profit
FROM fact_order o
    JOIN dim_customer c
    ON o.customer_key =c.customer_key
    JOIN dim_product p
    ON o.product_key =p.product_key
),aggr_query AS 
(
SELECT  customer_id
       ,customer_name
       ,segment
       ,SUM(sales) total_sales
       ,SUM(profit) total_profit
       ,SUM(quantity) total_quantity
       ,COUNT(DISTINCT order_id) total_orders
       ,COUNT(DISTINCT product_id) total_products
       ,ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
       ,NTILE(3) OVER (ORDER BY SUM(sales) DESC) cus_segs
FROM base_query
GROUP BY  customer_id
         ,customer_name
         ,segment
)
SELECT customer_id
       ,customer_name
       ,segment
       ,total_sales
       ,total_profit
       ,total_quantity
       ,total_orders
       ,total_products
       ,avg_order_value
       ,CASE 
          WHEN cus_segs =1 THEN 'high_value'
          WHEN cus_segs =2 THEN 'mid_value'
          ELSE 'low_value'
          END AS customer_type 
FROM aggr_query















