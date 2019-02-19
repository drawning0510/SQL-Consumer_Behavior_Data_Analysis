
/**********************************************************
DSO599 SQL Class for Business Analyst
                      
Capstone Project - Supermarket Data Analysis using SQL
**********************************************************/
/**********************************************
                Create database
**********************************************/

#1
-- create database;
CREATE DATABASE Supermarket;

-- use database;
USE Supermarket;

/*************************************** 
 Create tables
 ***************************************/

-- Clearn up all existed table if we create them before
DROP TABLE IF EXISTS aisle, department, product, orders, order_product;

-- Create aisle table
CREATE TABLE IF NOT EXISTS aisle (
  id    					INT(11)        	NOT NULL,
  aisle						VARCHAR(100)	NOT NULL,
  PRIMARY KEY 				(id)
);

-- Load data into table from csv data file
LOAD DATA LOCAL INFILE 
'C:/Users/drawn/OneDrive/Desktop/Ian''s/2018 Spring/DSO 599/Capstone Project/aisles.csv' 
INTO TABLE aisle
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- Create department table
CREATE TABLE IF NOT EXISTS department (
  id           				INT(11) 		NOT NULL,
  department				VARCHAR(30)		NOT NULL,
  PRIMARY KEY   			(id)
);

-- Load data into table from csv data file
LOAD DATA LOCAL INFILE 
'C:/Users/drawn/OneDrive/Desktop/Ian''s/2018 Spring/DSO 599/Capstone Project/departments.csv' 
INTO TABLE department
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- create product table
CREATE TABLE IF NOT EXISTS product (
  id           				INT(11) 		NOT NULL,
  name          			VARCHAR(200)	NOT NULL,
  aisle_id      			INT(11) 		NOT NULL,
  department_id				INT(11) 		NOT NULL,
  PRIMARY KEY  				(id),
  CONSTRAINT fk_aisle_id FOREIGN KEY (aisle_id) REFERENCES aisle (id) ON DELETE CASCADE,                    
  CONSTRAINT fk_department_id FOREIGN KEY (department_id) REFERENCES department (id) ON DELETE CASCADE
);

-- Load data into table from csv data file
LOAD DATA LOCAL INFILE 
'C:/Users/drawn/OneDrive/Desktop/Ian''s/2018 Spring/DSO 599/Capstone Project/products.csv' 
INTO TABLE product
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- Create orders table
CREATE TABLE IF NOT EXISTS orders
(
  id                		INT(11) 		NOT NULL,
  user_id       			INT(11) 		NOT NULL,
  eval_set          		VARCHAR(10)		NOT NULL,
  order_number            	INT(11) 		NOT NULL,
  order_dow       			INT(11),
  order_hour_of_day         INT(11),
  days_since_prior_order	INT(11),
  PRIMARY KEY (id)
 );

-- Load data into table from csv data file
drop table orders;
LOAD DATA LOCAL INFILE 
'C:/Users/drawn/OneDrive/Desktop/Ian''s/2018 Spring/DSO 599/Capstone Project/orders.csv' 
INTO TABLE orders
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES
(id, user_id, eval_set, order_number, order_dow, order_hour_of_day, @vdays_since_prior_order)
SET days_since_prior_order = nullif(@vdays_since_prior_order,'') 
;
 
-- Create order_product table 
 CREATE TABLE IF NOT EXISTS order_product
(
    order_id                INT(11) NOT NULL,
    product_id				INT(11) NOT NULL,
    add_to_chart_order		INT(11) NOT NULL,
    reordered				INT(11) NOT NULL,
    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,  
    CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES product (id) ON DELETE CASCADE
);

-- Load data into table from csv data file
LOAD DATA LOCAL INFILE 
'C:/Users/drawn/OneDrive/Desktop/Ian''s/2018 Spring/DSO 599/Capstone Project/order_products.csv' 
INTO TABLE order_product
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;

