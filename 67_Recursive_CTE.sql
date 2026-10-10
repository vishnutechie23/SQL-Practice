/*
CTE (Common Table Expression)

Definition:
A CTE is a temporary, named result set that can be used multiple times
within a single SQL statement.

Advantages of CTE:
1. Readability:
   Breaks down complex queries into smaller pieces.

2. Modularity:
   Makes queries easier to manage, develop, and maintain.

3. Reusability:
   Helps avoid repeating the same query logic within a query.

4. Recursive:
   Supports recursive operations, such as working with hierarchical
   data using recursive CTEs.

Important Notes:
- A CTE behaves like a temporary result set, similar to a table.
- A CTE is available only to the single SQL statement immediately
  following its definition.
- A CTE cannot be directly reused across multiple separate queries.
- CTEs do not automatically store results permanently.

Tip:
Try to keep the number of CTEs manageable (for example, 5 or fewer)
to maintain readability. This is a guideline, not a SQL Server rule.
*/

-- Recursive CTE : Self-referncing query that repeateddly process data until a specific condition is met (use : Hierarchy) 

-- Generate a sequence of Number from 1 to 20 

WITH Series AS (
-- Anchor Query
SELECT 1 AS MyNumber
UNION ALL
-- Recursive query
SELECT 
MyNumber + 1
FROM Series
WHERE MyNumber < 10
)
-- Main query
SELECT *
FROM Series
OPTION (MAXRECURSION 10);

-- Task : Show the employee hierarchy by displaying each employee's level within the organisation
WITH CTE_Emp_Hierarchy AS 
(
	-- Anchor query 
	SELECT 
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Level
	FROM Sales.Employees
	WHERE ManagerID IS NULL
	UNION ALL 
	-- Recursive query
	SELECT 
		e.EmployeeID,
		e.FirstName,s
		e.ManagerID,
		Level + 1
	FROM Sales.Employees e
	INNER JOIN CTE_Emp_Hierarchy ceh
	ON e.ManagerID = ceh.EmployeeID
)
-- Main query
SELECT *
FROM CTE_Emp_Hierarchy