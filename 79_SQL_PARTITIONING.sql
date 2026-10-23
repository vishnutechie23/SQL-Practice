-- SQL PARTITIONs
/*
Divides Big table into smaller logical table while still being treated as a single logical table 

Building Partitions :
1.Create partition function 

Partition function : Define the logic on how to divide your data into partitions 
Based on partition key like (Column, region,..)

CREATE PARTITION FUNCTION PartitionByYear (DATE) AS RANGE LEFT FOR VALUES ('2023-12-31','2024-12-31','2025-12-31')

Create Filegroups : Logical container of one or more datafiles to help organize partitions

ALTER DATABASE salesdb ADD FILEGROUP FG_2023
ALTER DATABASE salesdb REMOVE FILEGROUP FG_2023
*/

-- Step 1 : Create a partition function

CREATE PARTITION FUNCTION PartitionByYear (DATE) AS RANGE LEFT FOR VALUES ('2023-12-31','2024-12-31','2025-12-31')

-- Query list of all existing partition functions
SELECT 
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions


-- Step 2 : Create Filegroups
ALTER DATABASE salesdb ADD FILEGROUP FG_2023;
ALTER DATABASE salesdb ADD FILEGROUP FG_2024;
ALTER DATABASE salesdb ADD FILEGROUP FG_2025;
ALTER DATABASE salesdb ADD FILEGROUP FG_2026;

ALTER DATABASE Salesdb REMOVE FILEGROUP FG_2023;

-- Query lists all existing Filegroups
SELECT *
FROM sys.filegroups
WHERE type = 'FG'
-- PRIMARY : DEfault filegroup whwere all objects of database is stored

-- Step 3 : Add .ndf Files to Each Filegroup
ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2023, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2024, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2025, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2026, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026;

-- To check 
SELECT 
	fg.name AS FilegroupName,
	mf.name AS LogicalFileName,
	mf.physical_name AS PysicalFilePath,
	mf.size / 128 AS SizeInMB
FROM
	sys.filegroups fg
JOIN
	sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE 
	mf.database_id = DB_ID('SalesDB');

-- Step 4 : Create PArtition scheme
-- Sort the filegroups acc to the results of the function's Partitions

CREATE PARTITION SCHEME SchemePartitionByYear 
AS PARTITION PartitionByYear TO 
(FG_2023, FG_2024, FG_2025, FG_2026);
-- 3 Boundaries = 4 Partitions = 4 Filegroups

-- To check : Query list of all partition schemes
SELECT 
	ps.name AS PartitionSchemeName,
	pf.name AS PartitionFunctionName,
	ds.destination_id AS PartitionNumber,
	fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id


SELECT
    ps.name AS PartitionSchemeName,
    pf.name AS PartitionFunctionName,
    ds.destination_id AS PartitionNumber,
    fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf
    ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds
    ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg
    ON ds.data_space_id = fg.data_space_id
ORDER BY ps.name, ds.destination_id;


-- Step 5 : Create The partitioned table
CREATE TABLE Sales.Orders_Partitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear (OrderDate)


-- Step 6 : Insert Data into the partitioned table
INSERT INTO Sales.Orders_Partitioned VALUES (1, '2023-05-15', 100);
INSERT INTO Sales.Orders_Partitioned VALUES (2, '2024-07-20', 50);
INSERT INTO Sales.Orders_Partitioned VALUES (3, '2025-12-31', 20);
INSERT INTO Sales.Orders_Partitioned VALUES (4, '2026-01-01', 100);


SELECT * FROM Sales.Orders_Partitioned

-- To check
SELECT 
	p.partition_number AS PartitionNumber,
	f.name AS PartitionFileGroup,
	p.rows AS NumberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned'


SELECT * 
INTO Sales.Orders_NoPartition
FROM Sales.Orders_Partitioned

SELECT * FROM Sales.Orders_Partitioned
WHERE OrderDate = '2026-01-01'
-- actual no of rows read - 1
-- Partition count - 1

SELECT * FROM Sales.Orders_Partitioned
WHERE OrderDate IN ('2026-01-01', '2025-12-31')
-- actual no of rows read - 2
-- Partition count - 2

SELECT * FROM Sales.Orders_NoPartition
WHERE OrderDate = '2026-01-01'
-- actual no of rows read - 4

