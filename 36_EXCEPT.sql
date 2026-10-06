-- Find the employees who are not customers at same time 

/*
EXCEPT (minus) : Returns all distinct rows from the first query that are not found in the second query 
@It is only one where the order of queries affects final results

===> Returns unique rows in 1 st Table that are not in 2 nd Table
*/

SELECT 
	FirstName,
	LastName
FROM Sales.Customers
EXCEPT
SELECT 
	FirstName,
	LastName
FROM Sales.Employees