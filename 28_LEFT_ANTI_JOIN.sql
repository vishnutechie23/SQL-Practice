/*
ADVANCED JOINS :
LEFT ANTI JOIN : Returns row from left that has NO MATCH in right
@The order of the table is important
Syntax: SELECT * 
		FROM A
		LEFT JOIN B
		ON A.key = B.key
		WHERE B.key IS NULL 
*/
-- Get all customers who haven't placed any order

SELECT * FROM customers AS c 
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL 