/*----------
Q14. Identify Customers either Returning or New
If the customer has done more than 5 returns categorize them as returning, otherwise, new
List name, total orders, and total returns.
----------*/
SELECT
    *,
    CASE WHEN total_returns > 5 THEN 'Returning' ELSE 'New' END customer_type
FROM (
    SELECT
        CONCAT(c.first_name, ' ', c.last_name) full_name,
        COUNT(o.order_id) total_orders,
        SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) total_returns
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY 1
)