-- Creating the database
CREATE DATABASE churn_project;

-- using the database
USE churn_project;

-- Creating the customer table 
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE,
    city VARCHAR(50)
);

-- creating the orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- inserting values into the customers table
INSERT INTO customers VALUES
(1,'2024-01-05','Bangalore'),
(2,'2024-01-10','Hyderabad'),
(3,'2024-01-15','Chennai'),
(4,'2024-02-01','Mumbai'),
(5,'2024-02-10','Bangalore'),
(6,'2024-02-15','Delhi'),
(7,'2024-03-01','Hyderabad'),
(8,'2024-03-05','Chennai'),
(9,'2024-03-10','Mumbai'),
(10,'2024-03-20','Bangalore'),
(11,'2024-04-01','Delhi'),
(12,'2024-04-10','Hyderabad'),
(13,'2024-04-15','Chennai'),
(14,'2024-05-01','Mumbai'),
(15,'2024-05-10','Bangalore');

-- inserting values into the orders table
INSERT INTO orders VALUES
(101,1,'2024-03-01',500),
(102,1,'2024-04-01',700),
(103,1,'2024-05-01',650),
(104,2,'2024-03-05',300),
(105,3,'2024-03-10',400),
(106,3,'2024-04-10',450),
(107,4,'2024-04-15',800),
(108,4,'2024-05-15',900),
(109,5,'2024-03-20',200),
(110,6,'2024-04-01',350),
(111,6,'2024-05-01',400),
(112,7,'2024-05-05',600),
(113,8,'2024-03-25',250),
(114,9,'2024-04-10',700),
(115,10,'2024-05-20',1000),
(116,11,'2024-04-15',300),
(117,12,'2024-05-25',450),
(118,13,'2024-03-15',500),
(119,14,'2024-05-10',650),
(120,15,'2024-05-18',750);

use churn_project;
select * from customers;
select * from orders;

-- Monthly revenue trend

select date_format(order_date, ' %y-%m') as month,sum(amount) as total_revenue from orders
group by month order by month;

-- customer behaviour
-- orders per customers
select customer_id,count(order_id) as total_orders from orders
group by customer_id order by total_orders desc;

--  repeat vs one time orders by customers
select 
     case  
         when order_count=1 then "one-time"
		 else 'repeat'
	 end as customer_type,
     count(*) as total_customers
from(
    select customer_id, count(order_id) as order_count from orders
    group by customer_id
) as t
group by customer_type;

-- Revenue by city
select c.city, sum(o.amount) as total_revenue
from orders o 
join customers c
on c.customer_id = o.customer_id
group by c.city
order by total_revenue desc;

-- churn analysis
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING MAX(order_date) < '2024-05-01';

-- count churned customers

select count(*)as churned_customers
from( 
      select customer_id
	  from orders
      group by customer_id
      having max(order_Date) < '2024-05-01'
)as churn;

