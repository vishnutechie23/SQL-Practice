/*
RIGHT ANTI JOIN : Returns rows from right that has NO MATCH in left 
@The order of table is imp
syntax: SELECT *
		FROM A
		RIGHT JOIN B
		ON A.key = B.key
		WHERE A.key IS NULL
*/
-- Get all orders without matching customers

select * 
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL;

-- Solve same with left join
SELECT * 
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id = c.id
WHERE c.id IS NULL