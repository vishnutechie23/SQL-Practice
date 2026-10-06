-- UNION :
-- Returns all DISTINCT rows from both queries
-- Removes duplicates rows frmo the results

-- combine all data from employees and customers into one table

SELECT 
	FirstName,
	LastName
FROM Sales.Customers
UNION
SELECT 
	FirstName,
	LastName
FROM Sales.Employees

