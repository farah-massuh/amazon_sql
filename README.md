# 📊 Data-Driven Decisions: Amazon Marketplace Analysis with SQL

## 🧠 Overview
This project is a comprehensive SQL-based analysis of Amazon marketplace data. Using PostgreSQL and structured SQL queries, I explored various business metrics such as sales performance, customer behavior, inventory management, shipping delays, and more.

## 👩‍💻 Author
**Farah Massuh**

## 🎯 Project Objectives
- Identify high-performing products, sellers, and regions
- Analyze customer lifetime value and buying trends
- Track shipping and delivery performance
- Generate profit margin and return rate insights
- Automate inventory updates using a stored procedure

## 📂 Datasets Used
All data is derived from simulated Amazon marketplace records:

- `orders.csv`
- `order_items.csv`
- `products.csv`
- `inventory.csv`
- `customers.csv`
- `sellers.csv`
- `payments.csv`
- `shipping.csv`
- `category.csv`

## 🛠️ Tools & Technologies
- **SQL (PostgreSQL)** – Core querying and analysis
- **VS Code** – Development environment
- **ChatGPT** – For query optimization and explanation

## 🎯 Project Objectives
- Identify high-performing products, sellers, and regions
- Analyze customer lifetime value and buying trends
- Track shipping and delivery performance
- Generate profit margin and return rate insights
- Automate inventory updates using a stored procedure

## 💻 How to Use

1. Set up PostgreSQL on your machine.
2. Import the CSV datasets into respective tables.
3. Run the `business_insights.sql` file:

```bash
\i business_insights.sql
```
This file runs all queries and creates the stored procedure for inventory automation.

## 📊 Business Questions, Queries & Insights

### 1. Top Selling Products
```sql
SELECT
    oi.product_id,
    p.product_name,
    ROUND(SUM(total_sale)) AS total_sale,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;
```
**Insight**: A small number of products contribute significantly to total revenue and order volume. These are key revenue drivers.

### 2. Revenue by Category
```sql
SELECT
    p.category_id,
    c.category_name,
    ROUND(SUM(oi.total_sale)) AS total_sale,
    ROUND((SUM(oi.total_sale::NUMERIC) * 100 / (SELECT SUM(total_sale::NUMERIC) FROM order_items)), 2) AS percentage_contribution
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN category c ON c.category_id = p.category_id
GROUP BY 1, 2
ORDER BY 3 DESC;
```
**Insight**: Electronics and related categories account for the highest revenue contribution across the platform.

### 3. Average Order Value (AOV)
```sql
SELECT
    co.customer_id,
    CONCAT(co.first_name, ' ', co.last_name) AS full_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(oi.total_sale::NUMERIC) / COUNT(o.order_id),2) AS average_order_value
FROM customers co
JOIN orders o ON o.customer_id = co.customer_id
JOIN order_items oi ON oi.order_id= o.order_id
GROUP BY 1
HAVING COUNT(o.order_id) > 5
ORDER BY 4 DESC;
```
**Insight**: Returning customers have significantly higher AOV, suggesting a loyal and valuable customer segment.

### 4. Monthly Sales Trend
```sql
WITH month_total_sales_past_year AS (
    SELECT
        EXTRACT(MONTH FROM o.order_date) AS month,
        EXTRACT(YEAR From o.order_date) AS year,
        ROUND(SUM(oi.total_sale::NUMERIC), 2) AS total_sale
    FROM orders as o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY 1, 2
)
SELECT
    year,
    month,
    total_sale AS current_month_sale,
    LAG(total_sale, 1) OVER (ORDER BY year, month) AS last_month_sale
FROM month_total_sales_past_year;
```
**Insight**: Sales trends fluctuate monthly with noticeable seasonal patterns. Comparing current and previous months helps detect growth or decline.

### 5. Customers with No Purchases
```sql
SELECT * 
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
);
```
**Insight**: There is a segment of registered users who have not placed any orders — potential for re-engagement campaigns.

### 6. Best-Selling Categories by State
```sql
WITH ranked_sales AS (
    SELECT
        c.state,
        cat.category_name,
        SUM(oi.total_sale) AS total_sale,
        RANK() OVER(PARTITION BY c.state ORDER BY SUM(oi.total_sale) DESC) AS rank
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN category cat ON cat.category_id = p.category_id
    GROUP BY c.state, cat.category_name
)
SELECT 
    state, 
    category_name, 
    ROUND(total_sale::NUMERIC, 2) as total_sale
FROM ranked_sales
WHERE rank = 1
ORDER BY state, total_sale DESC;
```
**Insight**: Different states show varied preferences, enabling region-specific marketing strategies.

### 7. Customer Lifetime Value (CLTV)
```sql
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    ROUND(SUM(oi.total_sale::NUMERIC),2) AS CLTV,
    DENSE_RANK() OVER (ORDER BY SUM(oi.total_sale) DESC) AS customer_ranking
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, full_name;
```
**Insight**: Top customers contribute significantly to revenue. Retaining them is crucial.

