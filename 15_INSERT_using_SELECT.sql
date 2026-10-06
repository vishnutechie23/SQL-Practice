-- insert data from customers into persons

INSERT INTO persons (id,person_name,birth_date,phone)
SELECT 
	id,
	first_name,
	NULL,
	'unknown'
FROM customers

SELECT * FROM persons