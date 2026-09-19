
--Magnitude & Ranking Analysis
--         Query purpose:
--         -to dive more in the data and find useful insights
--         -ranking and find the the factorse that effect in the sales and profit


------ Magnitude Analysis
-- 01.total customers by state 
SELECT  l.state 
       ,COUNT(c.customer_id) AS customers_count
FROM fact_order o
JOIN dim_customer c
ON o.customer_key =c.customer_key
JOIN dim_location l
ON o.location_key =l.location_key
GROUP BY l.state
ORDER BY customers_count DESC

-- 02.total customers by city 
SELECT l.city 
       ,COUNT(c.customer_id) AS customers_count
FROM fact_order o
JOIN dim_customer c
ON o.customer_key =c.customer_key
JOIN dim_location l
ON o.location_key =l.location_key
GROUP BY l.city
ORDER BY customers_count DESC

-- 03.total products by category
SELECT category
       ,COUNT(product_id) products_count 
FROM dim_product 
GROUP BY category

-- 04.Total sales for each category
SELECT  DISTINCT p.category 
       ,SUM(o.sales) total_sales
FROM fact_order o
JOIN dim_product p
ON o.product_key = p.product_key
GROUP BY  p.category 
ORDER BY  total_sales DESC

-- 05.Total sales for each customer 
SELECT  DISTINCT c.customer_id 
       ,c.customer_name
       ,SUM(o.sales) total_sales
FROM fact_order o
LEFT JOIN dim_customer c
ON o.customer_key = c.customer_key
GROUP BY  c.customer_id 
         ,c.customer_name
ORDER BY  total_sales DESC

-- 06.total_sold_items for each sub-category & category
SELECT  DISTINCT p.category
       ,p.sub_category 
       ,SUM(o.quantity) OVER(PARTITION BY p.sub_category) total_sold_items
FROM fact_order o
JOIN dim_product p
ON o.product_key = p.product_key

-- 07.What is the distribution of sold items across states?
SELECT  l.state 
       ,SUM(o.quantity) as total_sold_items
FROM fact_order o
JOIN dim_location l
ON o.location_key =l.location_key
GROUP BY l.state
ORDER BY total_sold_items DESC

------ RANKING ANALYSIS :-

-- 08.what is top 5 products Generating the Highest Sales and its category?
SELECT TOP 5 
          p.product_name
          ,p.category
         ,SUM(o.sales) total_sales
FROM fact_order o
JOIN dim_product p
ON o.product_key = p.product_key
GROUP BY p.product_name ,p.category
ORDER BY total_sales DESC

-- 09.what are top 5 customers Generating the Highest Sales and its state?
WITH customers_ranking AS
(
SELECT  c.customer_name 
       ,c.customer_id 
       ,SUM(o.sales) total_sales
       ,RANK() OVER (ORDER BY SUM(o.sales) DESC) rank_customers
       ,o.location_key
FROM fact_order o
JOIN dim_customer c
ON o.customer_key = c.customer_key
GROUP BY c.customer_name ,o.location_key ,c.customer_id
)
  SELECT customer_id
       ,customer_name
       ,l.state
       ,total_sales
  FROM customers_ranking cr
  JOIN dim_location l
  ON  cr.location_key =l.location_key
  WHERE rank_customers <= 5

--10.What are the 5 worst-performing products that generate the lowest revenue?
SELECT TOP 5
        p.product_id
       ,p.product_name
       ,SUM(o.sales) total_sales
FROM fact_order o
JOIN dim_product p
ON o.product_key =p.product_key
GROUP BY p.product_id
        ,p.product_name
ORDER BY total_sales
















