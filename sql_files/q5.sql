/*----------
Q5. Customers with No Purchases
Find customers who have registered but never placed an order.
----------*/
SELECT * 
FROM customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
);