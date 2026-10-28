/*
Performance Tips : For small-medium tables, the query optimizer may react similarly to diff query style
GOLDEN RULE : Always check the execution plan to confirm performance improvement when optimizing your query
- If there is no improvement thenjust focus on readability
*/

-- Fetching DATA

--==========================================
-- TIP 1 : SELECT Only what you need 
--==========================================

-- Bad practice

SELECT * FROM Sales.customers

-- Good Practice

SELECT 
	CustomerID,FirstName,LastName
FROM Sales.Customers

--==========================================
-- TIP 2 : Avoid unnecessary DISTINCT and ORDERR BY
--==========================================

-- Bad Practice

SELECT DISTINCT
	FirstName
FROM Sales.Customers
ORDER BY FirstName

-- Good Practice

SELECT FirstName
FROM Sales.Customers 
-- Use only if it needed

--==========================================
-- TIP 3 : For Exploration Purpose, Limit Rows!
--==========================================

-- Bad Practice

SELECT 
	OrderID,
	Sales
FROM Sales.Orders

-- Good practice

SELECT TOP 10
	OrderID,
	Sales
FROM Sales.Orders

-- Filtering DATA

--==========================================
-- TIP 4 : Create non-clustered index on frequently used columns in WHERE clause
--==========================================

SELECT * FROM Sales.Orders WHERE OrderStatus = 'Delivered'
CREATE NONCLUSTERED INDEX idx_Orders_OrderStatus ON Sales.Orders(OrderStatus)

--==========================================
-- TIP 5 : Avoid applying functions to columns in WHERE clauses
-- Functions on columns can block index usage 
--==========================================

-- Ex 1)

-- Bad Practice
SELECT * FROM Sales.Orders
WHERE LOWER(OrderStatus) = 'delivered'

-- Good Practice

SELECT * FROM Sales.Orders
WHERE (OrderStatus) = 'Delivered'

-- Ex 2)

-- Bad Practice
SELECT *
FROM Sales.Customers
WHERE SUBSTRING(FirstName, 1, 1) = 'A'

-- Good Practice

SELECT * 
FROM Sales.Customers
WHERE FirstName LIKE 'A%'

-- Ex 3)

-- Bad practice
SELECT * FROM Sales.Orders
WHERE YEAR(OrderDate) = 2025

-- Good Practice
SELECT* FROM Sales.Orders
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31'


--==========================================
-- TIP 6 : Avoid leading wildcards as they prevent index usage
--==========================================

-- Bad practice
-- % Leading will not use index
SELECT * FROM Sales.Customers WHERE LastName LIKE '%Gold%'

-- Good Practice
SELECT * FROM Sales.Customers WHERE LastName LIKE 'Gold%'


--==========================================
-- TIP 7 : Use IN Instead of multiple OR Conditions
--==========================================

-- Bad practice
SELECT * FROM Sales.Orders WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3

-- Good Practice
SELECT * FROM Sales.Orders WHERE CustomerID IN (1, 2, 3)


--==========================================
-- TIP 8 : Understand The speed of Joins & Use INNER JOIN When possible
--==========================================

-- Best performance 
SELECT c.FirstName, o.OrderID FROM Sales.customers c INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- Slightly slower performance
SELECT c.FirstName, o.OrderID FROM Sales.customers c RIGHT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
SELECT c.FirstName, o.OrderID FROM Sales.customers c LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

-- Worst join
SELECT c.FirstName, o.OrderID FROM Sales.customers c OUTER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID

--==========================================
-- TIP 9 : Use explicit Join (ANSI join) Instead of Implicit Join (Non ANSI Join)
--==========================================

-- Bad practice
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c, Sales.Orders o
WHERE c.CustomerID = o.CustomerID

-- Good practice
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

--==========================================
-- TIP 10 : Make sure to index the columns used in the ON clause
--==========================================

SELECT c.FirstName, o.OrderID
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON c.CustomerID = o.customerID

CREATE NONCLUSTERED INDEX IX_Orders_CustomerID ON Sales.Orders(CustomerID)

--==========================================
-- TIP 11 : Filter before index (Big tables)
--==========================================

-- Filter After join (WHERE) : For small & medium size tables
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderStatus = 'Delivered'

-- Filter During JOIN (ON)
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
AND o.OrderStatus = 'Delivered'

