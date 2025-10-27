SELECT * FROM customers
WHERE first_name < 'k';

SELECT * FROM customers
WHERE first_name LIKE '___';

SELECT * FROM customers
WHERE first_name LIKE '%ar%';
SELECT * FROM customers
WHERE LENGTH(first_name) + LENGTH(last_name) > 10;

SELECT * FROM customers
WHERE CHAR_LENGTH(first_name) = 5;