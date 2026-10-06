-- 1.DELETE all customeres who's id is greater than 5
-- Without WHERE all rows will be updated

DELETE FROM customers
WHERE id > 5;

SELECT * FROM customers WHERE id > 0;
SELECT * FROM customers

-- 2.Delete  all data from table persons
TRUNCATE TABLE persons;
SELECT * FROM persons

-- TRUNCATE : Clears whole table at once without checking or logging 
-- Faster than delete 