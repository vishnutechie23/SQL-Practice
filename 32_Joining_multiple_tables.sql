/*
Using sales DB show a list of all orders, along with the related customer, product and employee details For each order display : 
order ID, customer name ,product name, sales, price, sales person's name
*/
USE SalesDB
SELECT 
	o.OrderID,
	o.Sales,
	c.FirstName AS CustomerFirstName,
	c.LastName AS CustomerLastName,
	p.Product AS product_name,
	p.Price,
	e.FirstName AS EmployeeFristName,
	e.LastName AS EmployeeLastName
FROM sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID





-- Just to see tables
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Employees
SELECT * FROM Sales.Orders
SELECT * FROM Sales.OrdersArchive
SELECT * FROM Sales.Products
SELECT * FROM Sales.Customers
