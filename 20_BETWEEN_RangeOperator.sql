-- BETWEEN : check if value is within a range
-- show all customers who's range is between 100 to 500

SELECT * FROM customers
WHERE score BETWEEN 100 and 500

-- With comparision operator
SELECT * FROM customers
WHERE score >= 100 AND score <= 500

-- TIP : Explicit comparisons clearly show that both boundaries are inlcuded