/**********************************************
                Assignments
**********************************************/
#2
-- Write a query to select the top 10 products sales for each day in the week ( Monday to Friday), 
-- which includes product id, product name, total order amount and the day (Mon to Fri)
(SELECT p.id AS product_id, p.name AS product_name, count(*) AS total_order_amount,
(CASE
WHEN o.order_dow = 0 THEN 'Sun' 
WHEN o.order_dow = 1 THEN 'Mon'
WHEN o.order_dow = 2 THEN 'Tue'
WHEN o.order_dow = 3 THEN 'Wed'
WHEN o.order_dow = 4 THEN 'Thu'
WHEN o.order_dow = 5 THEN 'Fri'
else 'Sat' end) AS day_in_the_week
FROM product AS p INNER JOIN order_product AS op JOIN orders AS o 
ON p.id = op.order_id AND op.product_id = o.id
WHERE o.order_dow = 1
GROUP BY p.id ORDER BY total_order_amount DESC LIMIT 10)
UNION
(SELECT p.id AS product_id, p.name AS product_name, count(*) AS total_order_amount, 
(CASE
WHEN o.order_dow = 0 THEN 'Sun' 
WHEN o.order_dow = 1 THEN 'Mon'
WHEN o.order_dow = 2 THEN 'Tue'
WHEN o.order_dow = 3 THEN 'Wed'
WHEN o.order_dow = 4 THEN 'Thu'
WHEN o.order_dow = 5 THEN 'Fri'
else 'Sat' end) AS day_in_the_week
FROM product AS p INNER JOIN order_product AS op JOIN orders AS o 
ON p.id = op.order_id AND op.product_id = o.id
WHERE o.order_dow = 2
GROUP BY p.id ORDER BY total_order_amount DESC LIMIT 10)
UNION
(SELECT p.id AS product_id, p.name AS product_name, count(*) AS total_order_amount, 
(CASE
WHEN o.order_dow = 0 THEN 'Sun' 
WHEN o.order_dow = 1 THEN 'Mon'
WHEN o.order_dow = 2 THEN 'Tue'
WHEN o.order_dow = 3 THEN 'Wed'
WHEN o.order_dow = 4 THEN 'Thu'
WHEN o.order_dow = 5 THEN 'Fri'
else 'Sat' end) AS day_in_the_week
FROM product AS p INNER JOIN order_product AS op JOIN orders AS o 
ON p.id = op.order_id AND op.product_id = o.id
WHERE o.order_dow = 3
GROUP BY p.id ORDER BY total_order_amount DESC LIMIT 10)
UNION
(SELECT p.id AS product_id, p.name AS product_name, count(*) AS total_order_amount, 
(CASE
WHEN o.order_dow = 0 THEN 'Sun' 
WHEN o.order_dow = 1 THEN 'Mon'
WHEN o.order_dow = 2 THEN 'Tue'
WHEN o.order_dow = 3 THEN 'Wed'
WHEN o.order_dow = 4 THEN 'Thu'
WHEN o.order_dow = 5 THEN 'Fri'
else 'Sat' end) AS day_in_the_week
FROM product AS p INNER JOIN order_product AS op JOIN orders AS o 
ON p.id = op.order_id AND op.product_id = o.id
WHERE o.order_dow = 4
GROUP BY p.id ORDER BY total_order_amount DESC LIMIT 10)
UNION
(SELECT p.id AS product_id, p.name AS product_name, count(*) AS total_order_amount, 
(CASE
WHEN o.order_dow = 0 THEN 'Sun' 
WHEN o.order_dow = 1 THEN 'Mon'
WHEN o.order_dow = 2 THEN 'Tue'
WHEN o.order_dow = 3 THEN 'Wed'
WHEN o.order_dow = 4 THEN 'Thu'
WHEN o.order_dow = 5 THEN 'Fri'
else 'Sat' end) AS day_in_the_week
FROM product AS p INNER JOIN order_product AS op JOIN orders AS o 
ON p.id = op.order_id AND op.product_id = o.id
WHERE o.order_dow = 5
GROUP BY p.id ORDER BY total_order_amount DESC LIMIT 10);

#3
-- Write a query to display the 5 most popular products in each aisle from Monday to Friday. 
-- Please list product id, aisle and day in the week.
SET @num := 0, @day_in_the_week := '';
SELECT product_id, aisle, day_in_the_week
FROM (
	SELECT product_id, aisle, day_in_the_week,
	@num := IF(@day_in_the_week = day_in_the_week, @num + 1, 1) AS row_number,
	@day_in_the_week := day_in_the_week AS dummy
	FROM(
		SELECT p.id AS product_id, a.aisle,
		(CASE
		WHEN o.order_dow = 0 THEN 'Sun' 
		WHEN o.order_dow = 1 THEN 'Mon'
		WHEN o.order_dow = 2 THEN 'Tue'
		WHEN o.order_dow = 3 THEN 'Wed'
		WHEN o.order_dow = 4 THEN 'Thu'
		WHEN o.order_dow = 5 THEN 'Fri'
		else 'Sat' end) AS day_in_the_week
		FROM product AS p INNER JOIN order_product AS op JOIN orders AS o JOIN aisle AS a
		ON p.id = op.order_id AND op.product_id = o.id AND a.id = p.aisle_id
		GROUP BY p.id ORDER BY a.aisle, o.order_dow, COUNT(*) DESC
        ) AS x
	) 
