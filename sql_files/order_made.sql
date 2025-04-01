/*----------
Order Made (Store Procedure)
Create a function as soon as the product is sold.
The same quantity should be reduced from the inventory table.
After adding any sales records it should update the stock in the inventory table based on the product and quantity purchased.
----------*/
CREATE OR REPLACE PROCEDURE order_made
(
    p_order_id INT,
    p_customer_id INT,
    p_seller_id INT,
    p_order_item_id INT,
    p_product_id INT,
    p_quantity INT
)

LANGUAGE plpgsql
AS 
$$

DECLARE
    v_count INT;
    v_price FLOAT;
    v_product_name VARCHAR(50);
BEGIN
    -- Get price and product name based on product_id
    SELECT 
        price, product_name  -- corrected from 'price_name' to 'product_name'
    INTO v_price, v_product_name
    FROM products
    WHERE product_id = p_product_id;

    -- Check inventory stock
    SELECT COUNT(*)
    INTO v_count
    FROM inventory
    WHERE product_id = p_product_id AND stock >= p_quantity;

    IF v_count > 0 THEN
        -- Insert into orders
        INSERT INTO orders (
            order_id,
            order_date,
            customer_id,
            seller_id
        )
        VALUES (
            p_order_id,
            CURRENT_DATE,
            p_customer_id,
            p_seller_id
        );

        -- Insert into order_items
        INSERT INTO order_items (
            order_item_id,
            order_id,
            product_id,
            quantity,
            price_per_unit,
            total_sale
        )
        VALUES (
            p_order_item_id,
            p_order_id,
            p_product_id,
            p_quantity,
            v_price,
            v_price * p_quantity
        );

        -- Update inventory
        UPDATE inventory
        SET stock = stock - p_quantity
        WHERE product_id = p_product_id;

        RAISE NOTICE 'Thank you, product "%" has been added and inventory updated.', v_product_name;
    ELSE
        RAISE NOTICE 'Product "%" is not available at the moment.', v_product_name;
    END IF;
END;
$$;

-- IMPLEMENTING FUNCTION
-- Reference
-- (
--     p_order_id INT,
--     p_customer_id INT,
--     p_seller_id INT,
--     p_order_item_id INT,
--     p_product_id INT,
--     p_quantity INT
-- )

-- use this to reset value if stock is 0
UPDATE inventory
SET stock = 100
WHERE product_id = 1;
--

-- TESTING --

-- first call
call order_made
(
    25001, 2, 5, 26001, 1, 10
);
-- display result
SELECT
    product_id,
    stock
FROM inventory
WHERE product_id = 1;

-- second call
call order_made
(
    25002, 2, 5, 26002, 1, 12
);
-- display result
SELECT
    product_id,
    stock
FROM inventory
WHERE product_id = 1;

-- third call
call order_made
(
    25003, 2, 5, 26003, 1, 3
);
-- display result
SELECT
    product_id,
    stock
FROM inventory
WHERE product_id = 1;

-- fourth call
call order_made
(
    25004, 2, 5, 26004, 1, 40
);
-- display result
SELECT *
FROM inventory
WHERE product_id = 1;

