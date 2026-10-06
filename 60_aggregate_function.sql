-- Aggregate Functions  
-- Find total no. of orders
SELECT 
customer_id,
COUNT(*) AS Total_no_order,
-- Find total sales of all orders
SUM(sales) AS Total_sales,	
AVG(sales) AS AVg_sales,
MAX(sales) AS High_sales,
MIN(sales) AS Min_sales
FROM orders
GROUP BY customer_id