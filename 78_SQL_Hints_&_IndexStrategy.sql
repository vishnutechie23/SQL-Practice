-- SQL HINTS : Commands you add to a query to force the database to run it in a specific way for better performance

/*
TIPS | HINTS
1. Test hints in all project environments(DEV,PROD) as performance may vary
2. Hints are quick fixes (workaround not solution) you still have to find the cause & fix it
*/


-- You can force sql a specific type of laoding & joining 
-- You can force sql to use a specific index that you created 

SELECT
	o.Sales,
	c.Country
FROM Sales.orders o
-- LEFT JOIN Sales.Customers c WITH(FORCESEEK)
LEFT JOIN Sales.Customers c WITH(INDEX([PK_customers]))
ON o.CustomerID = c.CustomerID
-- OPTION (HASH JOIN)


-- INDEXING STRATEGY : 
/*
Avoid over indexing : 
indexes slow down write performance : When data is inserted, updated or deleted database has to update indexes
-- too many indexes can confuse execution plan
-- Inc planing time
-- Choose a suboptimal plan

Phase : Indexing Strategy
# 1.Initial Strategy
	What is the main goal of our indexing strategy
	OLAP (Online analytical processing) DWH
	- Optimize Read performance
	- Switch large frequency used tables into Columnstore

	OLTP (Online Transaction processing) banking/finance
	- Optimize Wrtie performance
	- Clustered index primary key

# 2.Usage PAtterns Indexing
	1. Identify frequently used tabels & Columns
	2. Choose Right index
	3. Test index

# 3.Scenario-Based Indexing
	1. Identify Slow Queries
	2. Check Execution plan
	3. Choose Right index
	4. (Test) Compare execution plan

# 4.Monitoring and maintenance
	1.Monitor index usage
	2.monitor missing indexes
	3.monitor duplicate indexes
	4.Update statistics
	5.monitor fragmentations

*/


-- Identify slow query :
SELECT 
	TOP 10
	qs.total_elapsed_time AS TotalElapsedTime,
	qs.execution_count,
	qs.total_worker_time AS TotalCPUTime,
	qs.last_execution_time,
	qt.text AS QueryText
FROM
	sys.dm_exec_query_stats qs
CROSS APPLY 
	sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY
	qs.total_elapsed_time DESC;
