/*----------
Q17. Top 10 products with highest decreasing revenue ratio compared to 2023 and 2024.
Return product id, product name, category name, 2023 revenue and 2024 revenue decrease ratio at end.
Note: Decrease ratio = (current_year - last_year / last_year) * 100
----------*/
-- query for 2023
WITH last_year_sale AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.total_sale) revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2023
    GROUP BY 1, 2
),
-- query for 2024
current_year_sale AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.total_sale) revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2024
    GROUP BY 1, 2   
)
-- overall query
SELECT
    cs.product_id,
    cs.product_name,
    ls.revenue last_year_revenue,
    cs.revenue current_year_revenue,
    ls.revenue - cs.revenue rev_difference,
    ROUND((cs.revenue - ls.revenue)::NUMERIC / ls.revenue::NUMERIC * 100, 2) revenue_decrease_ratio
FROM last_year_sale ls
JOIN current_year_sale cs ON ls.product_id = cs.product_id
WHERE ls.revenue > cs.revenue
ORDER BY 6 DESC
LIMIT 10;