-- Populate each of the tables with their respective data and make sure data is displayed

-- category table
\copy category FROM '/Users/farahmassuh/Desktop/amazon_sql/csv_files/category.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT * FROM category LIMIT 5;

-- customers table
\copy customers FROM '/Users/farahmassuh/Desktop/amazon_sql/csv_files/customers.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT * FROM customers LIMIT 5;

-- inventory table
\copy inventory FROM '/Users/farahmassuh/Desktop/amazon_sql/csv_files/inventory.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT * FROM inventory LIMIT 5;

-- order_items table
\copy order_items FROM '/Users/farahmassuh/Desktop/amazon_sql/csv_files/order_items.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT * FROM order_items LIMIT 5;

-- orders table
\copy orders FROM '/Users/farahmassuh/Desktop/amazon_sql/csv_files/orders.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT * FROM orders LIMIT 5;

-- payments table
\copy payments FROM '/Users/farahmassuh/Desktop/amazon_sql/csv_files/payments.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT * FROM payments LIMIT 5;

-- products table
\copy products FROM '/Users/farahmassuh/Desktop/amazon_sql/csv_files/products.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT * FROM products LIMIT 5;

-- sellers table
\copy sellers FROM '/Users/farahmassuh/Desktop/amazon_sql/csv_files/sellers.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT * FROM sellers LIMIT 5;

-- shipping table
\copy shippings FROM '/Users/farahmassuh/Desktop/amazon_sql/csv_files/shipping.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
SELECT * FROM shippings LIMIT 5;