SELECT 
	OrderID,
	CreationTime,
FORMAT(CreationTime,'MM-dd-yyyy') AS USA_Format,
FORMAT(CreationTime, 'dd-MM-yyyy') AS EURO_Format,
FORMAT(CreationTime,'dd') AS dd,
FORMAT(CreationTime,'ddd') AS ddd,
FORMAT(CreationTime,'dddd') AS dddd,
FORMAT(CreationTime,'MM') AS MM,
FORMAT(CreationTime,'MMM') AS MMM,
FORMAT(CreationTime,'MMMM') AS MMMM
FROM Sales.orders

-- Show creation time in this format : 
-- Day wed Jan Q1 2025 12:34:56 PM
SELECT 
OrderID,
CreationTime,
'Day ' + FORMAT(CreationTime,'ddd MMM ') + 'Q' + DATENAME(quarter, CreationTime) + ' ' + 
FORMAT(CreationTime,'yyyy hh:mm:ss')AS CustomFormat
FROM Sales.Orders 
