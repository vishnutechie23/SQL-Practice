/*
CROSS JOIN : Combines every row from left with every row from right ALL possible combinations -cartersian join-
@The order of table doesn't matter
4 X 5 = 20 rows
Syntax: SELECT *
		FROM A
		CROSS JOIN B
*/
-- Generate all possible combinations of customers and orders

SELECT *
FROM customers
CROSS JOIN orders