(Continued in next cell...)

### 8. Inventory Stock Alerts
```sql
SELECT
    i.inventory_id,
    p.product_name,
    i.stock AS current_stock_left,
    i.last_stock_date,
    i.warehouse_id
FROM inventory i
JOIN products p ON p.product_id = i.product_id
WHERE i.stock < 10;
```
**Insight**: Several high-demand products are at risk of going out of stock, requiring urgent restocking.

### 9. Shipping Delays
```sql
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    o.*,
    s.shipping_providers,
    (s.shipping_date - o.order_date) AS days_to_deliver
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN shippings s ON o.order_id = s.order_id
WHERE s.shipping_date - o.order_date > 2;
```
**Insight**: Many orders experience shipping delays beyond 2 days, indicating potential issues with fulfillment partners.

### 10. Payment Success Rate
```sql
SELECT
    p.payment_status,
    COUNT(*) AS total_payments,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY 1
ORDER BY 3 DESC;
```
**Insight**: While most payments succeed, a notable percentage are either pending or failed, suggesting a need for payment system improvements.

### 11. Top Performing Sellers
```sql
-- Summary from multiple steps
WITH top_sellers AS (
    SELECT
        s.seller_id,
        s.seller_name,
        SUM(oi.total_sale) AS total_sale
    FROM orders o
    JOIN sellers s ON o.seller_id = s.seller_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY 1, 2
    ORDER BY 3 DESC
    LIMIT 5
),
sellers_order_status AS (
    SELECT
        seller_id,
        order_status,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY 1, 2
),
sellers_report AS (
    SELECT
        ts.seller_id AS seller_id,
        ts.seller_name AS seller_name,
        sos.order_status AS order_status,
        sos.total_orders AS total_orders
    FROM sellers_order_status sos
    JOIN top_sellers ts ON ts.seller_id = sos.seller_id
    WHERE sos.order_status NOT IN ('Inprogress', 'Returned')
)
SELECT
    seller_id,
    seller_name,
    SUM(CASE WHEN order_status = 'Completed' THEN total_orders ELSE 0 END) AS completed_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN total_orders ELSE 0 END) AS failed_orders,
    SUM(total_orders) AS total_orders,
    ROUND(SUM(CASE WHEN order_status = 'Completed' THEN total_orders ELSE 0 END)::NUMERIC / SUM(total_orders)::NUMERIC * 100, 2) AS successful_orders_percentage,
    ROUND(100 - (SUM(CASE WHEN order_status = 'Completed' THEN total_orders ELSE 0 END)::NUMERIC / SUM(total_orders)::NUMERIC * 100), 2) AS failed_orders_percentage
FROM sellers_report
GROUP BY 1, 2;
```
**Insight**: Top sellers show high order completion rates, but a few face elevated cancellation rates—warranting performance reviews.

### 12. Product Profit Margin
```sql
SELECT
    product_id,
    product_name,
    profit_margin,
    DENSE_RANK () OVER(ORDER BY profit_margin DESC) AS product_ranking
FROM (
    SELECT
        p.product_id,
        p.product_name,
        SUM(total_sale - (cogs * quantity)) / SUM(total_sale) * 100 AS profit_margin
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY 1, 2
);
```
**Insight**: Certain products yield significantly higher margins, guiding profitability-focused inventory and pricing strategies.

### 13. Most Returned Products
```sql
SELECT
    *,
    ROUND(total_returned::NUMERIC / total_units_sold::NUMERIC * 100, 2) return_percentage
FROM (
    SELECT
        p.product_id,
        p.product_name,
        COUNT(*) total_units_sold,
        SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) total_returned
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN orders o ON o.order_id = oi.order_id
    GROUP BY 1, 2
)
ORDER BY return_percentage DESC
LIMIT 10;
```
**Insight**: Return rates vary by product. High-return items may need review for quality, expectations, or listing accuracy.

### 14. Identify Returning vs. New Customers
```sql
SELECT
    *,
    CASE WHEN total_returns > 5 THEN 'Returning' ELSE 'New' END customer_type
FROM (
    SELECT
        CONCAT(c.first_name, ' ', c.last_name) full_name,
        COUNT(o.order_id) total_orders,
        SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) total_returns
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY 1
);
```
**Insight**: Customer behavior varies based on return activity—this can be useful for segmentation and tailored engagement.

### 15. Top 5 Customers by Orders per State
```sql
SELECT *
FROM (
    SELECT
        c.state,
        CONCAT(c.first_name, ' ', c.last_name) customers,
        COUNT(o.order_id) total_orders,
        SUM(oi.total_sale) total_sale,
        DENSE_RANK() OVER(PARTITION BY c.state ORDER BY COUNT(o.order_id) DESC) as rank
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN customers c ON c.customer_id = o.customer_id
    GROUP BY 1, 2
)
WHERE rank <= 5;
```
**Insight**: Top customers in each state reveal regional power users that drive local revenue.

