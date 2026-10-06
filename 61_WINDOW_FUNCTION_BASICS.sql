-- WINDOW FUNCTION : Perform calculations on a specific sibsets of data without losing the level of details of rows
-- WINDOW syntax : 
/*
	AVG(Sales) OVER(PARTITION BY Category ORDER BY OrderDate ROWS UNBOUNDED PRECEDING)

PARTITION BY 
ORDER BY
Window frame : specific row within partition 

RULE : 
1) window function can be uesed ONLY in SELECT and ORDER BY clauses. Window functino cannot used to filter data
2) Nesting window funciton is not allowed
3) SQL Execute window functino after WHERE clause
4) Window function can be use togheter eith GROUP BY on the same query, ONLY IF the same columns are used
	first GROUP BY then window function
*/

/* - Find the total sales across all orders
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(sales) OVER(PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders

-- Find the total sales for each product
SELECT
ProductID,
SUM(sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID

-- Find the total sales for each product additional provide details such order ID , order date
SELECT
OrderID,
OrderDate,
ProductID,
SUM(sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID,OrderDate,OrderID
*/

-- Find total no of sales across all orders additionaly provide details such as order id, order date
/*SELECT 
OrderID,
OrderDate,
SUM(Sales) OVER() Totalsales
FROM Sales.Orders

-- Find the total sales for each combination of pdt and order status
-- Find total sales for each products additionaly provide details such as order id, order date
SELECT 
OrderID,
OrderDate,
ProductID,
OrderStatus,
Sales,
SUM(Sales) OVER() TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) Totalsales,
SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductAndStatus
FROM Sales.Orders


-- Rank each order beased on their sales from higher to lower additionlly provide details such as orderid and orderDate
SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales) RankSales
FROM Sales.Orders


-- FRAME clause : syntax 
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY Orderstatus ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) TotalSales
	-- SUM(Sales) OVER(PARTITION BY Orderstatus ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) TotalSales -- DEFAULT FRAME
FROM Sales.Orders

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY Orderstatus) TotalSales
FROM Sales.Orders
-- ORDER BY SUM(Sales) OVER(PARTITION BY Orderstatus) 
WHERE ProductID IN (101,102)
*/

-- RAnk customers based on their total sales : You can use window function with GROUP BY 
SELECT 
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) RankCustomer
FROM Sales.Orders
GROUP BY CustomerID

