# practice with GPT

SELECT CONCAT(first_name, ' ', last_name) AS full_name, total_money_spent
FROM customers
WHERE total_money_spent > (
    SELECT AVG(total_money_spent) FROM customers
)
ORDER BY total_money_spent DESC;


SELECT CONCAT(first_name, ' ', last_name) AS full_name,
       total_money_spent,
       CASE
           WHEN total_money_spent >= 500 THEN 'VIP'
           WHEN total_money_spent BETWEEN 200 AND 499 THEN 'Regular'
           ELSE 'New'
       END AS customer_level
FROM customers
ORDER BY total_money_spent DESC;


