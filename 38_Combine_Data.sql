-- Orders data are stored in separate tables (orders and orders archive)
-- Combine all order data into one report without duplicates

SELECT 
       'Orders' AS sourcetable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
       'OrdersArchive' AS sourcetable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM Sales.OrdersArchive


-- DATA Detection  :  identifying the differnce or changes (delta) between two batches of data 

-- DATA COMPLETENESS CHECK : Except operator can be used to compare tables to detect discrepancies between databases 

/*
UNION
UNION ALL
EXCEPT
INTERSECT

USE CASES : combine information (UNION. UNION ALL)
            delta detetcion (EXCEPT)
            datacompleteness check (EXCEPT)
*/