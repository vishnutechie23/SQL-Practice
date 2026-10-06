-- VALUE WINDOW FUNCTION : Access the value from another row 
/*
LEAD() : access the value from the next row within a window
LAG() : Access the value from the previous row within a window
FIRST_VALUE() : 
LAST_VALUE() :
*/
-- USECASE : Time series analysis year to year / Month to month
-- Analyze the month -over-month performance by finding the percentage change in sales between the current and previous months
SELECT *,
CurrMonthSales - PrevMonthSales AS MoM_Change,
ROUND(CAST ((CurrMonthSales - PrevMonthSales) AS FLOAT)/ PrevMonthSales * 100,1) AS MoM_Per
FROM(
SELECT
MONTH(OrderDate) OrderMonth,
SUM(Sales) CurrMonthSales,
LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PrevMonthSales
FROM Sales.orders
GROUP BY 
	MONTH(OrderDate)
	)t 

-- CUSTOMER RETANTION ANALYSIS : 
-- In order to analyze customer loyalty, rank customer baseed on the avg days between their orders
SELECT 
CustomerID,
AVG(DaysUntilNextORders) AvgDays,
RANK() OVER(ORDER BY COALESCE(AVG(DaysUntilNextORders), 9999999)) RankAvg
FROM(
	SELECT
	OrderID,
	CustomerID,
	OrderDate currOrder,
	LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
	DATEDIFF(day,OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextORders
	FROM Sales.Orders
	-- ORDER BY CustomerID, OrderDate
) t
GROUP BY 
	CustomerID

-- FIRST_VALUE() : Access the value from first row within the window 
-- LAST_VALUE() : access the value from last row within the window

-- Find the lowest and highest sales for each window
-- Find the diff in sales between the curr  and the lowest sales 
SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) AS SalesDiff
	-- FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) highestSales2,
	-- MIN(Sales) OVER(PARTITION BY ProductID ) LowestSales2,
	-- MAX(Sales) OVER(PARTITION BY ProductID ) HighestSales3
FROM Sales.Orders