--Question 2
--READ QUESTION 1 again.
--Display the (1) employee_id,(2) First name Last name (as one name with a space between) and call the column Full Name, (3) hire_date
--Only show employees with hire dates in August 2016 to dates in December of 2016. You cannot use >= or similar signs
--Sort the output by top last hire_date first (December) and then by last name.
--MUST SHOW THE SQL and the OUPUT to get any marks
--Although you are using alias column names here to see if you understand them, in almost all cases we will not be using alias column names.

SELECT 
    employee_id AS "Employee ID",
    first_name || ' ' || last_name AS "Full Name",
    hire_date AS "Hire Date"
FROM employees
WHERE 
    hire_date BETWEEN TO_DATE('2016/08/01', 'YYYY/MM/DD') AND TO_DATE('2016/12/31', 'YYYY/MM/DD')
ORDER BY hire_date;


--Question 3
--The following is not individual questions, but a series of restrictions on the one SQL output
--Users will often use the name they are accustomed to using. You need to figure out what it is really called for the SQL to work.
--Show the following 4 columns: (1)  product ID, (2) product name, (3) list price (means selling price) , and (4) another column for the new list price if the actual list price is increased by 5%.
--(a) Display a new list price (selling price) as a whole number.
--(b) show only the product numbers from 50000 to 60500
--(c) show only product names that start with M, G or Pr
--NOTE: Unless asked for assume that no alias title names are required.
SELECT 
    prod_no, 
    prod_name, 
    prod_sell, 
    ROUND(prod_sell * 1.05)
FROM products
WHERE 
    prod_no BETWEEN 50000 AND 60500
    AND (prod_name LIKE 'M%' OR prod_name LIKE 'G%' OR prod_name LIKE 'Pr%');


--Question 4
--Write a query to display the same day as you are doing this question, but next week. The result will depend on the day when you RUN/EXECUTE this query. Label the column Next Week
SELECT TO_DATE(sysdate+7, 'YY/MM/DD') AS "Next Week" FROM dual;


--Question 5
--DO NOT WRITE CODE LIKE THIS... it is all jammed together and on one line
--SELECT last_name, salary, job_id, hire_date FROM employees WHERE (hire_date < DATE '1998-01-01') ORDER BY hire_date DESC;
--The following 2 samples are better
--SELECT
--   last_name
--   salary
--   job_id,
--   hire_date
--FROM employees
--WHERE (hire_date < DATE '1998-01-01')
--ORDER BY hire_date DESC;
--Another example is (there are no alias titles in this example which makes it appear shorter
--SELECT last_name, salary, job_id, hire_date
--FROM employees
--WHERE (hire_date < DATE '1998-01-01')
--ORDER BY hire_date DESC;
--ENTER YES, you understood


--Question 6
--BUT AGAIN, NO ALIAS COLUMN NAMES
--Display the job titles (job_id) and full names of employees whose first name contains an ‘e’ or ‘E’ anywhere, and also contains a 'g' or a 'b' anywhere.
--The output should look SIMILAR to this sample.  
--JOB_ID  FIRST_NAME||''||LAST_NAME           
------------ ----------------------------------------------
--SA_REP  Dave Mustaine  

SELECT 
    j.job_id, 
    e.first_name || ' ' || e.last_name
FROM job_history j JOIN employees e 
USING(employee_id)
WHERE LOWER(e.first_name) LIKE '%e%';


--Question 7
--Do not change the column titles.
--For employees whose manager ID is 124, 125 or 126 write a query that displays the employee’s Full Name and Job ID in the following format:
--This is a sample:  Davies, Curtis is employed as a ST_CLERK

SELECT 
    e.last_name || ', ' || e.first_name || ' is employed as a ' || j.job_id
FROM job_history j JOIN employees e 
ON e.manager_id BETWEEN 124 AND 126;


--Question 8
--REMINDER: NO OUTPUT = NO PROOF = NO MARKS
--and no alias names for columns unless asked for in the question.... thank you
--Display each employee’s last name, hire date, and the review date, which is the first Tuesday after a year of service, but only for those hired after 2018. 
--•Label the column REVIEW DAY. 
--•Format the dates to appear in the format like:
--   TUESDAY, August the Thirty-First of year 2016
--Sort by review date
--because this is really week 2 notes now, here is a similar answer as a hint:
--SELECT last_name, hire_date,
--       TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6), 'MONDAY'),'fmDAY, " the " Ddspth " of " Month, YYYY') as "REVIEW" 
--FROM employees

SELECT 
    last_name, 
    hire_date,
    TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 12), 'TUESDAY'), 'fmDAY, Month "the" Ddspth "of year" YYYY') AS "REVIEW DAY"
FROM employees
WHERE hire_date > TO_DATE('31-DEC-2018', 'DD-MON-YYYY')
ORDER BY NEXT_DAY(ADD_MONTHS(hire_date, 12), 'TUESDAY');


--Question 9
--For each employee hired before October 2010, display (a) the employee’s last name, (b) hire date and (c) calculate the number of YEARS between TODAY and the date the employee was hired.
--The output for column (c) should be to only 1 decimal place.
--Put the output in order by column (c)

SELECT 
    last_name, 
    hire_date, 
    ROUND(MONTHS_BETWEEN(sysdate, hire_date) / 12, 1)
FROM employees
WHERE hire_date < TO_DATE('01-OCT-2010', 'DD-MON-YYYY')
ORDER BY ROUND(MONTHS_BETWEEN(sysdate, hire_date) / 12, 1);


