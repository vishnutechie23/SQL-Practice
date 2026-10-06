
/* 
USE CASE : Handling nulls 
1) DATA AGGREGATION : Handle the null before doing data aggregation
*/
-- Find the avg score of the customers
SELECT 
customerID,
Score,
COALESCE(Score,0) Score2,
AVG(Score) OVER () AvgScore,
AVG(COALESCE(Score,0)) OVER () AvgScore1
FROM Sales.Customers

/*
MATHEMATICAL OPERATIONS : Handle nulls before doing mathematical operations
0 + 5 + 5
'' + 'B' = B
NULL + 5 = NULL
NULL + 'B' = NULL
*/
-- Display the full name of customers in single field by merging first and last names, and add 10 bonus points to each customer's score
SELECT 
CustomerID,
FirstName,
LastName,
FirstName + ' ' + COALESCE(LastName, '') AS FullName,
Score,
COALESCE(Score,0) + 10 AS Score_wid_bonus
FROM Sales.Customers



/*
Handle tha nulls before using JOINS
Handle the nulls beofre Sorting data
*/
-- Sort the customers from lowest to highest scores with nulls appearing last
SELECT 
CustomerId,
Score,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END Flag
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score

/*
NULL IF() : Compares two expressions return
- NULL , if they are equal
- Firstvalue if they are not equal
syntax : NULL IF(value1, value2)

USE CASE: DIVISION BY Zero : preventing the error of dividing by zero

*/
-- Find the sales price for each order by dividing sales by quantity 
SELECT 
OrderID,
Sales,
Quantity,
Sales / NULLIF(Quantity,0) AS Price
FROM Sales.Orders

/*
IS NULL / IS NOT NULL 
Syntax : Value IS NULL
		 Value IS NOT NULL

USE CASE : 
1) Filtering data : Searching for missing info
2) ANTI JOINS : Finding thw unmatched row b/w two tables


*/
-- identify the customers who have no score
SELECT *
FROM Sales.Customers
WHERE Score IS NULL

-- list all customer who have score
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL

-- List all details from customers who have not placed any orders
SELECT
c.*, 
o.OrderID
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;


/*
NULL v/s EMPTY v/s SPACE
NULL : Means noting, unknown!
EMPTY string zero charcters
Space BLANK spacae string with one or more charc
*/

/*
Handling nulls : DATA POLICIES
Set of rules that defines how data should be handled
1. Only use nulls & empty strings, but avoid using blank space(TRIM)
2. only use nulls & avoid using empty strings & blank space
3. use the default value 'unknown' and avoid using nulls, empty strings & blank space

-->Replacing emppty strings & blank space with nulls during data preparation before inserting into databse to optimize storage and performance : poliyc 2

-->Replaicng empty string, blank,null with default value during data preparation using it in reporting to improve readibility and reduce confusion : policy 3

*/
WITH Orders AS (
SELECT 1 ID, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '   '
)
SELECT *,
TRIM(Category) policy1,
NULLIF (TRIM(Category),'') policy2,
COALESCE (NULLIF (TRIM(Category),''), 'unknown') policy3
-- DATALENGTH(Category) LEN_
FROM Orders
