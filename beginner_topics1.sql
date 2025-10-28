SELECT department, COUNT(*) AS ccount
 FROM employees
 GROUP BY department;

SELECT department, COUNT(*)
FROM employees
GROUP BY department
HAVING COUNT(*) > 0;

-- Inclusive range
SELECT * FROM employees
WHERE age BETWEEN 25 AND 35;

# Exclude a range
SELECT * FROM customers
WHERE total_money_spent NOT BETWEEN 200 AND 800
	AND first_name > 'F';


SHOW  FULL COLUMNS FROM customers;

SELECT COLUMN_NAME, COLLATION_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bakery'
  AND TABLE_NAME = 'customers';



