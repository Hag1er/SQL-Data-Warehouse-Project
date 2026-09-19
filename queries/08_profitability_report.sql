
--profitability report 
 --Query purpose:
 --measure how much each product actually generates profit and calculate Average Order Profit

CREATE VIEW profitability_report AS

WITH base_query AS (
    SELECT p.product_id
          ,p.product_name
          ,p.category
          ,p.sub_category
          ,o.order_id 
          ,o.sales
          ,o.profit
    FROM fact_order o
    JOIN dim_product p
    ON o.product_key =p.product_key
    JOIN dim_customer c
    ON o.customer_key =c.customer_key
), agg_query AS 
(
SELECT  product_id
       ,product_name
       ,category
       ,sub_category
       ,SUM(sales) total_sales
       ,SUM(profit) total_profit
       ,COUNT(DISTINCT order_id) total_orders
       ,CAST(ROUND(SUM(profit)/SUM(sales) *100,2)AS DECIMAL (10,2)) profit_margin_perc
       ,NTILE(3) OVER (ORDER BY SUM(profit) DESC) profit_rnk
FROM base_query
GROUP BY product_id
       ,product_name
       ,category
       ,sub_category
)
SELECT  product_id
       ,product_name
       ,category
       ,sub_category
       ,total_sales
       ,total_profit
       ,profit_margin_perc
       ,CASE 
          WHEN profit_rnk = 1 THEN 'highly profit'
          WHEN profit_rnk = 2 THEN 'mid profit'
          ELSE 'loses'
          END AS product_segment
        -- Average Order Profit (AOP)
	    ,CASE 
		  WHEN total_orders = 0 THEN 0
		  ELSE total_profit / total_orders
	     END AS avg_order_profit
FROM agg_query