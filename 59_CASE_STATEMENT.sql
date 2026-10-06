-- CASE STATEMENT : Evaluates a list of conditions & returns a value when the first condition is met
-- create report showing total sales for each of the following categories: High (> 50) medium (21-50) low less than 20 sort categories from high to low 
-- RULE : The datatype of results must be matching
-- USE CASE : 1) Categories data
--			  2) MAPPING
--			  3) Handling NULLs
SELECT 
Category,
SUM(sales) AS TotalSales
FROM(
	SELECT 
	OrderID,
	Sales,
	CASE 
		WHEN Sales > 50 THEN 'HIGH'
		WHEN Sales > 20 THEN 'MEDIUM'
		ELSE 'LOW'
	END Category
	FROM Sales.Orders
) t
GROUP BY Category
ORDER BY TotalSales DESC

-- 2) mapping : Transform the values from one form to another
-- Retrive employee details woth gender display as full text
SELECT
EmployeeID,
FirstName,
LastName,
Gender,
CASE 
	WHEN Gender = 'F' THEN 'Female'
	WHEN Gender = 'M' THEN 'Male'
	ELSE 'Not available'
END GenderFullText
FROM Sales.Employees

-- Customer details with abbreivated country code
SELECT DISTINCT Country
FROM Sales.Customers

SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	CASE 
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'N/A'
	END CountryNameAbbr,

	CASE Country
		WHEN  'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
		ELSE 'N/A'
	END CountryNameAbbr1
FROM Sales.Customers

-- 3) Handling nulls : reaplce with a specific value
-- find avg score of customers and treat nulls as 0
-- Additionaly provide details such customerID and LastName

SELECT 
    CustomerID,
    FirstName,
    Score,

    CASE 
        WHEN Score IS NULL THEN 0
        ELSE Score
    END AS CleanScore,

AVG(Score) OVER() AvgSvore,
    AVG(
        CASE 
            WHEN Score IS NULL THEN 0
            ELSE Score
        END
    ) OVER() AS avg_score
FROM Sales.Customers;

-- 4) Conditional aggregation : apply aggregate functions only on subsets of data that fullfil certain condition
-- Count how many time each customer has made an order with sales greater than 30 
SELECT
CustomerID,
	SUM(CASE 
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) TotalOrdersHighSales, -- This is conditional aggregation using case statement
	COUNT(*) TotalOrdrs
FROM Sales.Orders
GROUP BY CustomerID
