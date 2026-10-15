-- STORED PROCEDURE:
-- A collection of SQL statements stored in the database and executed whenever required using CALL.

-- Step 1 : Write a query 
-- For US Customers Find the Total number of customers and the avg score

SELECT 
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'

-- Step 2 : Turning the query into stored procedure
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
SELECT 
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'USA'
END

-- Step 3 : Execute the stored procedure
 EXEC GetCustomerSummary

 -- For german customer frin total numebr of customer and the avg score
CREATE PROCEDURE GetCustomerSummaryGermany AS
BEGIN
 SELECT 
	COUNT(*) TotalCustomers,
	AVG(Score) AvgScore
FROM Sales.Customers
WHERE Country = 'Germany'
END

EXEC GetCustomerSummaryGermany

-- PARAMETER : Placeholder used to pass value as input from the caller to the procedure allowing dynamic data to be processed
-- Define parameter
-- Variables : Place holders used to store values to be used later in the procedure

-- parameter pass values into a stored procedure or reeturn values back to the caller
-- Variablws : Temporary store & manipulate data during its execution
-- Total customer from Germany : 2
-- AVerage Score from Germany : 425

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' -- Default
AS 
BEGIN
	-- TRY CATCH
	BEGIN TRY
		DECLARE @TotalCustomers INT, @AvgScore FLOAT;
		-- Step 1 : Prepare & Cleanup Data
			IF EXISTS (SELECT 1 FROM Sales.customers WHERE Score IS NULL AND Country = @Country)
		BEGIN
			PRINT('Updating null score to 0');
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country;
		END

		ELSE 
		BEGIN
			PRINT('No nulls found')
		END;

		-- Step 2 : Generating Reports 
		-- Calculate Total score and avg score for specific country

		SELECT 
			@TotalCustomers = COUNT(*),
			@AvgScore = AVG(Score) 
		FROM Sales.Customers
		WHERE Country = @Country;

		-- Everythin should be in string
		PRINT 'Total customer from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
		PRINT 'AVerage Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

		-- Multiple Statements : Find total no of orders and Total sales
		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales,
			1/0
		FROM Sales.Orders o
		JOIN Sales.Customers c 
		ON c.CustomerID = o.CustomerID
		WHERE Country = @Country;

	END TRY
	BEGIN CATCH
		-- Error handling 
		PRINT('An error occured.')
		PRINT('Error Message:' + ERROR_MESSAGE())
		PRINT('Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line:' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('Error Procedure: ' + ERROR_PROCEDURE());
	END CATCH
END
GO

SELECT * FROM Sales.Customers
EXEC GetCustomerSummary 
EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary @Country = 'USA'

DROP PROCEDURE GetCustomerSummaryGermany

-- Parameters : pass value into a stored procedure or return values back to the caller
-- Variables : Temporary store & manipulate data during its execution

