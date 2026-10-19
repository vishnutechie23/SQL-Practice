-- List all indexes on a specific table
sp_helpindex 'Sales.DBCustomers'

-- sys : System schema : Contains metadata about database tables, views, indexes, etc

-- Index Monitoring & Management 
-- 1) Monitor index usage
SELECT 
tbl.name AS TableName,
idx.name AS Index_Name,
idx.type_desc AS IndexType,
idx.is_primary_key AS Is_Primary_Key,
idx.is_unique AS Is_Unique,
idx.is_disabled AS Is_Disabled,
s.user_seeks AS UserSeeks,
s.user_scans AS UseScans,
s.user_lookups AS UserLookups,
s.user_updates AS UserUpdates,
COALESCE (s.last_user_seek,s.last_user_scan ) AS LastUpdate
FROM sys.indexes idx 
JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id = idx.object_id AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name
 
-- Dyanamic management view(DMV) : Provides real-time insights into database performance and system health
SELECT * FROM sys.dm_db_index_usage_stats
WHERE database_id = 4


SELECT * FROM sys.tables

SELECT * FROM Sales.Products
WHERE Product = 'Caps'

/*
USE AdventureWorksDW2025;

-- Show all tables
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT *
FROM FactInternetSales
ORDER BY ProductKey 
*/

-- 2) Monitor Missing Indexes
SELECT 
	fs.SalesOrderNumber,
	dp.EnglishProductName,
	dp.Color
FROM FactInternetSales fs
INNER JOIN DimProduct dp
ON fs.ProductKey = dp.ProductKey
WHERE dp.Color = 'Black'
AND fs.OrderDateKey BETWEEN 20101229 AND 20101231

SELECT * FROM sys.dm_db_missing_index_details
-- It could assist you to find out things taht you didn't thought about
-- TIP : Evaluate the recommondations before creating any index


-- 3) Monitor Duplicate Indexes
SELECT 
	tbl.name AS Table_Name,
	col.name AS Index_Column,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	COUNT(*) OVER(PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC


-- Update statistics
SELECT
	SCHEMA_NAME(t.schema_id) AS SchemaName,
	t.name AS TableName,
	s.name AS StatisticName,
	sp.last_updated AS LastUpdated,
	DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdatedDay,
	sp.rows AS 'Rows',
	sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats AS s
JOIN sys.tables t 
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties (s.object_id, s.stats_id) AS sp
ORDER BY 
sp.modification_counter DESC;

UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000001_29221CFB

UPDATE STATISTICS Sales.DBCustomers 

EXEC sp_updatestats




-- Monitor Fragmentations
/*
Fragmentation
-Unused spaces in data pages
-Data pages are out of order

Fragmentation methods :
Reorganize
-Defragments leaf nodes to keep them sorted
-'Light' Operation

Rebuild
-Recreates index from scratch
-'Heavy' operation
*/

SELECT *
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL ,'LIMITED')

-- avg_fragmentation_in_percent : Indicate how out-of-order pages are within the index 
-- 0% means no fragmentation (Perfect)
-- 100% means index is completely fragmented (out of order)
/*
When to defragment :<10% - No action needed
					10-30% - Reorganize
					>30 - Rebuild whole index
*/

SELECT 
	tbl.name AS TableName,
	idx.name AS IndexName,
	s.avg_fragmentation_in_percent,
	s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL,NULL,NULL,'LIMITED') AS s
INNER JOIN sys.tables tbl
ON s.object_id = tbl.object_id
INNER JOIN sys.indexes AS idx 
ON idx.object_id = s.object_id AND idx.index_id = s.index_id 
ORDER BY s.avg_fragmentation_in_percent DESC

ALTER INDEX idx_Customers_Country ON Sales.Customers REORGANIZE

ALTER INDEX idx_Customers_Country ON Sales.Customers REBUILD


