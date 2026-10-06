-- CONVERT : convert a date and time value to a diff datatype and format the value
-- CAST : WE can use only to change DATA TYPE from one to another And we cannot use this funtion inorder to change the format  
SELECT 
CONVERT(INT,'123') AS [String to Int convert],
CONVERT(DATE, '2026-09-12') AS [String to Date convert],CreationTime, 
CONVERT(DATE, CreationTime) AS [DateTime to date Convert]
FROM Sales.Orders

SELECT 
CreationTime,
CONVERT(DATE, CreationTime) AS [Datetime to Date CONVERT],
CONVERT (VARCHAR, CreationTime, 32) AS [USA Std. Style:32], 
CONVERT (VARCHAR, CreationTime, 34) AS [EURO Std. Style:34]  
FROM Sales.Orders


SELECT
CAST('123' AS INT) AS [String to int],
CAST(123 AS VARCHAR) AS [INT to String],
CAST('12-09-2026' AS DATE) AS [String to date],
CAST('12-09-2026' AS DATETIME2) AS [String to datetime2],
CreationTime,
CAST(CreationTime AS DATE) AS [DateTime to DATE]
FROM Sales.Orders