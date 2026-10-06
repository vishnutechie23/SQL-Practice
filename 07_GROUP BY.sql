-- GROUP BY : Aggregate your data 
-- Combines rows with same value
-- aggregates a column by another column

-- EX : Find total score for each country
-- AS : 
SELECT 
	country,
	first_name,
	SUM(score) AS sum_score
FROM customers
GROUP BY country,first_name

--Find the total score and total number of customers for each country
SELECT 
	country,
	SUM(score) AS sum_score,
	COUNT(id) AS total_customers
FROM customers
GROUP BY country
