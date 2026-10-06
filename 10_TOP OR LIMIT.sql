-- only 3 customers
SELECT TOP 3*
FROM customers

-- top 3 with highest score 
SELECT TOP 3 *
FROM customers
ORDER BY score DESC

-- Lowest 2 customers based oo score
SELECT TOP 2*
FROM customers
ORDER BY score ASC

-- Get the two most recent orders
SELECT TOP 2*
FROM orders 
ORDER BY order_date DESC