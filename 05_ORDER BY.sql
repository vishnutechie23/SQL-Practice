/* show all the customers and sort the results by high to low */
-- ORDER BY : sort your data (ASC/DESC) ---> Default is ASC 

SELECT *
FROM customers
ORDER BY score DESC

/* show all the customers and sort the results by low to high */

SELECT *
FROM customers
ORDER BY score 