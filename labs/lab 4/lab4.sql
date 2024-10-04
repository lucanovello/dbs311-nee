-- 1.   The user is looking for the country code and country name. Prompt for a country name. The user is only going to type in part of the country name or all of it. 
--Assume you will test it with the letter g in lowercase when you entered g  how many rows were produced

SELECT country_id, country_name, COUNT(*)
FROM countries
WHERE country_name LIKE '%' || '&country_name' || '%'
GROUP BY country_name, country_id;

SELECT COUNT(*)
FROM locations
WHERE country_name LIKE '%' || 'g' || '%';

-- 2.  The answer requires the number of rows only ... not the code
--Display cities in the locations table that is a city where no customers are in them.(use set operators to answer this question)
--Make it ordered by city name from A to Z
--You do not have to do this next part, but how would you verify it worked with SQL.
--Perhaps like this ....
--select distinct city
--from customers
--order by 1 and check if Bombay or Beijing is a city in the customer table.

SELECT city
FROM locations
INTERSECT
SELECT l.city
FROM locations l JOIN customers c
ON l.city != c.city
GROUP BY l.city
ORDER BY 1;


-- 3.  Again using SET
-- Display the product type, and the number of products. In your result, first display Sleeping Bags followed by Tents, followed by Sunblock

SELECT prod_type, COUNT(*)
FROM products
WHERE prod_type = 'Sleeping Bags'
GROUP BY prod_type
UNION ALL
SELECT prod_type, COUNT(*)
FROM products
WHERE prod_type = 'Tents'
GROUP BY prod_type
UNION ALL
SELECT prod_type, COUNT(*)
FROM products
WHERE prod_type = 'Sunblock'
GROUP BY prod_type;

-- 4.  Show the result of the UNION of employee_id and job_id for tables EMPLOYEES and JOB_HISTORY

SELECT employee_id, job_id
from employees
UNION
SELECT employee_id, job_id
FROM job_history;