AS y WHERE y.row_number <= 5;

#4
-- Write query to select the top 10 products that the users have the most frequent reorder rate. 
-- You only need to give the results with product id.
SELECT product_id FROM order_product 
GROUP BY product_id ORDER BY (SUM(reordered) / COUNT(*)) DESC LIMIT 10;

/**********************************************
                Business Case Study
**********************************************/

#5.1
-- Please create a report to show the shopper’s aisle list for each order.
SELECT op.order_id, p.aisle_id  
FROM order_product AS op INNER JOIN product AS p ON p.id = op.product_id
GROUP BY order_id, aisle_id ORDER BY order_id, add_to_chart_order;

#5.2
-- Please do some research, find the most popular shopping path.

# Let's only focus on the most popular shopping path among top 50 aisles and top 100 products

-- Create a shopping path table that shows the shopper’s aisle list for each order
CREATE TABLE IF NOT EXISTS shopping_path(
SELECT op.order_id, p.aisle_id  
FROM order_product AS op INNER JOIN product AS p ON p.id = op.product_id
GROUP BY order_id, aisle_id ORDER BY order_id, add_to_chart_order);

-- Create a table of top 50 aisle
CREATE TABLE IF NOT EXISTS top50aisle(
SELECT aisle_id, COUNT(*) FROM shopping_path 
GROUP BY aisle_id ORDER BY COUNT(*) DESC LIMIT 50);

-- Create a table of top 100 products
CREATE TABLE IF NOT EXISTS top100product(
SELECT product_id, COUNT(*) FROM order_product 
GROUP BY product_id ORDER BY COUNT(*) DESC LIMIT 100);

-- Create a shopping path table that contains only top 100 products in top 50 aisles
CREATE TABLE IF NOT EXISTS shopping_path_top(
SELECT op.order_id, p.aisle_id  
FROM order_product AS op INNER JOIN product AS p JOIN top100product AS tp JOIN top50aisle AS ta
ON p.id = op.product_id AND op.product_id = tp.product_id AND p.aisle_id = ta.aisle_id
GROUP BY order_id, aisle_id ORDER BY order_id, add_to_chart_order);

-- Let's do a data exploring
SELECT COUNT, COUNT(*) AS frequency from(
SELECT order_id, COUNT(*) AS COUNT FROM shopping_path_top 
GROUP BY order_id) AS T
GROUP BY COUNT ORDER BY COUNT;
-- The majority of customers go to 1, 2 or 3 aisles per order, 
-- so let's focus on the combination of 2 aisles as well as 3 aisles

# A path with 2 aisles

-- Create a table of orders that contain exact 2 aisles
CREATE TABLE IF NOT EXISTS aisles_2(
SELECT order_id, COUNT(*) AS COUNT FROM shopping_path_top 
GROUP BY order_id HAVING COUNT(*) = 2);

-- Filter the shopping path table to orders that contain exact 2 aisles
CREATE TABLE IF NOT EXISTS shopping_path_top_2(
SELECT s.* FROM shopping_path_top AS s INNER JOIN aisles_2 AS a ON s.order_id = a.order_id);

-- Create a table of shopping path with rownumber in each order
SET @num := 0, @order_id := '';
CREATE TABLE IF NOT EXISTS shopping_path_top_2_rownumber(
SELECT *, 	
@num := IF(@order_id = order_id, @num + 1, 1) AS row_number,
@order_id := order_id AS dummy
FROM (SELECT * FROM shopping_path_top_2 ORDER BY order_id, aisle_id) AS x);

-- Create a table that lists all the combinations of pair of aisles in each order
CREATE TABLE IF NOT EXISTS combination_of_aisles_2 (
SELECT c1.order_id, c1.aisle_id AS aisle1_id, c2.aisle_id AS aisle2_id
FROM shopping_path_top_2_rownumber AS c1 INNER JOIN shopping_path_top_2_rownumber AS c2 
ON c1.order_id = c2.order_id
WHERE c1.row_number < c2.row_number);

-- Create a table of the most popupar shopping path with exact 2 aisles
SET @num := 0;
CREATE TABLE IF NOT EXISTS popular_path_2(
SELECT @num := if(TRUE, @num + 1, 1) as rank, aisle1_name, aisle2_name FROM(
	SELECT a1.aisle AS aisle1_name, a2.aisle AS aisle2_name
	FROM combination_of_aisles_2 AS c INNER JOIN aisle AS a1 JOIN aisle AS a2
	ON a1.id = c.aisle1_id AND a2.id = c.aisle2_id
	GROUP BY c.aisle1_id, c.aisle2_id ORDER BY COUNT(*) DESC LIMIT 5) AS x
);