### 16. Revenue by Shipping Provider
```sql
SELECT
    s.shipping_providers,
    COUNT(o.order_id) orders_handled,
    ROUND(SUM(oi.total_sale)) total_sale,
    ROUND(COALESCE(AVG(s.return_date - s.shipping_date), 0)) as average_days
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN shippings s ON s.order_id = o.order_id
GROUP BY 1;
```
**Insight**: Shipping providers vary in speed and volume. Some are slower despite handling fewer orders.

### 17. Products with Revenue Decline (2023 vs 2024)
```sql
WITH last_year_sale AS (
    SELECT p.product_id, p.product_name, SUM(oi.total_sale) revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2023
    GROUP BY 1, 2
),
current_year_sale AS (
    SELECT p.product_id, p.product_name, SUM(oi.total_sale) revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    WHERE EXTRACT(YEAR FROM o.order_date) = 2024
    GROUP BY 1, 2
)
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
```
**Insight**: Revenue decline detection helps flag underperforming products for reevaluation in 2024.

---

## 📘 What I Learned

This project was a comprehensive learning experience in data analysis, SQL, and business intelligence. Here's what I learned:

- How to write complex SQL queries using advanced features like CTEs, window functions, conditional logic, and subqueries.
- How to structure a real-world data analysis project with clear objectives, questions, and measurable outcomes.
- How to extract actionable business insights from raw datasets using SQL alone.
- The importance of validating data relationships and using joins correctly to link multiple tables.
- How to implement automation in SQL with stored procedures using PL/pgSQL.
- Practical debugging and optimization of queries using PostgreSQL.
- How to build stored procedures like `add_sales` that automate inventory and order management in a real-world scenario.
- How to present technical findings clearly and professionally through documentation and structure.


## 🛒 Stored Procedure: `add_sales`

As part of this project, I created a PostgreSQL stored procedure named `add_sales` to simulate real-time product transactions and automate inventory updates.

### 🔄 How It Works
This procedure replicates the logic of placing an order on an e-commerce platform:
1. It first checks the inventory to confirm that enough stock is available for the requested product.
2. If the product is available:
   - A new entry is added to the `orders` table.
   - A related entry is created in the `order_items` table including the calculated total sale.
   - The `inventory` table is updated to reflect the reduced stock.
   - A confirmation notice is displayed with the product name.
3. If the product is not in stock, a notice informs the user that the product is unavailable.

### 📜 Procedure Code
```sql
CREATE OR REPLACE PROCEDURE add_sales (
    p_order_id INT,
    p_customer_id INT,
    p_seller_id INT,
    p_order_item_id INT,
    p_product_id INT,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
    v_price FLOAT;
    v_product_name VARCHAR(50);
BEGIN
    SELECT price, product_name
    INTO v_price, v_product_name
    FROM products
    WHERE product_id = p_product_id;

    SELECT COUNT(*)
    INTO v_count
    FROM inventory
    WHERE product_id = p_product_id AND stock >= p_quantity;

    IF v_count > 0 THEN
        INSERT INTO orders (
            order_id, order_date, customer_id, seller_id
        )
        VALUES (
            p_order_id, CURRENT_DATE, p_customer_id, p_seller_id
        );

        INSERT INTO order_items (
            order_item_id, order_id, product_id, quantity, price_per_unit, total_sale
        )
        VALUES (
            p_order_item_id, p_order_id, p_product_id, p_quantity, v_price, v_price * p_quantity
        );

        UPDATE inventory
        SET stock = stock - p_quantity
        WHERE product_id = p_product_id;

        RAISE NOTICE 'Thank you, product "%" has been added and inventory updated.', v_product_name;
    ELSE
        RAISE NOTICE 'Product "%" is not available at the moment.', v_product_name;
    END IF;
END;
$$;
```

### 🧪 Example Usage
```sql
CALL add_sales(25001, 2, 5, 26001, 1, 10);
SELECT product_id, stock FROM inventory WHERE product_id = 1;
```

This procedure simulates a core part of e-commerce operations and demonstrates how SQL can be used not only for analysis but also for backend logic automation.

### 🧠 What I Learned
- How to declare and use variables inside a stored procedure.
- How to perform conditional logic and error handling in `PL/pgSQL`.
- How to use transactions to automate business processes in a database environment.
- How stored procedures can encapsulate complex logic and ensure consistency across related tables.

## ✅ Conclusion

This SQL project demonstrates how data can inform strategic decisions in an e-commerce environment. By analyzing Amazon-style marketplace data, I was able to:

- Uncover best-selling products and top-performing categories.
- Analyze revenue trends, profit margins, and customer value.
- Identify operational inefficiencies such as shipping delays and inventory shortages.
- Use SQL not just for querying, but also for creating database functionality through a stored procedure.

From querying to automation with the `add_sales` procedure, this project showcases how data analysis and backend logic can bring clarity to complex business questions and optimize decision-making.

## 📜 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
