-- Create the tables to be added into the database

CREATE TABLE public.category -- parent table
(
    category_id INT PRIMARY KEY,
    category_name VARCHAR(30)
);

CREATE TABLE public.customers -- parent table
(
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    state VARCHAR(50)
);
-- add the address column and set default value
ALTER TABLE customers
ADD COLUMN address VARCHAR(50) DEFAULT ('xxxx');


CREATE TABLE public.sellers -- parent table
(
    seller_id INT PRIMARY KEY,
    seller_name VARCHAR(50),
    origin VARCHAR(50)
);

CREATE TABLE public.products
(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price FLOAT,
    cogs INT, -- mistake here so I need to alter it
    category_id INT, -- Foreign Key
    CONSTRAINT products_fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);
-- DROP TABLE products cannot perform becuase other objects depend on it, so alter it instead
ALTER TABLE products
ALTER COLUMN cogs TYPE FLOAT;

CREATE TABLE public.orders
(
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT, -- Foreign Key
    order_status VARCHAR(50),
    product_id INT, -- Foreign Key (this is a mistake)
    seller_id INT, -- Foreign Key
    CONSTRAINT orders_fk_seller FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
    CONSTRAINT orders_fk_products FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- order of `order status` and `seller_id` should be switched (wrong order)
-- product_id should be dropped
ALTER TABLE orders
DROP COLUMN order_status, 
DROP COLUMN product_id, 
DROP COLUMN seller_id;
-- now add the columns properly
ALTER TABLE orders
ADD COLUMN seller_id INT,
ADD COLUMN order_status VARCHAR(50);
-- add customer_id and seller_id constraint (was dropped before)
ALTER TABLE orders
ADD CONSTRAINT orders_fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
ADD CONSTRAINT orders_fk_sellers FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);


CREATE TABLE public.order_items
(
    order_item_id INT PRIMARY KEY,
    order_id INT, -- Foreign Key
    product_id INT, -- Foreign Key
    quantity INT,
    price_per_unit FLOAT,
    CONSTRAINT order_items_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT order_items_fk_products FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE public.payments
(
    payment_id INT PRIMARY KEY,
    order_id INT, -- Foreign Key
    payment_date DATE,
    payment_status VARCHAR(50),
    CONSTRAINT payments_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE public.shippings
(
    shipping_id INT PRIMARY KEY,
    order_id INT, -- Foreign Key
    shipping_date DATE,
    return_date DATE,
    shipping_providers VARCHAR(50),
    delivery_status VARCHAR(50),
    CONSTRAINT shippings_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE public.inventory
(
    inventory_id INT PRIMARY KEY,
    product_id INT, -- Foreign Key
    stock INT,
    warehouse_id INT,
    last_stock_date DATE,
    CONSTRAINT inventory_fk_products FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Set ownership of the tables to postgres user
ALTER TABLE public.category OWNER to postgres;
ALTER TABLE public.customers OWNER to postgres;
ALTER TABLE public.sellers OWNER to postgres;
ALTER TABLE public.products OWNER to postgres;
ALTER TABLE public.orders OWNER to postgres;
ALTER TABLE public.order_items OWNER to postgres;
ALTER TABLE public.payments OWNER to postgres;
ALTER TABLE public.shippings OWNER to postgres;
ALTER TABLE public.inventory OWNER to postgres;