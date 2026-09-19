
 --Data Segmentation Analysis
 --  Query Purpose :
 --   - groups the data into segments like (customer segmentation, product categorization, 
 --                                            or Discount segmentation)


--01.product categorization (total number of products by each group)
WITH product_sales AS (
    SELECT p.product_id 
           ,SUM(o.sales) / SUM(o.quantity) unit_price
           ,SUM(o.sales) total_sales
           ,SUM(o.quantity) total_sold_items
           ,NTILE(4) OVER (ORDER BY SUM(o.quantity) DESC) sales_rnk
    FROM fact_order o
    JOIN dim_product p
    ON o.product_key = p.product_key
    GROUP BY p.product_id
)
SELECT   product_type_status
        ,product_sales_status
        ,COUNT(product_id) products_num
FROM (
     SELECT product_id
           ,unit_price
           ,CASE 
                WHEN unit_price <= 500 THEN 'cheap'
                WHEN unit_price BETWEEN 500 AND 1000 THEN 'mid'
               ELSE 'expensive'
               END AS product_type_status
            ,CASE 
                WHEN sales_rnk =1 THEN 'best_seller'
                WHEN sales_rnk =2 THEN 'good_seller'
                WHEN sales_rnk =2 THEN 'average_seller'
               ELSE 'low_seller'
               END AS product_sales_status
    FROM product_sales) products_segmented
GROUP BY  product_sales_status ,product_type_status
ORDER BY  product_type_status,product_sales_status 


--02.customer segmentation (total number of customers by each group)
WITH customers_segments AS (
    SELECT c.customer_id
           ,c.customer_name
           ,SUM(o.sales)  total_sales
           ,NTILE(3) OVER (ORDER BY SUM(o.sales) DESC) cus_segs
    FROM fact_order o
    JOIN dim_customer c
    ON o.customer_key = c.customer_key
    GROUP BY c.customer_id
           ,c.customer_name
)
SELECT customer_type
       ,COUNT(customer_id) total_customers
       ,SUM(total_sales) total_sales
FROM ( 
    SELECT customer_id
           ,customer_name
           ,total_sales
           ,CASE 
                WHEN cus_segs =1 THEN 'high_value'
                WHEN cus_segs =2 THEN 'mid_value'
               ELSE 'low_value'
               END AS customer_type
    FROM customers_segments
) AS segmented_customers
GROUP BY customer_type
ORDER BY total_customers


--03.Discount segmentation 
WITH discounts_segemnts AS (
SELECT  order_id
       ,sales
       ,profit
       ,CASE
         WHEN discount = 0 THEN 'no discount'
         WHEN discount <= 0.2 THEN '0:20'
         WHEN discount <= 0.5 THEN '20:50'
         WHEN discount <= 0.8 THEN '20:80'
         ELSE 'higher than 80'
         END AS disc_group
FROM fact_order
)
 SELECT disc_group
       ,COUNT(order_id) total_orders
       ,SUM(sales) total_sales
       ,SUM(profit) total_profit
FROM discounts_segemnts
GROUP BY disc_group
ORDER BY total_sales DESC














