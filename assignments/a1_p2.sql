-- 1. Write the SQL code and provide the output also for the following.
-- The management wants all order from United States of America. You can hard code the countries name, but not use US.
-- Show only
-- -- cities that start with L
-- -- orders from Australia if the city starts with P
-- What columns are needed
-- customers number, customers name, address1, city, order number, product name, and total dollar sales for that line on the order.
-- Customers number ordered by highest first to lowest
-- Lots of joins in this question

SELECT
    c.cust_no,
    c.cname,
    c.address1,
    c.city,
    ol.order_no,
    p.prod_name,
    ol.price * ol.qty * (1 - ol.disc_perc / 100)
FROM customers c
JOIN orders o
ON c.cust_no = o.cust_no
JOIN employees e
ON o.rep_no = e.employee_id
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id
JOIN countries co
ON l.country_id = co.country_id
JOIN orderlines ol
ON o.order_no = ol.order_no
JOIN products p
ON ol.prod_no = p.prod_no
WHERE LOWER(co.country_name) = 'united states of america' OR LOWER(c.city) LIKE 'p%' AND LOWER(country_cd) LIKE 'au'
ORDER BY c.cust_no DESC;


-- 3. Another question involving customers of course.
-- customers number customers name, address1, city
-- With these restrictions
-- (1) if the customer has ordered any of the following 40500, 50200, 40300, 60201, 60104 60103
-- (2) and only those customers that have Out in any case in their name
-- (3) customer number order

SELECT 
    c.cust_no, 
    c.cname, 
    c.address1, 
    c.city
FROM customers c
JOIN orders o 
ON c.cust_no = o.cust_no
JOIN orderlines ol
ON o.order_no = ol.order_no
WHERE ol.prod_no IN (40500, 50200, 40300, 60201, 60104, 60103)
    AND LOWER(c.cname) LIKE '%out%'
ORDER BY c.cust_no;


-- 4. Display customers number, their name, and country code for all customers in Canada. The customers number must be over 1100
-- Your SQL must ask the customer to enter the country code and you must use CUSTOMERS table for the code
-- Please do not make it difficult for the customer. They can enter the code in any case so you need to be flexible

SELECT 
    c.cust_no, 
    c.cname, 
    c.country_cd
FROM 
    customers c
WHERE 
    LOWER(c.country_cd) = LOWER(:country_code)
    AND c.cust_no > 1100;


-- 5. Looking for the average amount of order for customers that are in cities that start with the letters TO in any case
-- needed is customer number, name, address1, city, average dollar amount for that customer

SELECT 
    c.cust_no, 
    c.cname, 
    c.address1, 
    c.city, 
    ROUND(AVG(ol.price * ol.qty * (1 - ol.disc_perc / 100)), 2)
FROM customers c
JOIN orders o
ON c.cust_no = o.cust_no
JOIN orderlines ol
ON o.order_no = ol.order_no
WHERE LOWER(c.city) LIKE 'to%'
GROUP BY 
    c.cust_no, 
    c.cname, 
    c.address1, 
    c.city
ORDER BY c.cust_no;

-- 6. Using a subquery, the Marketing and Sales department or our company wants to know how many customers have not placed an order.

SELECT COUNT(*)
FROM customers
WHERE cust_no NOT IN (
    SELECT cust_no 
    FROM orders
);










    
    
