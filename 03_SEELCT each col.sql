-- SHOW each customer name,country and score 
USE MyDatabase

SELECT *
FROM customers

-- if you change order then table will also change it's order :
SELECT 
	first_name,
	country,
	score
FROM customers
