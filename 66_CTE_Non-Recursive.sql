-- CTE : COMMON TABLE EXPRESSION
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
-- Temporaray named result set(Virtual tables) that can be used multiple times within your query to simply and organize your query
-- why to use : READABILITY , MODULARITY, REUSABILITY

-- CTE Types None-Recursive -- 1) STANDALONE CTE, 2)Nested CTE
-- 			 Recursive CTE  

-- Non-Recursive CTE : is executed only once without any repetition

-- Standalone CTE : Defined & used independently Runs independently as it's self-contained & doesn't rely on other CTE's or Queries

-- Step 1 : Find total sales per customer
-- RULE : You cannot use ORDER BY Directly within the CTE 
WITH CTE_Total_Sales AS
(
SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
),
-- Mutltiple standalone CTE
-- Step 2 : Find last order date for each customer
CTE_Last_Order AS
(
SELECT 
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID 
)
-- Step 3 : Rank Customer based on total sales per customers
, CTE_Customer_Rank AS 
(
SELECT
CustomerID,
TotalSales,
RANK() OVER (ORDER BY TotalSales DESC) AS CustomeRank
FROM CTE_Total_Sales
)
-- Step 4 : Segment customer based on their total sales (Nested CTE)
, CTE_Customer_Segments AS 
(
SELECT
CustomerID,
CASE WHEN TotalSales > 100 THEN 'High'
	 WHEN TotalSales > 80 THEN 'Medium'
	 ELSE 'Low'
END CustomerSegments
FROM CTE_Total_Sales
)

-- Main query
SELECT 
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
cto.Last_Order,
ccr.CustomeRank,
css.CustomerSegments
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order cto
ON cto.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ccr
ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segments css 
ON css.CustomerID = c.CustomerID


-- Best Practice 
-- Rethinkk & refactor you CTE's Before starting a new one
-- Don't Use more than 5 CTE's In one query otherwise your code will be hard to understand & maintain
