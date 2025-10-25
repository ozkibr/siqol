# how to handle too many columns in select
SELECT 
    c.*,  -- all customer columns
    COUNT(co.order_id) AS order_count,
    COALESCE(SUM(co.order_total), 0) AS total_spent,
    COALESCE(SUM(co.order_total) / NULLIF(COUNT(co.order_id), 0), 0) AS avg_order_value
FROM customers c
LEFT JOIN customer_orders co 
    ON c.customer_id = co.customer_id
GROUP BY c.customer_id;  -- only the PK of customers

#subquerry practice
SELECT 
    c.*,
    agg.order_count,
    agg.total_spent,
    agg.avg_order_value
FROM customers c
LEFT JOIN (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count,
        SUM(order_total) AS total_spent,
        SUM(order_total)/NULLIF(COUNT(order_id),0) AS avg_order_value
    FROM customer_orders
    GROUP BY customer_id
) AS agg
    ON c.customer_id = agg.customer_id
WHERE agg.total_spent > 40 AND agg.order_count > 1
ORDER BY agg.avg_order_value DESC;

SELECT @@sql_mode;

# SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT c.first_name, c.last_name, COUNT(co.order_id) AS order_count
FROM customers c
LEFT JOIN customer_orders co
  ON c.customer_id = co.customer_id
GROUP BY c.last_name;

SELECT 
    c.last_name,
    MAX(c.first_name) AS first_name,  -- or MIN, any aggregate function
    COUNT(co.order_id) AS order_count
FROM customers c
LEFT JOIN customer_orders co
  ON c.customer_id = co.customer_id
GROUP BY c.last_name;
