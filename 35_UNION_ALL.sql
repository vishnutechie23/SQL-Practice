-- UNION ALL : -Returns all rows from both queries, including duplicates

-- UNION ALL vs UNION
-- if you're confident there is no duplicates use UNION ALL
-- use UNION ALL to find duplicates & quality issues

SELECT 
	FirstName,
	LastName
FROM Sales.Customers
UNION ALL 
SELECT 
	FirstName,
	LastName
FROM Sales.Employees