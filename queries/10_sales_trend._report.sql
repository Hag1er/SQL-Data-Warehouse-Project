
--sales trends report

CREATE VIEW sales_trends_report AS
WITH base_query AS (
    SELECT d.year
          ,d.quarter
          ,d.month
          ,o.sales
          ,o.profit
    FROM fact_order o
    JOIN dim_date d
    ON o.order_date_key = d.date_key
) SELECT  year
       ,quarter
       ,month
       ,SUM(sales) total_sales
       ,SUM(SUM(sales)) OVER(ORDER BY year,month) running_total_sales
       ,LAG(SUM(sales )) OVER (ORDER BY year,month) prev_month_sales
       ,CASE 
           WHEN SUM(sales ) > LAG(SUM(sales )) OVER(ORDER BY year) 
               THEN 'increase'
           WHEN SUM(sales ) < LAG(SUM(sales )) OVER(ORDER BY year)
               THEN 'decrease'
           ELSE 'no change'
        END AS sales_change 
        ,ROUND((SUM(sales) - LAG(SUM(sales)) OVER (ORDER BY year, month))
        / LAG(SUM(sales)) OVER (ORDER BY year, month)* 100, 2) AS monthly_growth_pct
FROM base_query
GROUP BY year
        ,quarter
        ,month





















