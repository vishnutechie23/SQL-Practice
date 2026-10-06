-- Static (fixed) value 

SELECT 1234 AS static_number

SELECT 'HELLO VISHNU' AS static_string

-- so here we can take some data from database and also add some static data
SELECT 
	id,
    first_name,
    'New Customers' AS Customer_type
FROM customers
-- Here you can also highlight Query which you want and execute 