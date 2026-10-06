/*Find average score for each counry considering only customer with a 
score not equal to 0 and return only those countries with an 
average score greater than 430
*/

SELECT id,
	country,
	AVG(score) AS avg_score
FROM customers
WHERE score != 0
GROUP BY id,country
HAVING AVG(score) > 430

--Before aggregation --> WHERE
--After aggregation --> HAVING


