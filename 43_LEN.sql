-- LEN : counts how many charcters
-- calculate the length of each customer's firstname

SELECT 
	first_name,
	LEN(first_name) AS len_firstname
FROM customers