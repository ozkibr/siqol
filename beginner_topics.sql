SELECT * FROM customers
WHERE first_name LIKE 'O%';
# first_name starts with O

SELECT * FROM customers
WHERE first_name LIKE '_____';
# first_name exactly 5 characters

SELECT * FROM customers
WHERE first_name LIKE '%ar%';
# first_name has 'ar' at somewhere

SELECT * FROM customers
WHERE first_name LIKE '%o%';
# any first_name that has o in it

SELECT * FROM customers
WHERE first_name NOT LIKE '%a%';
# any first_name that does not have a in it

SELECT * FROM customers
WHERE first_name NOT LIKE '%i%' AND first_name LIKE '%o%';
# any first_name that does not have i and has at least one o
# Every condition must be a complete comparison (column LIKE pattern)

SELECT * FROM customers
WHERE LENGTH(first_name) + LENGTH(last_name) > 10;

SELECT * FROM customers
WHERE CHAR_LENGTH(first_name) = 5;

SELECT * FROM customers
WHERE first_name LIKE 'a%' OR last_name LIKE '%n';

SELECT * FROM employees
WHERE first_name REGEXP BINARY '^d';
# Old method for case-sensitive matching; can cause errors with utf8mb4 columns
# this does not work REGEXP BINARY makes it case sensitive but my tables are as_cs

SELECT * FROM employees
WHERE REGEXP_LIKE(first_name, '^d', 'i'); 
# i for case insensitive / c for case sensitive
# this is for mysql8+ more flexible because sensitivity control

SELECT * FROM employees
WHERE first_name COLLATE utf8mb4_0900_as_cs REGEXP '^d';
# as_cs for accent sensitive & case sensitive
# ai_ci for insensitive option








