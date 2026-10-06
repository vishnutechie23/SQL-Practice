/*
FULL ANTI JOIN : Returns only rows thta don't match in either tables
@The order of table doesn't matter
syntax: SELECT *
		FROM A
		FULL JOIN B
		ON A.key = B.key
		WHERE b.key IS NULL OR A.key IS NULL
*/
-- Find customers without orders and orders without customers

SELECT * 
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id 
-- first three are matching data 

SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL 



--Qs : Get all customres along with their orders, but only for customers who have placed an order without using inner join

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL
-- You can control what you want to see usnig where clause 
