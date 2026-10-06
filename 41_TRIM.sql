-- TRIM() : Removes leading & trailing spaces

-- Find customers who's firstname contains leading anad trailing spaces

SELECT 
	first_name,
	LEN(first_name) len_name,
	LEN(TRIM(first_name)) len_after_trim,
	LEN(first_name) - LEN(TRIM(first_name)) space_value
FROM customers
-- WHERE LEN(first_name) <> LEN(TRIM(first_name))
-- WHERE first_name != TRIM(first_name)