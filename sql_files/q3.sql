/*----------
Q3. Average Order Value (AOV)
Compute the average order value for each customer.
Include only customers with more than 5 orders.
----------*/
SELECT
    co.customer_id,
    CONCAT(co.first_name, ' ', co.last_name) full_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(oi.total_sale::NUMERIC) / COUNT(o.order_id),2) average_order_value
FROM customers co
JOIN orders o ON o.customer_id = co.customer_id
JOIN order_items oi ON oi.order_id= o.order_id
GROUP BY 1
HAVING COUNT(o.order_id) > 5
ORDER BY 4 DESC;