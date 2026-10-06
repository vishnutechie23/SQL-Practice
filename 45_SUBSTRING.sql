-- SUBSTRING : Extracts a part of string at a specified position
-- SUBSTRING(value,start,len)

-- Retrieve a list of customer's firstname after removing first character
SELECT first_name,
SUBSTRING(TRIM(first_name),2,LEN(first_name)) AS after_substring
FROM customers