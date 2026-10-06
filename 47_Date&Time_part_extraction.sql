-- DATE & TIME : 
	-- three ways to get date values
	-- 1.Date column from a table
	-- 2.Hardcoded constant string value
	-- 3.GETDATE() function


/*
					DATE & TIME FUNCTION

	part			format &		CALCULATIONS	VALIDATION
	extraction		casting
	
	-DAY			-FORMAT			-DATEADD		-ISDATE
	-MONTH			-CONVERT		-DATEDIFF
	-YEAR			-CAST
	-DATEPART
	-DATENAME
	-DATETRUNC
	-EOMONTH
*/


/*
SELECT 
	OrderID,
	CreationTime,
	'05-08-2026' Hardcoded,
	GETDATE()
FROM Sales.orders
*/

SELECT
	orderID,
	CreationTime,

	-- EOMONTH() : Returns the last day of a month
	
	EOMONTH(CreationTime) End_Of_Month,

	-- Trick to get first date og a month using DATETRUNC()
	CAST(DATETRUNC(month,CreationTime) AS DATE)Start_Of_Month,


	-- DATETRUNC() : Truncates the date to the specific part
	-- syntax : DATETRUNC(part,date)

	DATETRUNC(YEAR,CreationTime) DT_year,
	DATETRUNC(DAY,CreationTime) DT_day,
	DATETRUNC(MINUTE,CreationTime) DT_minute,
	


	-- DATENAME : returns tha name of specific part of the date (OUTPUT : returns STRING value )
	-- syntax : DATENAME(part,date)

	DATENAME(month,CreationTime) DN_month,
	DATENAME(weekday,CreationTime) DN_week,
	DATENAME(day,CreationTime) DN_day,
	DATENAME(year,CreationTime) DN_year,



	-- DATEPART EXAMPEES : week/quarter 
	-- syntax : DATEPART(part,date)

	DATEPART(year,CreationTime) DP_year,
	DATEPART(month,CreationTime) DP_month,
	DATEPART(day,CreationTime) DP_day,
	DATEPART(hour,CreationTime) DP_hour,
	DATEPART(QUARTER,CreationTime) DP_quarter,
	DATEPART(WEEK,CreationTime) DP_weak,

	-- DAY() : Returns the day from a table
	-- MONTH() : Returns month
	-- YEAR() : returns year

	-- syntax : DAY(date)
	--			MONTH(date)
	--			YEAR(date)

	YEAR(CreationTime) AS YEAR,
	MONTH(CreationTime) MONTH,
	DAY(CreationTime) DAY

FROM Sales.Orders

