-- DATEADD : Adds or subtracts a specific time interval to/from a table
-- syntax : DATEADD(part,interval,date)
-- EX : DATEADD(year,2,OrderDate)


SELECT 
OrderID,
OrderDate,
DATEADD(day,-10,OrderDate) AS Ten_days_before,
DATEADD(month,3,OrderDate) AS Three_month_later,
DATEADD(year,3,OrderDate) AS Three_year_later
FROM sales.Orders

-- DATEDIFF() : Find the difference b/w two dates
-- syntax : DATEDIFF(part,start_date,end_date)

-- Qs : calculate the age of employees
SELECT 
EmployeeID,
BirthDate,
DATEDIFF(year,BirthDate,GETDATE()) Age
FROM Sales.Employees

-- Qs2 : Find the average shiping duration in days for each months
SELECT 
MONTH(OrderDate) AS OrderDate,
AVG(DATEDIFF(day,OrderDate,ShipDate)) AS AvgShip
FROM Sales.Orders
GROUP BY MONTH(OrderDate)


-- Time gap analysis
-- Find the number of days b/w each orders and the previous order
-- LAG() : Access the value from previous records 

SELECT 
OrderID,
OrderDate CurrentorderDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) No_of_days
FROM Sales.Orders



-- DATE Validation 
-- ISDATE() : check if a value is a date returns 1 if the string value is a valid date and returns 0 if not
-- Syntax : ISDATE(value)
/*
SELECT 
ISDATE('1234') AS DateCheck1,
ISDATE('2026-09-15') AS DateCheck2,
ISDATE('2026') AS DateCheck3,
ISDATE('12') AS DateCheck4,
ISDATE('15-09-2026') AS DateCheck5
*/


SELECT 
	-- CAST(OrderDate AS DATE) OrderDate
	OrderDate,
	ISDATE(OrderDate),
	CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
		-- ELSE '9999-99-99'
	END NewOrderDate
FROM
(
	SELECT '2026-09-16' AS OrderDate UNION
	SELECT '2026-09-22' UNION
	SELECT '2026-09-30' UNION
	SELECT '2026-09' UNION
	SELECT '2026-04'
)t

-- WHERE ISDATE(OrderDate) = 0