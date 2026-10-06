/*
RIGHT JOIN : Returns all the rows from RIGHT & only matching from LEFT
*/

-- Get all customers along with their orders, including orders without matching customers
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id ;

-- THE ORDER of table is IMP 
/*
Syntax: SELECT * 
		FROM table_A  <--- (right) 
		RIGHT JOIN table_B  <--- (left)
		ON table_A.key = table_B.key 
*/

-- Solve same question with left join 

SELECT 
	c.id,
	c.first_name,
	o.order_date,
	o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id