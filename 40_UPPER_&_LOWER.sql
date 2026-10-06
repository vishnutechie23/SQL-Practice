-- UPPER & LOWER : 
-- UPPER : Converts all charcters to UPPERCASE
-- LOWER : Converts all charcters to LOWERCASE

-- Qs 1 : Transform the customer's first name to lower case 
SELECT 
	first_name,
	country,
CONCAT(first_name,' ',country) AS name_country,
LOWER(first_name) AS low_name
FROM customers

-- Qs 2 : Transform the customer's first name to upper case 
SELECT 
	first_name,
	country,
CONCAT(first_name,' ',country) AS name_country,
LOWER(first_name) AS low_name,
UPPER(first_name) AS up_name
FROM customers