-- Task 3: SQL for Data Analysis
-- Tool: SQLite
-- Dataset: Ecommerce SQL Database (created for this task)
-- Author: Abdul Subhan

PRAGMA foreign_keys = ON;

-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

DROP VIEW IF EXISTS customer_revenue;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    city TEXT,
    signup_date TEXT NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    price REAL NOT NULL CHECK(price >= 0)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK(quantity > 0),
    unit_price REAL NOT NULL CHECK(unit_price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Sample customers
INSERT INTO customers VALUES
(1, 'Aarav', 'aarav@example.com', 'Hyderabad', '2026-01-10'),
(2, 'Sara', 'sara@example.com', 'Bengaluru', '2026-01-15'),
(3, 'Rahul', 'rahul@example.com', 'Mumbai', '2026-02-01'),
(4, 'Aisha', 'aisha@example.com', 'Hyderabad', '2026-02-18'),
(5, 'Vikram', 'vikram@example.com', 'Chennai', '2026-03-02'),
(6, 'Zoya', 'zoya@example.com', 'Delhi', '2026-03-10'),
(7, 'Kabir', 'kabir@example.com', 'Pune', '2026-03-22'),
(8, 'Meera', 'meera@example.com', 'Hyderabad', '2026-04-05');

-- Sample products
INSERT INTO products VALUES
(1, 'Wireless Mouse', 'Electronics', 799),
(2, 'Mechanical Keyboard', 'Electronics', 2499),
(3, 'USB-C Hub', 'Electronics', 1499),
(4, 'Notebook', 'Stationery', 199),
(5, 'Backpack', 'Accessories', 1299),
(6, 'Water Bottle', 'Accessories', 599),
(7, 'Desk Lamp', 'Home', 999),
(8, 'Webcam', 'Electronics', 1999);

-- Sample orders
INSERT INTO orders VALUES
(101, 1, '2026-04-10', 'Delivered'),
(102, 2, '2026-04-11', 'Delivered'),
(103, 1, '2026-04-15', 'Delivered'),
(104, 3, '2026-04-18', 'Shipped'),
(105, 4, '2026-04-20', 'Delivered'),
(106, 5, '2026-04-22', 'Cancelled'),
(107, 6, '2026-04-25', 'Delivered'),
(108, 7, '2026-04-27', 'Shipped'),
(109, 8, '2026-05-01', 'Delivered'),
(110, 2, '2026-05-03', 'Delivered');

-- Sample order items
INSERT INTO order_items VALUES
(1,101,1,2,799),(2,101,4,3,199),
(3,102,2,1,2499),(4,102,6,2,599),
(5,103,3,1,1499),(6,103,5,1,1299),
(7,104,8,1,1999),(8,104,4,5,199),
(9,105,5,2,1299),(10,105,7,1,999),
(11,106,1,1,799),
(12,107,6,3,599),(13,107,4,2,199),
(14,108,7,2,999),(15,108,1,1,799),
(16,109,2,1,2499),(17,109,3,2,1499),
(18,110,8,1,1999),(19,110,6,1,599);

-- ============================================================
-- 2. SELECT, WHERE, ORDER BY
-- ============================================================

SELECT customer_id, customer_name, city
FROM customers
ORDER BY customer_id;

SELECT product_name, category, price
FROM products
WHERE price > 1000
ORDER BY price DESC;

-- ============================================================
-- 3. GROUP BY + AGGREGATE FUNCTIONS
-- ============================================================

SELECT p.category,
       SUM(oi.quantity * oi.unit_price) AS revenue,
       AVG(oi.unit_price) AS avg_unit_price
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.category
ORDER BY revenue DESC;

-- ============================================================
-- 4. INNER JOIN
-- ============================================================

SELECT o.order_id, c.customer_name, o.order_date, o.status
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date;

-- ============================================================
-- 5. LEFT JOIN
-- ============================================================

SELECT c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC, c.customer_name;

-- ============================================================
-- 6. SUBQUERY
-- Customers whose non-cancelled revenue is above the average
-- customer revenue.
-- ============================================================

SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status <> 'Cancelled'
    GROUP BY o.customer_id
    HAVING SUM(oi.quantity * oi.unit_price) >
           (SELECT AVG(customer_total)
            FROM (
                SELECT o2.customer_id,
                       SUM(oi2.quantity * oi2.unit_price) AS customer_total
                FROM orders o2
                JOIN order_items oi2 ON oi2.order_id = o2.order_id
                WHERE o2.status <> 'Cancelled'
                GROUP BY o2.customer_id
            ))
);

-- ============================================================
-- 7. AVERAGE / REVENUE PER USER
-- ============================================================

SELECT ROUND(
           SUM(oi.quantity * oi.unit_price) /
           COUNT(DISTINCT o.customer_id), 2
       ) AS average_revenue_per_user
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled';

-- Detailed revenue by user:
SELECT c.customer_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.customer_name
ORDER BY revenue DESC;

-- ============================================================
-- 8. VIEW FOR ANALYSIS
-- ============================================================

CREATE VIEW customer_revenue AS
SELECT c.customer_id,
       c.customer_name,
       COUNT(DISTINCT o.order_id) AS total_orders,
       ROUND(COALESCE(SUM(
           CASE WHEN o.status <> 'Cancelled'
                THEN oi.quantity * oi.unit_price ELSE 0 END
       ), 0), 2) AS total_revenue
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.customer_name;

SELECT customer_name, total_orders, total_revenue
FROM customer_revenue
ORDER BY total_revenue DESC;

-- ============================================================
-- 9. INDEXES FOR QUERY OPTIMIZATION
-- ============================================================

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_products_category ON products(category);

-- Check the query plan:
EXPLAIN QUERY PLAN
SELECT o.order_id, c.customer_name
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.customer_id = 1;
