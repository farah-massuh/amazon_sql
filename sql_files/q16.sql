/*----------
Q16. Revenue by Shipping Provider
Calculate the total revenue handled by each shipping provider.
Include the total number of orders handled and the average delivery time for each provider.
----------*/
SELECT
    s.shipping_providers,
    COUNT(o.order_id) orders_handled,
    ROUND(SUM(oi.total_sale)) total_sale,
    ROUND(COALESCE(AVG(s.return_date - s.shipping_date), 0)) average_days
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN shippings s ON s.order_id = o.order_id
GROUP BY 1