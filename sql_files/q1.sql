/*----------
Q1. Top Selling Products
Query the top 10 products by total sales value.
Get the product name, total quantities sold, and total sales value.
----------*/
-- creating a new column named total_sale
ALTER TABLE order_items
ADD COLUMN total_sale FLOAT;
-- updating total_sale with quantity * price_per_unit
UPDATE order_items
SET total_sale = quantity * price_per_unit;
-- query
SELECT
    oi.product_id,
    p.product_name,
    ROUND(SUM(total_sale)) total_sale,
    COUNT(o.order_id) total_orders
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;
