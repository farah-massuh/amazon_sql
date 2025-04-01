/*----------
Q8. Inventory Stock Alerts
Query products with stock levels below a certain threshold (e.g., less than 10 units).
Include last restock date and warehouse information.
----------*/
SELECT
    i.inventory_id,
    p.product_name,
    i.stock current_stock_left,
    i.last_stock_date,
    i.warehouse_id
FROM inventory i
JOIN products p ON p.product_id = i.product_id
WHERE i.stock < 10;