INSERT INTO customers(id, first_name)
VALUES 
	(10,'satish')

SELECT * FROM customers

/*
1. col and values must be in same order
2. matching datatypes, columns count & constrains
3. you can skip the columns if you insert he vlaues for every col
4. TIP : always list columns explicitly for clarity & maintainability
5. col not include in INSERT becomes NULL (unless defaults or constraints exists)
*/