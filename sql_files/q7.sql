/*----------
Q7. Customer Lifetime Value (CLTV)
Calculate the total value of orders placed by each customer over their lifetime.
Rank customers based on their CLTV.
----------*/
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) full_name,
    ROUND(SUM(oi.total_sale::NUMERIC),2) CLTV,
    -- tied values get the same rank and no gaps in rank numbers
    DENSE_RANK() OVER (ORDER BY SUM(oi.total_sale) DESC) customer_ranking
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY 1, 2
