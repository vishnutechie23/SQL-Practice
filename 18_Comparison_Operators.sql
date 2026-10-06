-- COMPARISON OPERATORS 
/*
=
<>/!=
>
>=
<
<=
*/

-- = : Checks if two values are equal 
-- 1.show all customers from germany
SELECT * FROM customers
WHERE country = 'Germany'


-- <> / != : Checks if two values are not equal
-- 1.show all customers from germany
SELECT * FROM customers
WHERE country != 'Germany'
-- WHERE country <> 'Germany' : another way 


-- > : Checks if value is greater than another value
-- 1.show customers wit a score greater than 500 
SELECT * FROM customers
WHERE score > 500


-- >= : Checks if value is greater than or equal to another value
-- 1.show customers with a score  500 or more
SELECT * FROM customers
WHERE score >= 500


-- < : Checks if value is less than another value
-- 1.show customers with a score less than 500 
SELECT * FROM customers
WHERE score < 500


-- <= : Checks if value is less than or equal to another value
-- 1.show customers with a score 500 or less
SELECT * FROM customers
WHERE score <= 500