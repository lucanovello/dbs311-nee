--Question 1
--This is one of those times where an alias name is required
--For each job title (JOB_ID) display the job title and the number of employees with that same title. 
--Change the job_title column to using an alias of your last name
--Order by job_id.

SELECT job_id AS "Novello", COUNT(*) AS "Number of Employees"
FROM employees
GROUP BY job_id
ORDER BY job_id;


--Question 2
--This question requires you to remember joins from last semester and week 1 review as well as multi-row functions.
--For each customer display the name and the number of orders issued by the customer.
--However, only show those customers beginning with the letter E or a D or an A  -- If the customer does not have any orders, the result will display 0.
--Put output in order by the number of orders from highest to lowest

SELECT c.cname, 
       NVL(COUNT(o.order_no), 0)
FROM customers c
LEFT JOIN orders o USING(cust_no)
WHERE c.cname LIKE 'E%' 
   OR c.cname LIKE 'D%' 
   OR c.cname LIKE 'A%'
GROUP BY c.cname
ORDER BY NVL(COUNT(o.order_no), 0) DESC;


--Question 3
--Give an example of your choice that demonstrates the use of an NVL function on the SELECT statement. Only need the select not a whole query.

SELECT NVL(address2, '####') FROM customers;


--Question 4
--Display the Averge, Lowest, and Highest salary.  
--Add a 4th column that shows the difference between the highest and lowest salaries. Make sure the output looks meaningful to the user. EXAMPLE: Money should not be to 7 decimal places 
--NOTE: DO NOT USE ALIAS COLUMN NAMES unless specifically asked for.
--Still some have not read this

SELECT TO_CHAR(AVG(salary), '$999,990.00'), 
    TO_CHAR(MIN(salary), '$999,990.00'), 
    TO_CHAR(MAX(salary), '$999,990.00'), 
    TO_CHAR((MAX(salary) - MIN(salary)), '$999,990.00')
FROM employees;


--Question 5
--Display the customer name, address1, city and the total amount the customer has ordered. But only show those customers where the total exceeds $70,000 .... IGNORE DISCOUNT
--Order by lowest number first

SELECT 
    c.cname,
    c.address1,
    c.city,
    SUM(ol.price)
FROM customers c 
JOIN orders o 
USING(cust_no)
JOIN orderlines ol 
USING(order_no)
GROUP BY c.cname, c.address1, c.city
HAVING SUM(ol.price) >= 70000
ORDER BY SUM(ol.price) DESC;


--Question 6
--Sales Manager Zlotney needs a query to show (a) cust_no, (b) cname (c) the address1 and (d) the total dollar sales (price * qty) and the (e) total number of orders
--The output needs to go from lowest number of orders to highest number of orders
--Output will look similar to this row 
--1040 Vacation Central 2    193 Appledown Rd        7948        5
--NOTE: copy all the rows of output  --- needs joins and functions

SELECT 
    cust_no,
    c.cname,
    c.address1,
    SUM(ol.price * ol.qty),
    COUNT(order_no)
FROM customers c 
JOIN orders o 
USING(cust_no)
JOIN orderlines ol 
USING(order_no)
GROUP BY cust_no, c.cname, c.address1
ORDER BY COUNT(order_no); 

--Question 7
--We are going to make the previous questions a little harder.
--The user wanted all customers that have an UPPERCASE D anywhere in their name. Show the customer even if they did not order anything.
--Put output in order of column 4

SELECT 
    c.cust_no,
    c.cname,
    c.address1,
    SUM(ol.price * ol.qty),
    COUNT(o.order_no)
FROM customers c 
LEFT JOIN orders o 
ON c.cust_no = o.cust_no 
LEFT JOIN orderlines ol 
ON o.order_no = ol.order_no
WHERE c.cname LIKE '%D%'
GROUP BY c.cust_no, c.cname, c.address1
ORDER BY 4; 











