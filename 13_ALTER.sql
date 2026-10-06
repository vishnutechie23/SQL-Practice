-- add new col name email in persons table 
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL

SELECT * FROM persons

-- Remove col phone from the persons table
ALTER TABLE persons
DROP COLUMN phone