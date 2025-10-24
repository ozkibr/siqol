SELECT *
FROM customers;

SELECT *
FROM customer_orders;

SELECT GROUP_CONCAT(c.customer_id ORDER BY c.customer_id  SEPARATOR ' -- ' ), co.order_id
FROM customers c
INNER JOIN customer_orders co
ON c.customer_id = co.customer_id
GROUP BY c.customer_id;

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    GROUP_CONCAT(co.order_id  ORDER BY co.order_id DESC SEPARATOR ', ') AS orders
FROM customers c
INNER JOIN customer_orders co
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    co.order_id,
    GROUP_CONCAT(p.product_name ORDER BY p.product_name SEPARATOR ', ') AS products
FROM customers c
INNER JOIN customer_orders co
    ON c.customer_id = co.customer_id
INNER JOIN ordered_items oi
    ON co.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY co.order_id, c.customer_id, c.first_name, c.last_name
ORDER BY c.customer_id, co.order_id;

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    GROUP_CONCAT(DISTINCT co.order_id ORDER BY co.order_id SEPARATOR ', ') AS orders,
    GROUP_CONCAT(DISTINCT p.product_name ORDER BY p.product_name SEPARATOR ', ') AS products,
    SUM(oi.quantity * oi.unit_price) AS total_money
FROM customers c
INNER JOIN customer_orders co
    ON c.customer_id = co.customer_id
INNER JOIN ordered_items oi
    ON co.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    GROUP_CONCAT(DISTINCT co.order_id ORDER BY co.order_id SEPARATOR ', ') AS orders,
    GROUP_CONCAT(
        DISTINCT IF(p.product_name IS NULL, '*', p.product_name)
        ORDER BY p.product_name SEPARATOR ', '
    ) AS products,
    SUM(oi.quantity * oi.unit_price) AS total_money
FROM customers c
INNER JOIN customer_orders co
    ON c.customer_id = co.customer_id
LEFT JOIN ordered_items oi
    ON co.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY c.customer_id;
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    GROUP_CONCAT(
        CONCAT(
            o.order_id, '[', 
            IFNULL(o.products, '*'),
            ', $', o.total_money,
            ']'
        )
        ORDER BY o.order_id
        SEPARATOR ', '
    ) AS orders_summary
FROM customers c
INNER JOIN (
    SELECT
        co.order_id,
        co.customer_id,
        IFNULL(GROUP_CONCAT(p.product_name ORDER BY p.product_name SEPARATOR ', '), '*') AS products,
        IFNULL(SUM(oi.quantity * oi.unit_price), 0) AS total_money
    FROM customer_orders co
    LEFT JOIN ordered_items oi ON co.order_id = oi.order_id
    LEFT JOIN products p ON oi.product_id = p.product_id
    GROUP BY co.order_id, co.customer_id
) o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    GROUP_CONCAT(DISTINCT co.order_id ORDER BY co.order_id SEPARATOR ', ') AS orders,
    GROUP_CONCAT(DISTINCT IF(oi.order_id IS NULL, '*', p.product_name) ORDER BY co.order_id, p.product_name SEPARATOR ', ') AS products
FROM customers c
INNER JOIN customer_orders co
    ON c.customer_id = co.customer_id
LEFT JOIN ordered_items oi
    ON co.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    GROUP_CONCAT(o.order_with_flag ORDER BY o.order_id SEPARATOR ', ') AS orders,
    GROUP_CONCAT(o.products ORDER BY o.order_id SEPARATOR ', ') AS products
FROM customers c
INNER JOIN (
    SELECT
        co.order_id,
        co.customer_id,
        CONCAT(co.order_id, IF(COUNT(oi.order_id) = 0, '*', '')) AS order_with_flag,
        GROUP_CONCAT(p.product_name ORDER BY p.product_name SEPARATOR ', ') AS products
    FROM customer_orders co
    LEFT JOIN ordered_items oi
        ON co.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY co.order_id, co.customer_id
) o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;
