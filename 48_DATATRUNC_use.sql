-- this is helpful to check level of aggregation of details : (it's like zoom in or out in data)
/*
SELECT 
CreationTime,
COUNT(*)
FROM Sales.Orders
GROUP BY CreationTime
*/

SELECT 
DATETRUNC(month,CreationTime) Creation,
COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(month,CreationTime) 

SELECT 
DATETRUNC(year,CreationTime) Creation,
COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(year,CreationTime) 