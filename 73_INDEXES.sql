--- INDEXES : Data structure provides quick access to data optimizing the speed of your queries 
/*
Index type :
Structure - Clustered index
		  - Non-Clustered index
Storage - Row store index
		- Column store index
Functions - Unique index
		  - Filtered index

Trade-off : Some indexes arebetter for reading others for writting performance
Heap structure : Table without Clustered index (Read row by row)
PAGE : The samallest unit of data storage in DB(8kb) It stores anything(Data,Metadata,indexes,etc)
B Tree : Hierarchical structure storing data at leaves to help quickly locate data

Difference Between Clustered and Non-Clustered Index

Feature					Clustered Index								Non-Clustered Index

Definition			Physically sorts and stores rows 			Creates a separate structure with 
					according to the index key.					pointers to the actual data rows.

Number of Indexes	One clustered index per table.				Multiple non-clustered indexes are allowed.

Read Performance	Faster for suitable queries,				Faster for suitable searches and exact-match queries.
					especially range queries.

Write Performance	Can be slower due to potential 				Physical data order is unaffected
					data-page reorganization.					,so writes may be faster; however, the index still needs maintenance.

Storage Efficiency	Uses the table's data pages to 				Requires additional storage space for the index structure.
					store rows in clustered-index order.

Use Case			Suitable for frequently queried keys, 		Suitable for columns frequently used in search conditions,
					range queries, and columns that are			 filters, and joins.
					relatively stable.

Remember:
- Clustered index: Organizes the actual table data by the index key.
- Non-clustered index: Maintains a separate index structure to locate the actual data.
*/

-- A primary key automatically create a clustered index by default 
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers

SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers (CustomerID)

-- CREATE CLUSTERED INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers (FirstName)
-- Cannot create more than one clustered index on table 'Sales.DBCustomers'. Drop the existing clustered index 'idx_DBCustomers_CustomerID' before creating another.

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers

SELECT *
FROM Sales.DBCustomers
--WHERE LastName = 'Brown'
WHERE FirstName = 'Anna'

CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName ON Sales.DBCustomers (LastName)
CREATE INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers (FirstName)

-- Composite index
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

CREATE INDEX idx_DBCustomers_CountryScore ON Sales.DBCustomers (Country, Score)
-- RULE : The column of index order must match the order in your query
-- LEFTmost prefix rule : Index works only if your query filters starts from the first column in the index and follow its order
/* A,B,C,D
Index will be used
A
A,B
A,B,C
Idex won't be used
B
A,C
A,B,D

*/
 

-- Columnstore Process
-- IMPORTANT DIFFERENCES BETWEEN ROWSTORE AND COLUMNSTORE INDEX

/*
+----------------------+--------------------------------+--------------------------------+
| Feature              | Rowstore Index                 | Columnstore Index              |
+----------------------+--------------------------------+--------------------------------+
| Definition           | Organizes and stores data      | Organizes and stores data      |
|                      | row by row                     | column by column               |
+----------------------+--------------------------------+--------------------------------+
| Storage Efficiency   | Less efficient in storage      | Highly efficient with          |
|                      |                                | compression                    |
+----------------------+--------------------------------+--------------------------------+
| Read/Write           | Fair speed for read and        | Fast read performance          |
| Optimization         | write operations               | Slow write performance         |
+----------------------+--------------------------------+--------------------------------+
| I/O Efficiency       | Lower when retrieving only     | Higher when retrieving         |
|                      | specific columns               | specific columns               |
+----------------------+--------------------------------+--------------------------------+
| Best For             | OLTP (Transactional):          | OLAP (Analytical):             |
|                      | Commerce, banking, financial   | Data warehouse, business       |
|                      | systems, order processing      | intelligence, reporting,       |
|                      |                                | analytics                      |
+----------------------+--------------------------------+--------------------------------+
| Use Case             | High-frequency transaction     | Big data analytics             |
|                      | applications                   | Scanning large datasets        |
|                      | Quick access to complete       | Fast aggregation               |
|                      | records                        |                                |
+----------------------+--------------------------------+--------------------------------+
*/


CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS ON Sales.DBCustomers

DROP INDEX idx_DBCustomers_CS ON Sales.DBCustomers

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName ON Sales.DBCustomers(FirstName)
-- Multiple columnstore indexes are not supported.

-- DROP INDEX [idx_DBCustomers_CustomerID] ON Sales.DBCustomers


-- Now on another database [AdventureWorksDW2025]
USE AdventureWorksDW2025
-- Heap structure : 9.633 MB + 0.008 MB (Index space)
SELECT *
INTO FactInternetSales_HP	
FROM FactInternetSales

-- Row store : 9.633 MB + 0.055 MB (Index space)
SELECT *
INTO FactInternetSales_RS
FROM FactInternetSales

CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber)

-- Column store : 1.461 MB + 0.000 MB (Index space)
SELECT *
INTO FactInternetSales_CS
FROM FactInternetSales

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK ON FactInternetSales_CS
-- Storage efficiency : 1.Columnstore index 2.Heap strcuture 3.RowStore clustered Index


-- UNIQUE INDEX : Ensure no duplicate values exists in specific columns
-- Benifits : 1.Enforce uniqueness 2.Slightly inc query performance
SELECT * FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product ON Sales.Products (Product)
INSERT INTO Sales.Products (ProductID, Product) VALUES (106, 'Caps')
-- Cannot insert duplicate key row in object 'Sales.Products' with unique index 'idx_Products_Product'. The duplicate key value is (Caps).

-- Filtered Index : An index that includes only rows meeting the specified conditions
-- Benifits : 1.Target Optimization 2.Reduce Storage:Less datain the index
SELECT * FROM Sales.Customers
WHERE Country = 'USA'

CREATE NONCLUSTERED INDEX idx_Customers_Country 
ON Sales.Customers (Country)
WHERE Country = 'USA'

