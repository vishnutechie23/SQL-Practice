-- LOGICAL OPERATORS
/*
AND : ALL conditions must be TRUE
OR : AT LEAST one condition must be TRUE
NOT : (REVERSE) Excludes matching values
*/

-- show all the customers who are from USA and have score greater than 500 

SELECT * FROM customers
WHERE (country = 'USA') AND (score > 500)

-- show all the customers who are either from USA or have score greater than 500 

SELECT * FROM customers
WHERE (country = 'USA') OR (score > 500)

-- Show all customers with score not less than 500 
SELECT * FROM customers
WHERE NOT score < 500


