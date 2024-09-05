CREATE DATABASE pizzahut;
USE pizzahut;

CREATE TABLE orders(
order_id INT NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL,
primary key(order_id) 
);

CREATE TABLE order_details(
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
primary key(order_details_id) 
);

-- Retrieve the total number of orders placed
SELECT COUNT(order_id) AS 'Total Orders' FROM orders;

-- Calculate the total revenue generated form pizza sales
Select Round(SUM(order_details.quantity * pizzas.price),2) as Total_Revenue
FROM order_details JOIN pizzas
ON pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest priced pizza
SELECT pizza_types.name, pizzas.price
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC LIMIT 1;

-- identify the most common pizza size ordered
SELECT pizzas.size, COUNT(order_details.order_details_id) AS Order_count
FROM pizzas JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size ORDER BY order_count DESC;

-- list the top 5 most ordered pizza type along with their quantities
SELECT pizza_types.name, SUM(order_details.quantity) AS total_quantity
FROM pizza_types JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name ORDER BY total_quantity DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered
SELECT pizza_types.category, SUM(order_details.quantity) AS Quantity
FROM pizza_types JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details 
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category 
ORDER BY Quantity DESC;

-- Determination the distribution of orders by hour of the day
SELECT HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY HOUR(order_time);

-- Join  relevant tables to find the category wise distribution of pizzas
SELECT category, COUNT(name) FROM pizza_types
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day
SELECT AVG(quantity)
FROM(SELECT orders.order_date, SUM(order_details.quantity) AS quantity
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue
SELECT  pizza_types.name,
SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types JOIN
pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC LIMIT 3;