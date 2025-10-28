# practice with GPT

SELECT CONCAT(first_name, ' ', last_name) AS full_name, total_money_spent
FROM customers
WHERE total_money_spent > (
    SELECT AVG(total_money_spent) FROM customers
)
ORDER BY total_money_spent DESC;


SELECT CONCAT(first_name, " ", last_name) AS full_name,
       total_money_spent,
       CASE
           WHEN total_money_spent >= 500 THEN 'VIP'
           WHEN total_money_spent BETWEEN 200 AND 499 THEN 'Regular'
           ELSE 'New'
       END AS customer_level
FROM customers
ORDER BY total_money_spent DESC;

# Best selling product
SELECT p.product_name,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM ordered_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue ASC
LIMIT 3;

# VIEW
CREATE OR REPLACE VIEW customer_spending AS
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       SUM(co.order_total) AS total_spent
FROM customer_orders co
JOIN customers c ON co.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;


SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW FULL TABLES;
SHOW TABLES;

SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'bakery';

SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'bakery'
AND TABLE_TYPE = 'VIEW';

CREATE OR REPLACE VIEW order_details AS
SELECT 
    co.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    co.order_total,
    co.order_date
FROM customer_orders co
JOIN customers c ON co.customer_id = c.customer_id;

SELECT * FROM order_details;
SHOW CREATE VIEW order_details;


CREATE OR REPLACE VIEW total_spent_per_customer AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(co.order_total) AS total_spent,
    COUNT(co.order_id) AS total_orders
FROM customers c
JOIN customer_orders co ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

SHOW CREATE VIEW total_spent_per_customer;
DESCRIBE total_spent_per_customer;
SELECT * FROM total_spent_per_customer;


SELECT *,
       CASE
           WHEN total_spent >= 50 THEN 'VIP'
           WHEN total_spent BETWEEN 20 AND 49 THEN 'Regular'
           ELSE 'New'
       END AS customer_level
FROM total_spent_per_customer
ORDER BY total_spent DESC;


SELECT 
    t.customer_id,
    t.full_name,
    t.total_spent,
    t.total_orders,
    p.product_name AS product_name,
    SUM(oi.quantity) AS total_quantity
FROM total_spent_per_customer t
JOIN customer_orders co ON t.customer_id = co.customer_id
JOIN ordered_items oi ON co.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY t.customer_id, t.full_name, t.total_spent, t.total_orders, p.product_name
ORDER BY t.total_spent DESC;



SELECT 
    t.customer_id,
    t.full_name,
    t.total_spent,
    t.total_orders,
    GROUP_CONCAT(CONCAT(p.product_name, ' (', oi.quantity, ')') SEPARATOR ', ') AS products_ordered
FROM total_spent_per_customer t
JOIN customer_orders co ON t.customer_id = co.customer_id
JOIN ordered_items oi ON co.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY t.customer_id, t.full_name, t.total_spent, t.total_orders
ORDER BY t.total_spent DESC;

SELECT 
    p.product_name AS 'Product Name',
    GROUP_CONCAT(CONCAT(c.first_name, ' ', c.last_name, ' (', oi.quantity, ')') 
                 ORDER BY c.first_name ASC SEPARATOR ', ') AS "Customer ordered"
FROM products p
JOIN ordered_items oi ON p.product_id = oi.product_id
JOIN customer_orders co ON oi.order_id = co.order_id
JOIN customers c ON co.customer_id = c.customer_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_name ASC;

CREATE OR REPLACE VIEW product_customer_summary AS
SELECT 
    p.product_name AS product_name,
    GROUP_CONCAT(CONCAT(c.first_name, ' ', c.last_name, ' (', oi.quantity, ')') 
                 ORDER BY c.customer_id SEPARATOR ', ') AS customers_ordered
FROM products p
JOIN ordered_items oi ON p.product_id = oi.product_id
JOIN customer_orders co ON oi.order_id = co.order_id
JOIN customers c ON co.customer_id = c.customer_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_name;

SELECT *,
       (LENGTH(customers_ordered) - LENGTH(REPLACE(customers_ordered, ',', '')) + 1) AS num_customers
FROM product_customer_summary
WHERE customers_ordered IS NOT NULL
ORDER BY num_customers DESC;

SELECT 
    p.product_name AS product_name,
    COUNT(DISTINCT co.customer_id) AS num_customers,
    GROUP_CONCAT(CONCAT(c.first_name, ' ', c.last_name, ' (', oi.quantity, ')') 
                 ORDER BY c.customer_id SEPARATOR ', ') AS customers_ordered
FROM products p
JOIN ordered_items oi ON p.product_id = oi.product_id
JOIN customer_orders co ON oi.order_id = co.order_id
JOIN customers c ON co.customer_id = c.customer_id
GROUP BY p.product_id, p.product_name
ORDER BY num_customers DESC;

SELECT *,
       (LENGTH(customers_ordered) - LENGTH(REPLACE(customers_ordered, '(', ''))) AS num_customers
FROM product_customer_summary
ORDER BY num_customers DESC;

