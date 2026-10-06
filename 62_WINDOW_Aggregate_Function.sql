-- WINDOW AGGregate functions 
-- COUNT() : Returns the no of rows within the window (any datatype)
-- COUNT(*) = COUNT(1)
-- COUNT(Col) : Counts no. of non NULL value in the column 
/*
USE CASE : 1.Overall analysis
			2.CAtegory Analysis
			 3.Quality check: NULL's
			  4.Quality check: DUplicates
*/
-- Find the total no of orders provide details such as orderid and orderdate
-- Find total no of orders for each customers
SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() TotalOrders,
	COUNT(1) OVER(PARTITION BY CustomerID) OrdersByCustomers
FROM sales.orders


-- Find total no of customers and additionaly provide all customer details
-- Fidn total no. of score for customer
SELECT *, 
COUNT(*) OVER() TotalCustomerStar,  
COUNT(1) OVER() TotalCustomerOne,  
COUNT(Score) OVER() TotalSores,
COUNT(Country) OVER() TotalCountries
FROM Sales.Customers


-- check orders contains any duplicates rows
SELECT * 
FROM(
SELECT
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) CheckPK
FROM Sales.OrdersArchive
) t WHERE CheckPK > 1
SELECT *
FROM Sales.OrdersArchive

-- SUM() : Sum of value within a window
-- Find total sales across all orders and the total sales for each product additionaly provide details such as order ID order date
SELECT
	OrderID,
	OrderDate,
	Sales,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY PRoductID) SalesByPRoduct
FROM Sales.Orders

-- Find the percentage contribution of each product sales to the toatl sales 
SELECT
OrderID,
ProductID,
Sales,
SUM(Sales) OVER() TotalSales,
ROUND (CAST (Sales AS FLOAT)/ SUM(Sales) OVER() * 100,2) PercentageOfTotal 
FROM sales.Orders


-- AVG() : Returns avg value within the window
-- Find avg salea cross all orders and Find avg sales for each product additionaly provide details such orderID,OrderDate
SELECT 
	OrderID,
	OrderDate,
	Sales,
	AVG(Sales) OVER() SalesOrders,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgSalesByProduct
FROM sales.Orders

-- Find avg scores of customers provide details of customerID LastName
SELECT 
	CustomerID,
	LastName,
	Score,
	COALESCE(Score,0) CustomerScore,
	AVG(Score) OVER() AvgScore,
	AVG(COALESCE(Score,0)) OVER() AvgScoreWithoutNULL
FROM Sales.Customers

-- Find aall orders where sales are higher than the averagesales across all orders
SELECT
*
FROM (
	SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER() AvgSales
	FROM Sales.Orders
) t
WHERE Sales > AvgSales

-- MIN() / MAX()
-- Find highest and lowest sales of all orders 
-- Find highest and lowest sales for each product
-- Additionlaly provide details orderid orderdate
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HighetSales,
	MIN(Sales) OVER() LowestSales,
	MAX(Sales) OVER(PARTITION BY ProductID) HighestSalesbyproductID,
	MIN(Sales) OVER(PARTITION BY ProductID) LowestSalesbyproductID
FROM Sales.Orders

-- Show the emplooye who have highest salaries
SELECT *
FROM (
SELECT *,
MAX(Salary) OVER() HighestSalary
FROM Sales.Employees
) t
WHERE Salary = HighestSalary

-- CAlculate the deviation of each sales from the min and max sales amount

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER() HighestSales,
	MIN(Sales) OVER() LowestSales,
	Sales - MIN(Sales) OVER() DeviationFromMIN,
	Sales - MAX(Sales) OVER() DeviationFromMAX
FROM Sales.Orders

-- Calculate the runnig avg of sales for each product over time
-- Calculate the runnig avg of sales for each product over time, including only next order
SELECT 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgByProd,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.orders