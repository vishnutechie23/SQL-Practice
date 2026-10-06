-- UPDATE
-- ALWAYS USE WHERE : to avoid updating all rows inintentinally
-- 1. change the score of customer 9 to 900
UPDATE customers
SET score = 900
WHERE id = 9

SELECT * FROM customers
/* 
BEST PRCTICE : check with SELECT before running UPDATE to avoid updating the wrong data
SELECT *
FROM customers
WHERE id = 9
*/

-- 2. change the customer no.7 score to 0 and update country to USA
UPDATE customers
SET score = 0,
	country = 'USA'
WHERE id = 7

SELECT * FROM customers

-- 3. update all customers with a null score by setting them with a 0 
UPDATE customers
SET score = 0
WHERE score is NULL

SELECT * FROM customers 

