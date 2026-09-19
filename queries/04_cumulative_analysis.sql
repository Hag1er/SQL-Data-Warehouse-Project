
--Cumulative Analysis
--  Query purpose:
--   -calculate running total , moving_average_price and month moving average of profit 
--    for key metrics and track performance over time


--01.Running total of sales by year & moving_average_price
SELECT order_date
       ,total_sales
       ,SUM(total_sales) OVER(ORDER BY order_date) running_total
       ,CAST(ROUND(AVG(avg_unit_price) OVER(ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2)
         AS DECIMAL(10,2) ) moving_average_price
FROM (
    SELECT  DATETRUNC(YEAR,d.full_date) order_date
           ,SUM(o.sales) total_sales
           ,AVG(o.sales / o.quantity) avg_unit_price
    FROM fact_order o
    JOIN dim_date d
      ON o.order_date_key = d.date_key
    GROUP BY  DATETRUNC(YEAR,d.full_date) 
)s
ORDER BY order_date

--02.moving average of profit by month
SELECT order_month
       , avg_monthly_profit
       ,SUM( avg_monthly_profit) OVER(ORDER BY order_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) profit_moving_average
FROM (
    SELECT  d.month order_month
           ,SUM(o.profit) avg_monthly_profit
    FROM fact_order o
    JOIN dim_date d
      ON o.order_date_key = d.date_key
    GROUP BY  d.month
)s
ORDER BY order_month

