--performance analysis
 --Query purpose:
 -- - measure the performance of products, customers, or locations over time



--01.category performance by profit margin
SELECT p.category
      ,CAST(ROUND(SUM(o.profit) /SUM(o.sales)* 100, 2) AS DECIMAL (10,2)) profit_margin_pct
      ,RANK() OVER (ORDER BY SUM(o.profit) / SUM(o.sales) DESC) profit_margin_rank
FROM fact_order o
JOIN dim_product p
ON o.product_key = p.product_key
GROUP BY p.category
ORDER BY profit_margin_rank

--02.sub-category performance by profit margin
SELECT p.sub_category
      ,CAST(ROUND(SUM(o.profit) /SUM(o.sales)* 100, 2) AS DECIMAL (10,2)) profit_margin_pct
      ,RANK() OVER (ORDER BY SUM(o.profit) / SUM(o.sales) DESC) profit_margin_rank
FROM fact_order o
JOIN dim_product p
ON o.product_key = p.product_key
GROUP BY p.sub_category
ORDER BY profit_margin_rank

--03.TOP 5 customers by profit
SELECT  TOP 5  
        c.customer_id
       ,c.customer_name
       ,SUM(o.profit) total_profit
FROM fact_order o
JOIN dim_customer c
ON o.customer_key=c.customer_key
GROUP BY c.customer_id
        ,c.customer_name
ORDER BY total_profit DESC

--04.product performance by year 
SELECT  d.year order_year
       ,p.product_name
       ,SUM(o.sales) current_sales
       ,AVG(SUM(o.sales)) OVER (PARTITION BY product_name) avg_sales
       ,CASE 
           WHEN SUM(o.sales) >AVG(SUM(o.sales)) OVER (PARTITION BY p.product_name) THEN 'above avg'
           WHEN SUM(o.sales) < AVG(SUM(o.sales)) OVER (PARTITION BY p.product_name) THEN 'below avg'
           ELSE 'avg'
        END AS average_change 
        -- yearly change
        ,LAG(SUM(o.sales)) OVER(PARTITION BY product_name ORDER BY d.year) prev_sales 
        ,CASE 
           WHEN SUM(o.sales)  > LAG(SUM(o.sales) ) OVER(PARTITION BY p.product_name ORDER BY d.year) 
               THEN 'increase'
           WHEN SUM(o.sales)  < LAG(SUM(o.sales) ) OVER(PARTITION BY p.product_name ORDER BY d.year)
               THEN 'decrease'
           ELSE 'no change'
        END AS sales_change 
FROM fact_order o
    JOIN dim_product p
    ON o.product_key = p.product_key
    JOIN dim_date d
    ON o.order_date_key =d.date_key
    GROUP BY d.year
            ,p.product_name
ORDER BY product_name,order_year

--05.cities performance
SELECT  d.year order_year
       ,l.city 
       ,SUM(o.sales) current_sales
       ,LAG(SUM(o.sales)) OVER(PARTITION BY l.city ORDER BY  d.year) prev_sales
       ,ROUND((SUM(o.sales) -LAG(SUM(o.sales)) OVER(PARTITION BY l.city ORDER BY  d.year))
             /LAG(SUM(o.sales)) OVER(PARTITION BY l.city ORDER BY d.year) *100,2) growth_pct
       ,CASE 
         WHEN SUM(o.sales) < LAG(SUM(o.sales)) OVER(PARTITION BY l.city  ORDER BY  d.year) 
           THEN 'dropped'
         WHEN SUM(o.sales) > LAG(SUM(o.sales)) OVER(PARTITION BY l.city  ORDER BY  d.year) 
           THEN 'growing'
        ELSE 'first_sales_year'
        END AS cities_status
FROM fact_order o
JOIN dim_location l
    ON o.product_key = l.location_key
JOIN dim_date d
    ON o.order_date_key =d.date_key
GROUP BY d.year,l.city












