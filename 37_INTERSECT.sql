-- INTERSECT : Returns only the rows that are common in both queries 

-- Find the employye who are also customers 

SELECT 
	FirstName,
	LastName
FROM Sales.Employees
INTERSECT
SELECT
	FirstName,
	LastName
FROM Sales.Customers