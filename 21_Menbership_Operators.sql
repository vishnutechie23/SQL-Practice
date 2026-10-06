/*
MEMBERSHIP OPERATORS : IN, NOT IN
IN : Check if value exists in a list
NOT IN : Check if value not exists 
*/

SELECT * FROM customers
WHERE country = 'Germany' OR country = 'USA'

-- with IN Operator 
SELECT * FROM customers
WHERE country IN ('Germany' ,'USA')

-- with NOT IN 
SELECT * FROM customers
WHERE country NOT IN ('UK' ,'USA')

-- TIP : Use IN instead of OR for multiple values in the same column to simplify SQL 