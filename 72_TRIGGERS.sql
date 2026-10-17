-- TRIGGERS : Special stored procedure(Set of statements) that automatially runs in response to a specific event on a table or view
/*
							Trigger TYpes

	(runs after event)AFTER  <--|---- DML Triggers		DDL Triggers		LOGin
						  		|	-INSERT				-CREATE
(Runs during event) INSTEAD <---|   -UPDATE				-ALTER
									-DELETE				-DROP

*/

-- Step 1 : Create log table
CREATE TABLE Sales.EmployeeLogs (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
);
-- Step 2 : Create trigger on employee Table
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT 
AS
BEGIN
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added =' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED 
END
-- Step 3 : Insertnew data into employee
SELECT * FROM Sales.EmployeeLogs
INSERT INTO Sales.Employees
VALUES
(6,'Maria','Deo','HR', '1998-01-12','F',12345, 3)

DELETE FROM Sales.Employees
WHERE FirstName = 'Elon'
  AND LastName = 'Musk';

  SELECT * FROM Sales.Employees