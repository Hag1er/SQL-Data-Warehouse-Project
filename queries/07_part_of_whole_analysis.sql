
 --Part to whole analysis
 --  Query Purpose :
 --   -measure each column contribution (%) to the overall total

-- 01.Which categories contribute the most to overall sales?
WITH category_sales AS (
    SELECT p.category
          ,SUM(o.sales) total_sales
    FROM fact_order o
    JOIN dim_product p
    ON o.product_key = p.product_key
    GROUP BY p.category
)
SELECT  category
       ,total_sales
       ,SUM(total_sales) OVER() overall_sales
       ,ROUND((CAST(total_sales AS FLOAT)/ SUM(total_sales) OVER())*100 ,2) psc_of_total
FROM category_sales
ORDER BY total_sales


-- 02.Which ship mode contribute the most to overall sales?
WITH ship_mode_sales AS (
    SELECT sm.ship_mode ship_mode_name
          ,SUM(o.sales) total_sales
    FROM fact_order o
    JOIN dim_ship_mode sm
    ON o.ship_mode_key =sm.ship_mode_key
    GROUP BY sm.ship_mode
)
SELECT  ship_mode_name
       ,total_sales
       ,SUM(total_sales) OVER() overall_sales
       ,ROUND((CAST(total_sales AS FLOAT)/ SUM(total_sales) OVER())*100 ,2) psc_of_total
FROM ship_mode_sales
ORDER BY total_sales 

--03.Which customer segment contribute the most to overall sales?
WITH customer_sales AS (
    SELECT c.segment customer_segment
          ,SUM(o.sales) total_sales
    FROM fact_order o
    JOIN dim_customer c 
    ON o.customer_key =c.customer_key
    GROUP BY c.segment
)
SELECT  customer_segment
       ,total_sales
       ,SUM(total_sales) OVER() overall_sales
       ,ROUND((CAST(total_sales AS FLOAT)/ SUM(total_sales) OVER())*100 ,2) psc_of_total
FROM customer_sales
ORDER BY total_sales