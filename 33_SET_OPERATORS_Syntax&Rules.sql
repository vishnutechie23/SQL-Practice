/*
SET OPERATORS : combine rows
syntax and rules 
syntax :

SELECT			|
	firstname,	|
	lastname	|---> first SELECT statement
FROM customes	|

UNION           |---> SET OPERATOR

SELECT			|
	firstname,	|---> second SELECT statement
	lastname	|
FROM employees	|

RULES :
RULE 1 : SQL CLAUSES
- SET operator can be used alomst in all caluses
	WHERE/JOIN/GROUP BY/HAVING
- ORDER BY is allowed only once at the end of query

RULE 2 : NO. OF Columns
- The no. of columns in each query must be same

RULE 3 : DATA TYPES
- Data types of columns in each query must be compatible

RULE 4 : ORDER OF COLUMNS
- The order of columns in each query must be same

RULE 5 : COLUMN ALIASES
- The column names in the results set are determined by the column names specified in the first query 

RULE 6 : CORRECT COLUMNS
- Even if all rules aree met & SQL shows no error, the results may be incorrect
- incorrect column selection leads to inaccurate results

*/

SELECT 
	CustomerID,
	FirstName,
	LastName
FROM Sales.customers

UNION 

SELECT 
	EmployeeID,
	FirstName,
	LastName
FROM Sales.Employees

-- syntax is right but here same datatype but column changes so sql doesn't give error cuz sql don't know data 
SELECT 
	CustomerID,
	FirstName,
	LastName
FROM Sales.customers

UNION 

SELECT 
	EmployeeID,
	LastName,
	FirstName
FROM Sales.Employees

