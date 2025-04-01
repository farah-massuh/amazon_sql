/*----------
Q9. Shipping Delays
Identify orders where the shipping date is later than 2 days after the order date.
Include customer, order details, and delivery provider.
----------*/
SELECT
    CONCAT(c.first_name, ' ', c.last_name) customer,
    o.*,
    s.shipping_providers,
    (s.shipping_date - o.order_date) days_to_deliver
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN shippings s ON o.order_id = s.order_id
WHERE s.shipping_date - o.order_date > 2;