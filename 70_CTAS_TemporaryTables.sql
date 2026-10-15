-- CTAS & TEMP
/*
DB Table : A table is a structired collection of data, similar to a spredsheet or grid(Excel)
Table types : Permanent			Tempraray
			-- Create/Select 
			-- CTAS
CREATE : Define structure of table /INSERT : Insert data into table
CTAS : Create table as select
create new table based on the result of an sql query
==> Quering views is sloer than querying CTAS Tables

*/
-- How to refresh SQL : 
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL 
	DROP TABLE Sales.MonthlyOrders;
GO

SELECT 
	DATENAME(month, OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)

SELECT * FROM Sales.MonthlyOrders

DROP TABLE Sales.MonthlyOrders


-- TEMP TABLE : Stores intermediate results in temporary storage within the database during the session 
-- Step 1 : load data into temp table
SELECT 
*
INTO #Orders
FROM Sales.Orders

-- step 2 : Transform data in TEMP table
SELECT * FROM #Orders
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered'

-- Step 3 : Load temp table into permanent table
SELECT *
INTO Sales.OrdersTest	
FROM #Orders

-- USECASE : 1)Intermediate results (ETL)
-- But go with CTE, Views, CTAS 

-- COMPARISION : Subquery vs CTE vs Views vs CTAS vs Temp

/*
FEATURE             SUBQUERY        CTE             TEMP TABLE       CTAS            VIEW
------------------------------------------------------------------------------------------------
STORAGE             Memory/Query    Memory/Query    Temp Storage     Disk            No Data Storage
LIFETIME            Temporary       Temporary       Session          Permanent       Permanent
WHEN DELETED        End of Query    End of Query    End of Session   DROP            DROP
SCOPE               Single Query    Single Query    Multiple Queries Multiple Queries Multiple Queries
REUSABILITY         Limited         Limited         Medium           High            High
UPDATE              Yes*            Yes*            Yes              No*             Yes*
UP to DATE			yyes			yes				no				 No				 Yes
------------------------------------------------------------------------------------------------

* SUBQUERY:
  - A query nested inside another SQL query.
  - Usually used for filtering, calculations, or returning values.
  - Exists only as part of the statement in which it is written.

* CTE (Common Table Expression):
  - A named temporary result set defined using WITH.
  - Exists only for the single statement immediately following it.
  - Improves readability and organizes complex queries.
  - Can be referenced multiple times within that statement.

* TEMP TABLE:
  - A temporary table that stores data in tempdb in SQL Server.
  - Can be used across multiple statements within its scope.
  - Usually deleted when the session ends, or can be dropped manually.
  - Supports INSERT, UPDATE and DELETE.

* CTAS (CREATE TABLE AS SELECT):
  - Creates a table using the results of a SELECT query.
  - In SQL Server, use SELECT INTO or CREATE TABLE followed by INSERT.
  - The created table persists until it is dropped.
  - It stores a copy of the query results at creation time.
  - It does not automatically update when source data changes.

* VIEW:
  - A virtual table based on a saved SELECT query.
  - Stores the query definition, not the result data itself.
  - Reflects changes in underlying data when queried.
  - Can simplify complex queries and restrict access to selected columns/rows.
  - Some views are updatable, depending on their definition.

#### STORAGE

SUBQUERY:
- No separately stored result table by default.
- SQL Server may use internal worktables or intermediate storage.

CTE:
- No guaranteed physical storage.
- SQL Server may re-execute its definition when referenced multiple times.
- A CTE is not automatically materialized.

TEMP TABLE:
- Stored in SQL Server tempdb.
- Can have indexes and statistics.

CTAS:
- Creates a physical table containing the query result.

VIEW:
- Stores the SQL query definition.
- A normal view does not store the query result.
- Indexed views are a special SQL Server feature that can store results.

#### LIFETIME AND SCOPE

SUBQUERY:
- Exists within its containing SQL statement.

CTE:
- Available only to the single statement immediately following WITH.

TEMP TABLE:
- Can be reused by multiple statements while it remains in scope.
- A local temporary table (#TempTable) is generally available within
  its creating session and is automatically removed when its scope ends.

CTAS:
- The table remains until explicitly dropped or removed.

VIEW:
- Remains in the database until altered or dropped.

#### REUSABILITY

SUBQUERY:
- Limited to the statement in which it is written.

CTE:
- Can be referenced multiple times within its defining statement.
- Cannot be directly reused by a separate statement.

TEMP TABLE:
- Can be reused across multiple statements.

CTAS:
- The resulting table can be queried by multiple statements.

VIEW:
- Can be reused in many queries and reports.

#### UPDATES

SUBQUERY:
- You can use subqueries within SELECT, INSERT, UPDATE and DELETE
  statements where the syntax permits.
- A subquery itself is not a stored object to update.

CTE:
- Can be used with SELECT, UPDATE, DELETE and sometimes INSERT,
  depending on the statement and query structure.
- The CTE itself is not a separately stored table.

TEMP TABLE:
- Supports INSERT, UPDATE and DELETE.

CTAS:
- The created table can be updated after creation.
- Changes to the source table do not automatically update its data.

VIEW:
- Some views support INSERT, UPDATE and DELETE.
- Complex views, such as those with aggregation or certain joins,
  may not be directly updatable.

#### SQL SERVER EXAMPLES

-- 1. SUBQUERY

SELECT *
FROM Sales.Orders
WHERE Sales > (
    SELECT AVG(Sales)
    FROM Sales.Orders
);


-- 2. CTE

WITH CTE_HighSales AS
(
    SELECT *
    FROM Sales.Orders
    WHERE Sales > 1000
)
SELECT *
FROM CTE_HighSales;


-- 3. TEMP TABLE

SELECT *
INTO #TempOrders
FROM Sales.Orders
WHERE Sales > 1000;

SELECT *
FROM #TempOrders;

DROP TABLE #TempOrders;


-- 4. CTAS EQUIVALENT IN SQL SERVER: SELECT INTO

SELECT *
INTO Sales.HighSalesOrders
FROM Sales.Orders
WHERE Sales > 1000;

-- Drop the created table when no longer needed:
-- DROP TABLE Sales.HighSalesOrders;


-- 5. VIEW

CREATE OR ALTER VIEW Sales.V_HighSales AS
SELECT *
FROM Sales.Orders
WHERE Sales > 1000;

SELECT *
FROM Sales.V_HighSales;

-- Drop the view:
-- DROP VIEW Sales.V_HighSales;


-- =========================================================
-- IMPORTANT NOTES
-- =========================================================

-- 1. SQL Server does not use CREATE TABLE AS SELECT in the same
--    way as MySQL or PostgreSQL; SELECT INTO is a common alternative.

-- 2. TEMP TABLE uses #TableName for a local temporary table
--    in SQL Server.

-- 3. CTEs and subqueries are not guaranteed to be stored only
--    in memory; SQL Server chooses the execution strategy.

-- 4. A normal view stores its definition, not its result data.

-- 5. CTAS creates a physical table; its data is not automatically
--    refreshed when the source table changes.

-- 6. A view is reusable across queries; a CTE is limited to
--    the statement immediately following its definition.
