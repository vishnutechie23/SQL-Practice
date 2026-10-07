-- SUB QUERIES :

/*
USE CASES OF SUBQUERIES
1. Create temporary result sets
2. Prepare data before joining tables
3. Dynamic & complex filtering
4. Check the existence of rows from another table (`EXISTS`)
5. Row-by-row comparison using correlated subqueries
*/

-- Scalar subquery
SELECT 
AVG(Sales)
FROM Sales.orders

-- Row subquery
SELECT 
CustomerID
FROM Sales.Orders

-- Table subquery
SELECT 
OrderID,
OrderDate
FROM Sales.Orders

-- Subquery in Location/clauses : SELECT, FROM, JOIN, WHERE --> COMparision/ logical operators
-- Subquery in FROM clause

-- Find the avg products that have price higher than the avg price of all products 

-- Main query
SELECT *
FROM (
--Subquery
SELECT 
ProductID,
Price,
AVG(Price) OVER() AvgPrice
FROM Sales.Products
) t 
WHERE Price > AvgPrice

-- Rank Customers based on their total amount of sales 
-- Main query
SELECT *,
RANK () OVER(ORDER BY TotalSales DESC) CustomeRank
FROM (
	SELECT
	CustomerID,
	SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID) t

-- Subquery in select clause 
-- RULE : Only scalar subquries are allowed to used
-- Show the product id, product name, prices and the total no of orders
-- Main query
SELECT 
	ProductID,
	Product,
	Price,
	-- Subquery
	(SELECT COUNT(*) FROM Sales.orders) AS TotalOrders
FROM Sales.Products;

-- JOIN Subquery : Used to prepare data(Filtering & aggreagations) before joining it with other table
-- Show all customer details and find total orders for each customers

-- Main query
SELECT 
c.*,
o.TotalOrders
FROM Sales.Customers c 
LEFT JOIN (
	SELECT 
	CustomerID,
	COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID 
	) o 
ON c.CustomerID = o.CustomerID

-- Subquery in WHERE clause : Used for complex filtering logic & makes query more flexible & dynamic
-- Comparision operators : Used to filter data by comparing two values
-- RULE : ONLY scalar subquery are allowed to be used

-- Find the products that having price higher than the price of avg of all pdts
SELECT 
ProductID,
Price,
(SELECT AVG(Price) FROM Sales.Products) AvgPrice
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

-- Logical operators : IN
-- Show the details of orders madae by customrs in germany
-- Main query
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany') -- Sub query

-- Show the details of orders madae by customrs not in germany
SELECT *
FROM Sales.Orders
WHERE CustomerID NOT IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany') -- Sub query

-- Sub query in ANY Operator : Check if it matches any value within the list
-- Find female emplooyes Whose salary are greater tahn the salaries of any male employyes
-- Main query
SELECT
EmployeeID,
FirstName,
Gender,
Salary
FROM Sales.Employees
WHERE Gender = 'F' 
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

SELECT FirstName,Salary FROM Sales.Employees WHERE Gender = 'M'

-- Sub query in ALL Operator : Check if it matches ALL value within the list
-- Find female emplooyes Whose salary are greater tahn the salaries of ALL male employyes
-- Main query
SELECT
EmployeeID,
FirstName,
Gender,
Salary
FROM Sales.Employees
WHERE Gender = 'F' 
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

SELECT FirstName,Salary FROM Sales.Employees WHERE Gender = 'M'

-- NON Corealated | Corelated Subquery
-- Non-Corelated : A subquery that can run independently from the main query
-- Corelated Subquery : A subquery that relays on values from the main query
-- Show all customres details and find total orders of each customers
SELECT *,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalSales
FROM Sales.Customers c

/*
| **Non-Correlated Subquery**                                   | **Correlated Subquery**                                    |
| ------------------------------------------------------------- | ---------------------------------------------------------- |
| Subquery is **independent** of the main query.                | Subquery is **dependent** on the main query.               |
| Executed **once**.                                            | Executed **for each row**.                                 |
| Can be executed **on its own**.                               | Cannot be executed **on its own**.                         |
| Easier to read and understand.                                | More complex to read and understand.                       |
| Usually better performance.                                   | Can have slower performance.                               |
| Used for **static comparisons** and filtering with constants. | Used for **row-by-row comparisons** and dynamic filtering. |
*/

-- EXISTS : Check if a subquery returns any row
-- SHow the details of orders made by customers in germany
-- Main query
SELECT
*
FROM Sales.Orders o
WHERE EXISTS (SELECT 1 FROM Sales.Customers c WHERE Country = 'Germany' AND o.CustomerID = c.CustomerID) -- Correlated subquery dependa on main query you can't run this seprately

-- SHow the details of orders made by customers NOT in germany
-- Main query
SELECT
*
FROM Sales.Orders o
WHERE NOT EXISTS (SELECT 1 FROM Sales.Customers c WHERE Country = 'Germany' AND o.CustomerID = c.CustomerID) 
