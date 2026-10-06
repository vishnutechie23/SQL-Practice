/*
FULL JOIN : Returns all rows from both tables 
The order of table doesn't matter
syntax: SELECT *
		FROM A
		FULL JOIN B
		ON A.key = B.key 
*/

-- Get all customers and all orders even if there is no match 

SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id