-- Filter Before Join (SUBQUERY) : For large table
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
INNER JOIN (SELECT OrderID, CustomerID FROM Sales.Orders WHERE OrderStatus = 'Delivered') o -- Try to isolate the preparation step in a CTE or subquery
ON c.CustomerID = o.customerID

--==========================================
-- TIP 12 : Aggregate before joining (Big tables)
--==========================================

-- Best Practice for small-medium Tables
-- Grouping and joining
SELECT c.CustomerID, c.FirstName, COUNT(o.OrderID) AS OrderCount
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName

-- Best practiec for Big tables
-- Pre-aggregated subquery
SELECT c.CustomerID, c.FirstName, o.OrderCount
FROM Sales.Customers c
INNER JOIN (
	SELECT CustomerID, COUNT(OrderID) AS OrderCount
	FROM Sales.Orders
	GROUP BY CustomerID
) o
ON c.CustomerID = o.CustomerID

-- Bad practice
-- Corelated  subquery (Coreleted queries are inefficient cuz SQL execute aggregations for every row)
SELECT
	c.CustomerID,
	c.FirstName,
	(SELECT COUNT(o.OrderID)
	FROM Sales.Orders o
	WHERE o.CustomerID = o.CustomerID) AS OrderCount
FROM Sales.Customers c


--==========================================
-- TIP 13 : Use Union Instead of OR in Joins
--==========================================

-- Bad practice

SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OR c.CustomerID = o.SalesPersonID

-- Best practice

SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
UNION
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.SalesPersonID

--==========================================
-- TIP 14 : Check for Nested loops & Use SQL HIINTS
--==========================================

SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID

-- Good practice for having big table and small table
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
OPTION (HASH JOIN)

--==========================================
-- TIP 15 : Use UNION ALL instead of using UNION | duplicates are acceptable
--==========================================

-- Bad practice
SELECT CustomerID FROM Sales.Orders
UNION
SELECT CustomerID FROM Sales.OrdersArchive

-- Best Practice
SELECT CustomerID FROM Sales.Orders
UNION ALL
SELECT CustomerID FROM Sales.OrdersArchive

--==========================================
-- TIP 16 : USe UNION ALL + DISTINCT instead of using UNION | duplicates are not acceptable
--==========================================

-- Bad practice
SELECT CustomerID FROM Sales.Orders
UNION 
SELECT CustomerID FROM Sales.OrdersArchive

-- Best pratice
SELECT DISTINCT CustomerID
FROM (
	SELECT CustomerID FROM Sales.Orders
	UNION ALL
	SELECT CustomerID FROM Sales.OrdersArchive
	) AS CombineData


--==========================================
-- Aggregating DATA
-- TIP 17 : Use Columnstore (compress) index for aggregation large table 
--==========================================

SELECT CustomerID, COUNT(OrderID) AS OrderCount
FROM Sales.Orders
GROUP BY CustomerID

CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_Columnstore ON Sales.Orders

-- show all indexes
EXEC sp_helpindex 'Sales.Orders';

-- make copy
SELECT *
INTO Sales.Orders_Columnstore
FROM Sales.Orders;

CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_Columnstore ON Sales.Orders_Columnstore;

SELECT COUNT(*)
FROM Sales.Orders_Columnstore;

EXEC sp_helpindex 'Sales.Orders_Columnstore';

CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_Columnstore ON Sales.Orders_Columnstore;



-- Memory check
SELECT
    name,
    value_in_use
FROM sys.configurations
WHERE name IN (
    'max server memory (MB)',
    'min server memory (MB)',
    'max degree of parallelism'
);

-- version check 
SELECT @@VERSION;

SELECT
    total_physical_memory_kb / 1024 AS TotalRAM_MB,
    available_physical_memory_kb / 1024 AS AvailableRAM_MB,
    system_memory_state_desc
FROM sys.dm_os_sys_memory;

SELECT
    physical_memory_in_use_kb / 1024 AS SQL_Memory_Used_MB,
    available_commit_limit_kb / 1024 AS Available_Commit_Limit_MB,
    process_physical_memory_low,
    process_virtual_memory_low
FROM sys.dm_os_process_memory;


--==========================================
-- TIP 18 : Pre-Aggregate Data and store it in new Table for Reporting
--==========================================

