-- SEARCH OPERATORS : 
-- LIKE : Search for a pattern in text
-- % : Anything 1,0,many
-- _ : Exact 1 character

-- 1. Find all customers who first name starts with M
SELECT * FROM customers
WHERE first_name LIKE 'M%';

-- 2. Find all customers whose first name ends with N
SELECT * FROM customers
WHERE first_name LIKE '%N';

-- 3. Find all customers whose first name contains an R
SELECT * FROM customers
WHERE first_name LIKE '%r%';

-- 4. Find all customers whose first name contains an R at third position
SELECT * FROM customers
WHERE first_name LIKE '__r%';