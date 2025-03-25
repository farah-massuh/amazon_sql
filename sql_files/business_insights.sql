-- Business Insights

/*----------
1. Top Selling Products
Query the top 10 products by total sales value.
Get the product name, total quantities sold, and total sales value
----------*/

-- creating a new column named total_sale
ALTER TABLE order_items
ADD COLUMN total_sale FLOAT;

-- updating total_sale with quantity * price_per_unit
UPDATE order_items
SET total_sale = quantity * price_per_unit;

-- query
SELECT
    order_items.product_id,
    products.product_name,
    ROUND(SUM(total_sale)) AS total_sale,
    COUNT(orders.order_id) AS total_orders
FROM orders
JOIN order_items
ON order_items.order_id = orders.order_id
JOIN products
ON products.product_id = order_items.product_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;