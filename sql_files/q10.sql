/*----------
Q10. Payment Success Rate
Calculate the percentage of successful payments across all orders.
Include breakdowns by payment status (e.g., failed pending).
----------*/
SELECT
    p.payment_status,
    COUNT(*) total_payments,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) percentage
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 3 DESC;