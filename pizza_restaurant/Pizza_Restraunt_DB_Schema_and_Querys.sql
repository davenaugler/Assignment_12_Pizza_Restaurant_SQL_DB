-- Assignment 12: Database Schema for Pizza Restaurant
-- --------------------------------------

# Q1: Create database schema for a new pizza restaurant.
## DATABASE
CREATE DATABASE pizza_restaurant;
USE pizza_restaurant;
-- --------------------------------------


# Q2: Create your database based on your design in MySQL
## TABLES
-- CUSTOMERS table
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(20) UNIQUE ,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ORDERS table
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_date_time TIMESTAMP DEFAULT NOW(),
    customer_id INT NOT NULL,
    FOREIGN KEY(customer_id) REFERENCES customers(id)
);

-- PIZZAS table
CREATE TABLE pizzas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(7,2) CHECK (price >0) NOT NULL
);

-- ITEMS ORDERED table (join table)
CREATE TABLE items_ordered (
    id INT PRIMARY KEY AUTO_INCREMENT,
    quantity INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id INT NOT NULL,
    FOREIGN KEY(order_id) REFERENCES orders(id),
    FOREIGN KEY(pizza_id) REFERENCES pizzas(id)
);
-- --------------------------------------


# Q3: Populate your database with three orders (is it 3 orders or 4?)
-- INSERT INTO customers
-- ------
 INSERT INTO customers (id, first_name, last_name, phone_number, created_at)
 VALUES (1, 'Trevor', 'Page', 2265554982, '2023-09-09 01:00:00'),
        (2, 'John', 'Doe', 555555498, '2023-09-09 02:00:00');

SELECT * FROM customers;

SELECT customers.id, customers.first_name, customers.last_name,
       CONCAT('(', SUBSTRING(phone_number, 1, 3), ') ',
              SUBSTRING(phone_number, 4, 3), '-',
              SUBSTRING(phone_number, 7)) AS phone_number,
    DATE_FORMAT(customers.created_at, '%M %d, %Y %r') AS created_at
FROM customers;
-- ------

-- INSERT INTO orders
-- ------
INSERT INTO orders (orders.id, orders.order_date_time, orders.customer_id)
VALUES (1, '2023-09-10 09:47:00', 1),
       (2, '2023-09-10 13:20:00', 2),
       (3, '2023-09-10 09:47:00', 1),
       (4, '2023-10-10 10:37:00', 2);

SELECT * FROM orders;
-- Display: order_id | order_date_time | customer_id | customer_name | ORDER BY order_id
SELECT orders.id AS order_id, DATE_FORMAT(orders.order_date_time, '%M %d, %Y %r') AS order_date_time,
       orders.customer_id, CONCAT(customers.first_name, SPACE(1), customers.last_name) AS customer_name FROM orders
JOIN customers ON orders.customer_id = customers.id
ORDER BY order_id;
-- ------

-- INSERT INTO pizzas
-- ------
INSERT INTO pizzas (id, name, price)
VALUES (1, 'Pepperoni & Cheese', 7.99),
       (2, 'Vegetarian', 9.99),
       (3, 'Meat Lovers', 14.99),
       (4, 'Hawaiian', 12.99);

SELECT * FROM pizzas;
-- -------------------------------------
SELECT * FROM items_ordered;
SELECT * FROM orders;

INSERT INTO items_ordered (items_ordered.id, items_ordered.quantity, items_ordered.order_id, items_ordered.pizza_id)
VALUES (1, 1, 1, 1),
       (2, 1, 1, 3),
       -- -----------
       (3, 1, 2, 2),
       (4, 2, 2, 3),
       -- -----------
       (5, 1, 3, 3),
       (6, 1, 3, 4),
       -- -----------
       (7, 3, 4, 2),
       (8, 1, 4, 4);

SELECT * FROM items_ordered;

-- DISPLAY ALL ORDERS WITH customer_name | customer_phone_number | Order_date_time | Pizza_order

SELECT
    CONCAT(customers.first_name, ' ', customers.last_name) AS customer,
    CONCAT('(', SUBSTRING(phone_number, 1, 3), ') ',
              SUBSTRING(phone_number, 4, 3), '-',
              SUBSTRING(phone_number, 7)) AS phone_number,
    DATE_FORMAT(orders.order_date_time, '%M %d, %Y at %r') AS order_date_time,
    GROUP_CONCAT(CONCAT(items_ordered.quantity, 'x ', pizzas.name) SEPARATOR ', ') AS pizza_order
FROM
    orders
JOIN
    customers ON orders.customer_id = customers.id
JOIN
    items_ordered ON orders.id = items_ordered.order_id
JOIN
    pizzas ON items_ordered.pizza_id = pizzas.id
GROUP BY
    orders.id
ORDER BY
    orders.id;
-- -----------------------------------------------------


-- Q4: Now the restaurant would like to know which customers are spending the most money
--    at their establishment. Write a SQL query which will tell them how much money each
--    individual customer has spent at their restaurant
SELECT
    CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name,
    CONCAT('$', FORMAT(SUM(items_ordered.quantity * pizzas.price), 2)) AS total_spent
FROM
    customers
JOIN
    orders ON customers.id = orders.customer_id
JOIN
    items_ordered ON orders.id = items_ordered.order_id
JOIN
    pizzas ON items_ordered.pizza_id = pizzas.id
GROUP BY
    customers.id
ORDER BY
    total_spent DESC;
-- -----------------------------------------------------


-- Q5: Modify the query from Q4 to separate the orders not just by customer,
--    but also by date so they can see how much each customer is ordering on which date.
SELECT
    CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name,
    DATE_FORMAT(orders.order_date_time, '%M %d, %Y at %r') AS order_date_time,
    CONCAT('$', FORMAT(SUM(items_ordered.quantity * pizzas.price), 2)) AS total_spent
FROM
    customers
JOIN
    orders ON customers.id = orders.customer_id
JOIN
    items_ordered ON orders.id = items_ordered.order_id
JOIN
    pizzas ON items_ordered.pizza_id = pizzas.id
GROUP BY
    customers.id, orders.order_date_time
ORDER BY
    customer_name, order_date_time;
-- -----------------------------------------------------





