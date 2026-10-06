-- LEFT : Extracts specific no. of characters from the start 
-- RIGHT : Extracts specific no. of characters from the end

-- Retrieve the first two characters of each first name
SELECT 
	first_name,
    LEFT(TRIM(first_name), 2) AS first_2_char
FROM customers;

-- Retrieve the last two characters of each first name
SELECT 
	first_name,
    LEFT(TRIM(first_name), 2) AS first_2_char,
    RIGHT(TRIM(first_name),2) AS last_2_char
FROM customers