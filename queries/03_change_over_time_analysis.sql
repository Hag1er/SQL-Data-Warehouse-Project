
--Change Over Time Analysis
--         Query purpose:
--         -For time-series analysis 

--01.Monthly sales trend
CREATE PROCEDURE sp_monthly_sales_trend 
           @start_year INT
           ,@end_year INT
AS 
BEGIN
SELECT  d.year order_year
       ,d.month order_month
       ,SUM(o.sales) total_sales 
       ,SUM(o.quantity) total_quantity
       ,COUNT(DISTINCT c.customer_id) total_customers
FROM fact_order o
JOIN dim_date d
ON o.ship_date_key=d.date_key
JOIN dim_customer c
 ON o.customer_key = c.customer_key
WHERE d.year BETWEEN @start_year AND @end_year
GROUP BY year,d.month
ORDER BY order_year
END

--01.2.extract the output
EXEC sp_monthly_sales_trend @start_year= 2013,@end_year=2017

--02.Month-Over-Month (MoM)
SELECT  d.month order_month
       ,SUM(o.sales ) total_sales
       ,LAG(SUM(o.sales )) OVER (ORDER BY d.month) prev_month
       ,SUM(o.sales ) - LAG(SUM(o.sales )) OVER (ORDER BY d.month) month_change
FROM fact_order o
JOIN dim_date d
ON o.ship_date_key=d.date_key 
GROUP BY d.month


--03.Yearly sales trend
SELECT  year order_year
       ,SUM(o.sales) total_sales 
       ,SUM(o.quantity) total_quantity
       ,COUNT(DISTINCT c.customer_id) total_customers
FROM fact_order o
JOIN dim_date d
ON o.ship_date_key=d.date_key
JOIN dim_customer c
 ON o.customer_key = c.customer_key
GROUP BY year
ORDER BY order_year

--04.Year-Over-Year (YOY) growth by category
SELECT d.year order_year
       ,p.category
       ,SUM(o.sales) total_sales
       ,LAG(SUM(o.sales)) OVER(PARTITION BY p.category ORDER BY d.year) prev_year_sales
       ,SUM(o.sales) -LAG(SUM(o.sales)) OVER(PARTITION BY p.category ORDER BY d.year) diff_cy
FROM fact_order o
JOIN dim_date d
 ON o.ship_date_key=d.date_key 
JOIN dim_product p
 ON o.product_key = p.product_key
GROUP BY d.year 
        ,p.category
ORDER BY category , order_year
 
--05.Year-Over-Year (YOY) growth in each state
SELECT d.year order_year
        ,l.state 
        ,SUM(o.sales) total_sales
        ,LAG(SUM(o.sales)) OVER(PARTITION BY l.state ORDER BY d.year) prev_year_sales
        ,SUM(o.sales) -LAG(SUM(o.sales)) OVER(PARTITION BY l.state ORDER BY d.year) diff_sy
FROM fact_order o
JOIN dim_date d
    ON o.ship_date_key=d.date_key
JOIN dim_location l
    ON o.location_key = l.location_key
GROUP BY d.year 
        ,l.state
ORDER BY  state,order_year

--06.For each year, which quarter & month recorded the highest total sales?
WITH monthly_sales AS (
    SELECT  d.year order_year
           ,d.month order_month
           ,d.month_name 
           ,SUM(o.sales) total_sales
           ,d.quarter order_quarter 
           ,row_number() OVER(PARTITION BY d.year ORDER BY SUM(o.sales) DESC) as rnk
    FROM fact_order o
    JOIN dim_date d
    ON o.ship_date_key=d.date_key 
    GROUP BY d.year,d.month ,d.quarter,d.month_name
)
SELECT order_year
       ,order_quarter
       ,order_month
       ,month_name
       ,total_sales
FROM monthly_sales
WHERE rnk =1
ORDER BY order_year












