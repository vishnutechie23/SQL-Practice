/*
LEFT JOIN : Returns all the rows from left & only matching from right
*/

-- Get all customers along with their orders, including those without orders
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id 

-- THE ORDER of table is IMP 
/*
Syntax: SELECT * 
		FROM table_A  <--- (left) 
		LEFT JOIN table_B  <--- (Right)
		ON table_A.key = table_B.key 
*/