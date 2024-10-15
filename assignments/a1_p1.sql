-- 1. The Human Resources department would like the following.
-- Display the employee number, employee last name, their job and hire date of all employees hired in July. Output starts with most recently hired to longest hire.
-- The date should look like similar to this in the output === > May 23rd of 2021

SELECT 
    e.employee_id,
    e.last_name,
    j.job_id,
    TO_CHAR(j.start_date, 'Month ddth "of" yyyy')
FROM employees e JOIN job_history j
ON e.employee_id = j.employee_id
WHERE EXTRACT(MONTH FROM j.start_date) = 7
ORDER BY j.start_date DESC;

-- 2. The economy is tight and Eleni Zlotkey, the Sales Manager, wants to know how her sales people are doing. She would like to see total sales by salesperson. 
-- The id of the employee, first name, last name and total sales dollars are required output.
-- Ordered by the highest dollar sales first. This may be the basis of firing an employee or give them assistance to improve.

SELECT 
    e.employee_id, 
    e.first_name, 
    e.last_name, 
    SUM(ol.price * ol.qty * (1 - ol.disc_perc / 100))
FROM employees e 
JOIN orders o
ON e.employee_id = o.rep_no
JOIN orderlines ol 
ON o.order_no = ol.order_no
GROUP BY e.employee_id, 
    e.first_name, 
    e.last_name
ORDER BY 4 DESC;

-- 3. Provide a list of customers that have not placed an order. Mr. King wants the salespeople for those customers to go and call on these customers to try and get them back.
-- Customer number, name, address 1, city , phone number

SELECT 
    c.cust_no, 
    c.cname, 
    c.address1, 
    c.city, 
    c.phone_no
FROM customers c
LEFT JOIN orders o
ON c.cust_no = o.cust_no
WHERE o.order_no IS NULL;

-- 4. Find the average size order showing dollars only not a big fraction of cents

SELECT 
    ROUND(AVG(price * qty * (1 - disc_perc / 100)), 0)
FROM 
    orderlines;
    

-- 5. Find the average order dollars by sales person for those with an average above 3000
-- show name and dollar amount. Dollar amount must be in whole number

SELECT 
    e.first_name, 
    e.last_name, 
    FLOOR(AVG(ol.price * ol.qty * (1 - ol.disc_perc / 100)))
FROM employees e
JOIN orders o ON e.employee_id = o.rep_no
JOIN orderlines ol ON o.order_no = ol.order_no
GROUP BY e.first_name, e.last_name
HAVING AVG(ol.price * ol.qty * (1 - ol.disc_perc / 100)) > 300
ORDER BY 3 DESC;
    
    
    
