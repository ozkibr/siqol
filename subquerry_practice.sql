SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

# subquerry

SELECT AVG(salary) AS avg_salary
FROM employees;

DESCRIBE employees;
SELECT * FROM employees;

SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 1;  
SHOW COLUMNS FROM employees;
