
-- VIEW : Virtual table based on the results set of query without storing the data in database views are persisted SQL queries in the database 
/*
VIews				Tables
NO persistance		Persisted Data
EAsy to maintain	Hard to maintain
Slow Response		Fast response
Read				Read/write
*/

-- 1)USECASE : Central Complex Query Logic
 
 -- Find runnig total of Sales for each month

 WITH CTE_Monthly_Summary AS (
	 SELECT
	 DATETRUNC(MONTH, OrderDate) OrderMonth,
	 SUM(Sales) TotalSales,
	 COUNT(OrderID) TotalOrders,
	 SUM(Quantity) TotalQuantites
	 FROM Sales.Orders
	 GROUP BY DATETRUNC(MONTH, OrderDate)
	 )
SELECT
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM CTE_Monthly_Summary;

-- VIEW : CREATE / UPDATE / DROP 

CREATE VIEW Sales.V_monthly_Summary AS 
(
	 SELECT
	 DATETRUNC(MONTH, OrderDate) OrderMonth,
	 SUM(Sales) TotalSales,
	 COUNT(OrderID) TotalOrders,
	 SUM(Quantity) TotalQuantites
	 FROM Sales.Orders
	 GROUP BY DATETRUNC(MONTH, OrderDate)
)

SELECT * FROM V_monthly_Summary

SELECT
OrderMonth,
TotalSales,
SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM V_monthly_Summary

-- IF table or View is created withpout Specifying schema, it defaults to the DBO
 
 -- To delete view : DROP
 DROP VIEW V_monthly_Summary;

 -- To update :
 -- CREATE OR REPLACE VIEW Sales.V_monthly_Summary AS  : In other databses but not in sql server 

 -- If you want to change some query inside view you can first drop and then again write new view 

 -- T-SQL : Transcript SQL is an extension of sql that adds programming features

 IF OBJECT_ID('Sales.V_monthly_Summary','V')  IS NOT NULL 
 DROP VIEW Sales.V_monthly_Summary;
 GO
 CREATE VIEW Sales.V_monthly_Summary AS 
(
	 SELECT
	 DATETRUNC(MONTH, OrderDate) OrderMonth,
	 SUM(Sales) TotalSales,
	 COUNT(OrderID) TotalOrders,
	 SUM(Quantity) TotalQuantites
	 FROM Sales.Orders
	 GROUP BY DATETRUNC(MONTH, OrderDate)
);

-- 2) USE CASE : HIde complexity : Views can be used to hide the complexity of database tables & offers users more friendly & easy-to-consume objects
-- TASK : provide view thta combines details from orders, products, customers, and employees

CREATE VIEW Sales.V_Order_Details AS (
	SELECT 
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.category,
	COALESCE(c.FirstName, ' ' ) + ' ' + COALESCE(c.LastName, ' ')	CustomerName,
	c.Country CustomerCountry,
	e.Department,
	COALESCE(e.FirstName, ' ' ) + ' ' + COALESCE(e.LastName, ' ')	SalesName,
	-- o.ProductID,
	-- o.CustomerID,
	-- o.SalesPersonID,
	o.Sales,
	o.Quantity

	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON p.ProductID = o.ProductID
	LEFT JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Employees e
	ON e.EmployeeID = o.SalesPersonID
)
-- CHECK :
SELECT * FROM Sales.V_Order_Details

-- 3) USECASE : DATA Security : Use views to enforce security and protect sensitive data, by hiding columns and/or rows from tables

-- Provide a view for EU Sales team that combines details from all tables and excludes data related to the USA 

CREATE VIEW Sales.V_Order_Details_EU AS (
	SELECT 
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.category,
	COALESCE(c.FirstName, ' ' ) + ' ' + COALESCE(c.LastName, ' ')	CustomerName,
	c.Country CustomerCountry,
	e.Department,
	COALESCE(e.FirstName, ' ' ) + ' ' + COALESCE(e.LastName, ' ')	SalesName,
	-- o.ProductID,
	-- o.CustomerID,
	-- o.SalesPersonID,
	o.Sales,
	o.Quantity

	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON p.ProductID = o.ProductID
	LEFT JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Employees e
	ON e.EmployeeID = o.SalesPersonID
	WHERE c.Country != 'USA'
	)
-- check
SELECT * FROM Sales.V_Order_Details_EU

-- 4) FLEXIBILITY & Dyanamic 

-- 5) Multiple language 
-- 6) Virtual Data marts in data warehouse : cuz they provide flexible and efficient way to present data
