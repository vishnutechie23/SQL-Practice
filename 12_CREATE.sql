/*
Create a new table called persons with columns : 
id, person_name, birth_date, phone
*/
-- CREATE : 


CREATE TABLE persons(
	id INT NOT NULL,
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY (id)
)

SELECT * FROM persons
-- if you lost script (query) then go to tables right click and go to script table as so you will get query again 