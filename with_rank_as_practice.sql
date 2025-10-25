WITH ranked_customers AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city,
        COALESCE(SUM(co.order_total),0) AS total_spent,
        ROW_NUMBER() OVER (PARTITION BY c.city ORDER BY COALESCE(SUM(co.order_total),0) DESC) AS rn
    FROM customers c
    LEFT JOIN customer_orders co
        ON c.customer_id = co.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT *
FROM ranked_customers
WHERE rn <= 2
ORDER BY city, total_spent DESC;



SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COALESCE(SUM(co.order_total),0) AS total_spent
FROM customers c
LEFT JOIN customer_orders co
    ON c.customer_id = co.customer_id
WHERE (
    SELECT COUNT(*)
    FROM customers c2
    LEFT JOIN customer_orders co2
        ON c2.customer_id = co2.customer_id
    WHERE c2.city = c.city
    GROUP BY c2.customer_id
    HAVING COALESCE(SUM(co2.order_total),0) > COALESCE(SUM(co.order_total),0)
) < 2
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY c.city, total_spent DESC;


SELECT 
    city,
    COUNT(*) AS customer_count
FROM bakery.customers
GROUP BY city
ORDER BY customer_count DESC;

WITH ranked_customers AS (
    SELECT 
        c.first_name,
        c.last_name,
        c.city,
        ROW_NUMBER() OVER (PARTITION BY c.city ORDER BY c.first_name DESC) AS rn
    FROM customers c
)
SELECT *
FROM ranked_customers
WHERE rn > 0 ;

SELECT 
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;

WITH ranked_customers AS (
    SELECT 
        c.first_name,
        c.last_name,
        c.city,
        ROW_NUMBER() OVER (PARTITION BY c.city ORDER BY c.first_name DESC) AS rn
    FROM customers c
)
SELECT *
FROM ranked_customers r
WHERE r.rn = (
    SELECT MAX(r2.rn)
    FROM ranked_customers r2
    WHERE r2.city = r.city
);

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COALESCE(MAX(co.order_id), 'N/A') AS order_y_n
FROM customers c
LEFT JOIN customer_orders co
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    CASE 
        WHEN COUNT(co.order_id) > 0 THEN 'Yes'
        ELSE 'N/A'
    END AS order_y_n
FROM customers c
LEFT JOIN customer_orders co
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COALESCE(co.order_id, 'N/A') AS order_y_n
FROM customers c
LEFT JOIN customer_orders co
    ON c.customer_id = co.customer_id;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COALESCE(
        CASE WHEN COUNT(co.order_id) > 0 THEN 'Yes' END,
        'N/A'
    ) AS order_y_n
FROM customers c
LEFT JOIN customer_orders co
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id;
