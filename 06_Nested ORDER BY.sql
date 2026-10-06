/*Nested ORDER BY */
-- show all the customers and sort the results by country and then by the highest scoer 

SELECT *
FROM customers
ORDER BY 
	country ASC,
	score DESC
-- country has first priority 

SELECT *
FROM customers
ORDER BY 
	score DESC,
	country ASC
	
-- score has first priority 