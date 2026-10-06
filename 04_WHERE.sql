-- WHERE : FIlters our data based on condition 
-- EX : show customers with a score not equal to zero

SELECT *
FROM customers
WHERE SCORE != 0;

-- EX : SHOW customers from germany
SELECT 
	first_name,
	country
FROM customers
WHERE country = 'Germany'