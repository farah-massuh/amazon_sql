/*----------
Q11. Top Perfomring Sellers
Find the top 5 sellers based on total sales value.
Include both successful and failed orders, and display their percentage of successful orders.
----------*/ 
-- find top 5 sellers based on total sales value
WITH top_sellers AS (
    SELECT
        s.seller_id,
        s.seller_name,
        SUM(oi.total_sale) total_sale
    FROM orders o
    JOIN sellers s ON o.seller_id = s.seller_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY 1, 2
    ORDER BY 3 DESC
    LIMIT 5
),
-- find the total of each order status for each seller
sellers_order_status AS (
    SELECT
        seller_id,
        order_status,
        COUNT(*) total_orders
    FROM orders
    GROUP BY 1, 2
),
-- filter out orders that are inprogress or returned
sellers_report AS (
    SELECT
        ts.seller_id seller_id,
        ts.seller_name seller_name,
        sos.order_status order_status,
        sos.total_orders total_orders
    FROM sellers_order_status sos
    JOIN top_sellers ts ON ts.seller_id = sos.seller_id
    WHERE sos.order_status NOT IN ('Inprogress', 'Returned')
    ORDER BY 1
)
-- display completed, failed, total, successful percentage, and failed percentage
SELECT
    seller_id,
    seller_name,
    SUM(CASE WHEN order_status = 'Completed' THEN total_orders ELSE 0 END) completed_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN total_orders ELSE 0 END) failed_orders,
    SUM(total_orders) AS total_orders,
    ROUND(SUM(CASE WHEN order_status = 'Completed' THEN total_orders ELSE 0 END)::NUMERIC / SUM(total_orders)::NUMERIC * 100, 2) successful_orders_percentage,
    ROUND(100 - (SUM(CASE WHEN order_status = 'Completed' THEN total_orders ELSE 0 END)::NUMERIC / SUM(total_orders)::NUMERIC * 100), 2) failed_orders_percentage
FROM sellers_report
GROUP BY 1, 2