/*----------
Q15. Top 5 Customers by Orders in each State
Identify the top 5 customers with the highest number of orders for each state.
Include the number of orders and total sales for each customer.
----------*/
SELECT *
FROM (
    SELECT
        c.state,
        CONCAT(c.first_name, ' ', c.last_name) customers,
        COUNT(o.order_id) total_orders,
        SUM(oi.total_sale) total_sale,
        DENSE_RANK() OVER(PARTITION BY c.state ORDER BY COUNT(o.order_id) DESC) rank
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY 1, 2
    ORDER BY 1
)
WHERE rank <= 5;