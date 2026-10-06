/*
SQL FUNCTIONS : 

(Row-level calculations)			(aggregations)
single row functions				multi row functions

--> string							--> aggregate
--> NUmeric							--> Window
--> Date & time
--> Null
*/

/*
STRING FUNCTION's

MANIPULATION		calculation			String Extraction

CONCAT				LEN					LEFT	
UPPER									RIGHT
LOWER									SUBSTRING
TRIM
REPLACE
*/

-- CONCAT : combines multiple strings into one

-- show the list of customres : first names together with their country in one column 

SELECT 
	first_name,
	country,
CONCAT(first_name,'-',country) AS name_country
FROM customers