# A path with 3 aisles

-- Create a talbe of orders that contain exact 3 aisles
CREATE TABLE IF NOT EXISTS aisles_3(
SELECT order_id, COUNT(*) AS COUNT FROM shopping_path_top 
GROUP BY order_id HAVING COUNT(*) = 3);

-- Filter the shopping path table to orders that contain exact 3 aisles
CREATE TABLE IF NOT EXISTS shopping_path_top_3(
SELECT s.* FROM shopping_path_top AS s INNER JOIN aisles_3 AS a ON s.order_id = a.order_id);

-- Create a table of shopping path with rownumber in each order
SET @num := 0, @order_id := '';
CREATE TABLE IF NOT EXISTS shopping_path_top_3_rownumber(
SELECT *, 	
@num := IF(@order_id = order_id, @num + 1, 1) AS row_number,
@order_id := order_id AS dummy
FROM (SELECT * FROM shopping_path_top_3 ORDER BY order_id, aisle_id) AS x);

-- Create a table that lists all the combinations of pair of aisles in each order
CREATE TABLE IF NOT EXISTS combination_of_aisles_3 (
SELECT c1.order_id, c1.aisle_id AS aisle1_id, c2.aisle_id AS aisle2_id, c3.aisle_id AS aisle3_id
FROM shopping_path_top_3_rownumber AS c1 
INNER JOIN shopping_path_top_3_rownumber as c2 JOIN shopping_path_top_3_rownumber AS c3
ON c1.order_id = c2.order_id AND c1.order_id = c3.order_id
WHERE c1.row_number < c2.row_number AND c2.row_number < c3.row_number);

-- Create a table of the most popupar shopping path with exactly 3 aisles
SET @num := 0;
CREATE TABLE IF NOT EXISTS popular_path_3(
SELECT @num := if(TRUE, @num + 1, 1) as rank, aisle1_name, aisle2_name, aisle3_name FROM(
	SELECT a1.aisle AS aisle1_name, a2.aisle AS aisle2_name, a3.aisle AS aisle3_name
	FROM combination_of_aisles_3 AS c INNER JOIN aisle AS a1 JOIN aisle AS a2 JOIN aisle AS a3
	ON a1.id = c.aisle1_id AND a2.id = c.aisle2_id AND a3.id = c.aisle3_id
	GROUP BY c.aisle1_id, c.aisle2_id, c.aisle3_id ORDER BY COUNT(*) DESC LIMIT 5) AS x
);

-- Show the result
SELECT * FROM popular_path_2;
SELECT * FROM popular_path_3;

#6
-- Your task will be to find the pair of items that is most frequently bought together.

-- Create an order_product table that contains only top 100 products
CREATE TABLE IF NOT EXISTS order_product_top(
SELECT op.* FROM order_product AS op INNER JOIN top100product AS t ON op.product_id = t.product_id
ORDER BY op.order_id, op.add_to_chart_order);

-- Create a table of order_product_top with rownumber in each order
SET @num := 0, @order_id := '';
CREATE TABLE IF NOT EXISTS order_product_rownumber(
SELECT *, 	
@num := if(@order_id = order_id, @num + 1, 1) as row_number,
@order_id := order_id as dummy
FROM (SELECT * FROM order_product_top ORDER BY order_id, product_id) AS x);

-- Create a table that lists all the combinations of pair of items in each order
CREATE TABLE IF NOT EXISTS pair_of_items (
SELECT p1.order_id, p1.product_id AS product1_id, p2.product_id AS product2_id
FROM order_product_rownumber as p1 INNER JOIN order_product_rownumber as p2 
ON p1.order_id = p2.order_id
WHERE p1.row_number < p2.row_number);

-- Create a table of pair of items that is most frequently bought together
SET @num := 0;
CREATE TABLE IF NOT EXISTS pair_of_items_top(
SELECT @num := if(TRUE, @num + 1, 1) as rank, product1_name, product2_name FROM(
	SELECT p1.name AS product1_name, p2.name AS product2_name
	FROM pair_of_items AS poi INNER JOIN product AS p1 JOIN product AS p2
	ON p1.id = poi.product1_id AND p2.id = poi.product2_id
	GROUP BY poi.product1_id, poi.product2_id ORDER BY COUNT(*) DESC LIMIT 10) AS x
);

-- Show the result
SELECT * FROM pair_of_items_top;