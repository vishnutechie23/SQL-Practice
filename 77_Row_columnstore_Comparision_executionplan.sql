-- Execution plan Rowstore vs columnstore

-- You can save execution plan and compare

SELECT 
	p.EnglishProductName AS Product_Name,
	SUM(s.SalesAmount) AS TotalSales
FROM FactInternetSales s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName


-- Execution plan :-
-- Understand how SQL executes your query
-- How many resources your query comsumes
-- Check if your new indexes are used
-- Testing & Experimenting Indexes
