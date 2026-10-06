-- INNER JOIN : Returns only matching Rows from both tables 

-- Get all customers along with their orders but only for customers who have placed an order
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id 

-- Column ambiguity : add the table name before the column to avoid confusion in joins with same named columns
