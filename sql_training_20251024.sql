SELECT * FROM customer_orders;

# Right join anchors the 2nd table (The table that comes after JOIN)
# FROM FirstTable RIGHT/LEFT JOIN SecondTable ON matching_criteria

SELECT c.customer_id,
	c.first_name,
	c.last_name,
    GROUP_CONCAT(co.order_id ) AS order_list
FROM customers c
RIGHT JOIN customer_orders co ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
;

SELECT c.customer_id,
	c.first_name,
	c.last_name,
    GROUP_CONCAT(co.order_id ) AS order_list
FROM customers c
LEFT JOIN customer_orders co ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
;

# INNER JOIN returns only matching rows
SELECT c.customer_id,
	c.first_name,
	c.last_name,
    GROUP_CONCAT(co.order_id ) AS order_list
FROM customers c
INNER JOIN customer_orders co ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
;

# GROUP_CONCAT() combines the grouped items in one list with the name provided after AS 
# GROUP_CONCAT(group_items_under_this_column) and give it a new name AS new_name
SELECT c.customer_id,
	c.first_name,
	c.last_name,
    GROUP_CONCAT(co.order_id ) AS order_list,
	SUM(co.order_total) AS total_spent
FROM customers c
RIGHT JOIN customer_orders co ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name # ***
ORDER BY total_spent DESC;

# ***
# GROUP BY must include all elements other than aggregated columns
# Aggregated columns order_total and order_id

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    GROUP_CONCAT(co.order_id ORDER BY co.order_id) AS order_list,
    COALESCE(SUM(co.order_total), 0) AS total_spent
FROM customers c
LEFT JOIN customer_orders co 
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;


# COALESCE(item1, item2, item3, ...) -> Returns the first non-null item 
# In this case COALESCE(SUM(co.order_total), 0) Return 0 if the total is NULL
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    GROUP_CONCAT(co.order_id ORDER BY co.order_id) AS order_list,
    COALESCE(SUM(co.order_total), 0) AS total_spent
FROM customers c
RIGHT JOIN customer_orders co 
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

# HAVING is used to filter 
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    GROUP_CONCAT(co.order_id ORDER BY co.order_id) AS order_list,
    COALESCE(SUM(co.order_total), 0) AS total_spent
FROM customers c
LEFT JOIN customer_orders co 
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING total_spent < 100
ORDER BY total_spent DESC;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(co.order_id) AS order_count,
    COALESCE(SUM(co.order_total), 0) AS total_spent
FROM customers c
LEFT JOIN customer_orders co 
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING total_spent < 100
ORDER BY total_spent DESC;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(co.order_id) AS order_count,
    COALESCE(SUM(co.order_total), 0) AS total_spent
FROM customers c
LEFT JOIN customer_orders co 
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id
HAVING order_count  <> 2 AND total_spent > 20
ORDER BY order_count DESC;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(co.order_id) AS order_count,
    COALESCE(SUM(co.order_total), 0) AS total_spent,
    COALESCE(SUM(co.order_total) / NULLIF(COUNT(co.order_id), 0), 0) AS avg_order_value
FROM customers c
RIGHT JOIN customer_orders co 
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id
ORDER BY avg_order_value DESC;

