/*----------
Q4. Monthly Sales Trend
Query monthly total sales over the past year.
Display the sales trend, grouping by month, return current month sale, and last month sale.
----------*/
WITH month_total_sales_past_year AS (
    SELECT
        EXTRACT(MONTH FROM o.order_date) month,
        EXTRACT(YEAR From o.order_date) year,
        ROUND(SUM(oi.total_sale::NUMERIC), 2) total_sale
    FROM orders as o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY 1, 2
    ORDER BY 2, 1
)
-- compare current month sales with last month
SELECT
    year,
    month,
    total_sale AS current_month_sale,
    -- retrieves the previous row's value (if no value, then NULL)
    LAG(total_sale, 1) OVER (ORDER BY year, month) last_month_sale
FROM month_total_sales_past_year;