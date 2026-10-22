SELECT *
FROM FactResellerSales
WHERE CarrierTrackingNumber = '4911-403C-98'

SELECT CarrierTrackingNumber
FROM FactResellerSales
WHERE CarrierTrackingNumber = '4911-403C-98'

CREATE NONCLUSTERED INDEX idx_FactReseller_CTA ON FactResellerSales (CarrierTrackingNumber)

-- Execution plan Heap vs Clustered Index:
-- -Sorting data : Heap is slower than clustered, cuz database must perform extra work to sort rows

-- vs Non clustereed index :
-- Index seek : A targeted search within an index retrieving only specific rows

-- Types of scan
-- Tanle scan : Reads every row in a table (WORST)
-- Index scan : Reads all entries in an index to find results
-- Index seek : Quickly locates specific rows in an index (GOOD)

-- JOIN ALGORITHMS:
-- Nested Loops : Compares tables row by row, best for small tables
-- Hash match : matches rows using ahash table, best for large tables
-- Merge join : Merge two sorted tables, efficient when both are sorted

SELECT 
	p.EnglishProductName AS Product_Name,
	SUM(s.SalesAmount) AS TotalSales
FROM FactResellarSales_HP s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactResellerSalesHP ON FactResellarSales_HP




