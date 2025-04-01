/*----------
Q12. Product Profit Margin
Calculate the profit margin for each product (difference between price and cost of goods sold)
Rank products by their profit margin, showing highest to lowest.
----------*/
SELECT
    product_id,
    product_name,
    profit_margin,
    DENSE_RANK () OVER(ORDER BY profit_margin DESC) product_ranking
FROM (
    SELECT
        p.product_id,
        p.product_name,
        SUM(total_sale - (cogs * quantity)) / SUM(total_sale) * 100 profit_margin
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY 1, 2
)