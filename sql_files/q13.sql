/*----------
Q13. Most Returned Products
Query the top 10 products by the number of returns
Display the return rate as a percentage of total units sold for each product.
----------*/
SELECT
    *,
    ROUND(total_returned::NUMERIC / total_units_sold::NUMERIC * 100, 2) return_percentage
FROM (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(*) total_units_sold,
        SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) total_returned
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN orders o ON o.order_id = oi.order_id
    GROUP BY 1, 2
)
ORDER BY return_percentage DESC
LIMIT 10;