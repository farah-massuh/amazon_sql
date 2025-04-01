/*----------
Q6. Best-Selling Categories by State
Identify the best-selling product category for each state.
Include the total sales for that category within each state.
----------*/
WITH ranked_sales AS (
    SELECT
        c.state,
        cat.category_name,
        SUM(oi.total_sale) total_sale,
        -- partitions by state, orders by the sum of the total sale, and then gets the rank for the entire data
        RANK() OVER(PARTITION BY c.state ORDER BY SUM(oi.total_sale) DESC) rank
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN category cat ON cat.category_id = p.category_id
    GROUP BY 1, 2
)
SELECT 
    state, 
    category_name, 
    ROUND(total_sale::NUMERIC, 2) total_sale
FROM ranked_sales
WHERE rank = 1
ORDER BY 1, 3;