SELECT MONTH(OrderDate) OrderYear, SUM(Sales) AS TotalSales
INTO Sales.SalesSummary
FROM sales.Orders
GROUP BY MONTH(OrderDate)

SELECT OrderYear, TotalSales FROM Sales.SalesSummary


--==========================================
-- SUBQUERIES
-- TIP 19 : JOIN vs EXISTS vs IN
--==========================================

-- EXISTS bettern tahn JOIN cuz it stops at first match & avoid data duplication

-- JOIN (Best practice if the performance is equal  to EXISTS)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA'

-- EXISTS (BEst practice : Use it for large tables)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE EXISTS (
	SELECT 1 
	FROM Sales.Customers c
	WHERE c.CustomerID = o.CustomerID
	AND c.Country = 'USA'
)

-- IN (Bad practice) : The IN operator processes & evaluates all rows. It lacks an early exit mechanism
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE o.CustomerID IN (
	SELECT CustomerID
	FROM Sales.Customers
	WHERE Country = 'USA'
	)

--==========================================
-- TIP 20 : Avoid Redundant Logic in your query
--==========================================

-- Bad practice
SELECT EmployeeID, FirstName, 'Above Average' Status
FROM Sales.Employees
WHERE Salary > (SELECT AVG(Salary) FROM Sales.Employees )
UNION ALL
SELECT EmployeeID, FirstName, 'Below Average' Status
FROM Sales.Employees
WHERE Salary < (SELECT AVG(Salary) FROM Sales.Employees)
ORDER BY EmployeeID

-- Good practice
SELECT
	EmployeeID,
	FirstName,
	CASE 
		WHEN Salary > AVG(Salary) OVER() THEN 'Above Average'
		WHEN Salary < AVG(Salary) OVER() THEN 'Below Average'
		ELSE 'Average'
	END AS Status
FROM Sales.Employees


-- Creating tables 
-- table

CREATE TABLE CustomersInfo (
	CustomerID INT,
	FirstName VARCHAR(MAX),
	LastName TEXT,
	Country VARCHAR(255),
	TotalPurchases FLOAT,
	Score VARCHAR(255),
	Birthdate VARCHAR(255),
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employees(EmployeeID)

-- TIP 21 : Avoid using VARCHAR & TEXT : VARCHAR is better than TEXT

CREATE TABLE CustomersInfo (
	CustomerID INT,
	FirstName VARCHAR(MAX),
	LastName VARCHAR(50),
	Country VARCHAR(255),
	TotalPurchases FLOAT,
	Score INT,
	Birthdate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employees(EmployeeID)
)

-- TIP 22 : Avoid using (MAX) Unnecessarily large lengths in data types
CREATE TABLE CustomersInfo (
	CustomerID INT,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Country VARCHAR(50),
	TotalPurchases FLOAT,
	Score INT,
	Birthdate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employees(EmployeeID)
)

-- TIP 23 : Use the NOT NULL Constraint where applicable
CREATE TABLE CustomersInfo (
	CustomerID INT,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	TotalPurchases FLOAT,
	Score INT,
	Birthdate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employees(EmployeeID)
)

-- TIP 24 : Ensure all your tables have a clustered PK
CREATE TABLE CustomersInfo (
	CustomerID INT PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Country VARCHAR(50),
	TotalPurchases FLOAT,
	Score INT,
	Birthdate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employees(EmployeeID)
)

-- TIP 25 : Create Non-Clustered index for foreign keys that are used frequently

CREATE TABLE CustomersInfo (
	CustomerID INT PRIMARY KEY CLUSTERED,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	Country VARCHAR(50),
	TotalPurchases FLOAT,
	Score INT,
	Birthdate DATE,
	EmployeeID INT,
	CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
		REFERENCES Sales.Employees(EmployeeID)
)

CREATE NONCLUSTERED INDEX IX_CustomersInfo_EmployeeID ON CustomersInfo(EmployeeID)


-- INDEXING
-- TIP 26 : Avoid over indexing
-- TIP 27 : Drop unused indexes
-- TIP 28 : Update statistics (weekly)
-- TIP 29 : reorganize & rebuild Indexes (weekly)
-- TIP 30 : Partition large tables (Facts) to improve performance Next, apply a columnstore index for the best results

/*
Focus on writing clear queries
Optimize performance only when necessary
Always Test using Execution plan
*/
