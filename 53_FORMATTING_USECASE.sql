-- Formatting use case : Data aggreagation : Do formatting before data aggregation's 

SELECT
FORMAT (OrderDate,'MMM yy') OrderDate,
COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT (OrderDate,'MMM yy')

-- DATA Standaradisation like csv/API/databse ----> standard format ----> analysis
