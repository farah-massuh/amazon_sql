-- Business Questions

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
    oi.product_id,
    p.product_name,
    ROUND(SUM(total_sale)) AS total_sale,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN order_items oi
ON oi.order_id = o.order_id
JOIN products p
ON p.product_id = oi.product_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;



/*----------
2. Revenue by Category
Calculate total revenue generated by each product category.
Inlcude the percentage contribution of each category to total revenue
----------*/
-- category_id, category_name, total_revenue, total_contribution
SELECT
    p.category_id,
    c.category_name,
    ROUND(SUM(oi.total_sale)) AS total_sale,
    ROUND((SUM(oi.total_sale::NUMERIC) * 100 -- NUMERIC to get decimals
        / (SELECT SUM(total_sale::NUMERIC) FROM order_items)), 2) AS percentage_contribution
FROM order_items oi
JOIN products p 
ON p.product_id = oi.product_id
LEFT JOIN category c 
ON c.category_id = p.category_id
GROUP BY 1, 2
ORDER BY 3 DESC;



/*----------
3. Average Order Value (AOV)
Compute the average order value for each customer.
Include only customers with more than 5 orders.
----------*/
SELECT
    co.customer_id,
    CONCAT(co.first_name, ' ', co.last_name) AS full_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(oi.total_sale::NUMERIC) / COUNT(o.order_id),2) AS average_order_value
FROM customers co
JOIN orders o
ON o.customer_id = co.customer_id
JOIN order_items oi
ON oi.order_id= o.order_id
GROUP BY 1
HAVING COUNT(o.order_id) > 5
ORDER BY 4 DESC;



/*----------
4. Monthly Sales Trend
Query monthly total sales over the past year.
Display the sales trend, grouping by month, return current month sale, and last month sale
----------*/
WITH month_total_sales_past_year AS (
    SELECT
        EXTRACT(MONTH FROM o.order_date) AS month,
        EXTRACT(YEAR From o.order_date) AS year,
        ROUND(SUM(oi.total_sale::NUMERIC), 2) AS total_sale
    FROM orders as o
    JOIN
    order_items AS oi
    ON oi.order_id = o.order_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY 1, 2
    ORDER BY year, month
)
-- compare current month sales with last month
SELECT
    year,
    month,
    total_sale AS current_month_sale,
    -- retrieves the previos row's value (if no value, then NULL)
    LAG(total_sale, 1) OVER (ORDER BY year, month) AS last_month_sale
FROM month_total_sales_past_year;



/*----------
5. Customers with no purchases
Find customers who have registered but never placed an order.
----------*/
SELECT * 
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
);