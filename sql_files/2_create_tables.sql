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
    state VARCHAR(50),
    address VARCHAR(50) DEFAULT ('xxxx') -- in case value is missing
);

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
    cogs INT,
    category_id INT, -- Foreign Key
    CONSTRAINT products_fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE public.orders
(
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT, -- Foreign Key
    order_status VARCHAR(50),
    product_id INT, -- Foreign Key
    seller_id INT, -- Foreign Key
    CONSTRAINT orders_fk_seller FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
    CONSTRAINT orders_fk_products FOREIGN KEY (product_id) REFERENCES products(product_id)
);

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