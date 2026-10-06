-- Part Extraction : 
-- 1. Data aggregations
-- How many orders were placed each years

SELECT 
YEAR(OrderDate),
COUNT(*) NoOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate)

-- 2. Data filtering (TIP : Filter data using integer is faster than using a string)
-- How many orders were placed each MONTH ?

SELECT 
DATENAME(month,OrderDate) AS OrderDate,
COUNT(*) NoOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate)


-- Show all orders that were placed during the month of feb 
SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2

/*
Function Comparison : 
DAY MONTH YEAR DATEPART ---> INT
			   DATENAME ---> STRING
			  DATETRUNC ---> DATETIME
			    EOMONTH ---> DATE


*/