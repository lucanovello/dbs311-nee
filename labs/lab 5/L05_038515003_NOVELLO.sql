-- ***********************
-- Name:        Luca Novello
-- Student ID:  038515003
-- Date:        Nov 8, 2024
-- Purpose:     DBS311NEE - Lab 5 PL/SQL part 1
-- ***********************

SET SERVEROUTPUT ON

-- QUESTION 1 ********************************************************************************************
--  Write a stored procedure that gets an integer number and prints "The number is even." 
--  if a number is divisible by 2. Otherwise, it prints "The number is odd.".

-- Q1 SOLUTION ------------------------
CREATE OR REPLACE PROCEDURE evenodd (input IN NUMBER) AS
BEGIN
if mod(input, 2) = 0
  then DBMS_OUTPUT.PUT_LINE('The number is even.');
else
  DBMS_OUTPUT.PUT_LINE('The number is odd.');
end if;
END evenodd;
/

-- execute Q1
BEGIN
  evenodd(&number);
END;
/


-- QUESTION 2 ********************************************************************************************
--  Create a stored procedure named find_me. This procedure gets an employee number from the user and prints the
--  following employee information about that user:
--  First name Last name Email Phone Hire Date and Job ID
--  The procedure gets a value as the employee ID of type NUMBER.
--  The procedure displays a proper error message if any error occurs.

-- Q2 SOLUTION ------------------------
BEGIN
  SELECT first_name, last_name, email, phone_number, hire_date, job_id
  INTO fname, lname, output_email, phone, hiredate, jobtitle	-- insert them into the above declared variables
  FROM employees
  WHERE input = employee_id;

-- now ouput the findings – assumed example worked
  DBMS_OUTPUT.PUT_LINE ('First name: ' || fname);
  DBMS_OUTPUT.PUT_LINE ('Last name: ' || lname);
  DBMS_OUTPUT.PUT_LINE ('Email: ' || output_email);
  DBMS_OUTPUT.PUT_LINE ('Phone: ' || phone);
  DBMS_OUTPUT.PUT_LINE ('Hire date: ' || hiredate);
  DBMS_OUTPUT.PUT_LINE ('Job title: ' || jobtitle);

EXCEPTION
WHEN NO_DATA_FOUND
  THEN
    DBMS_OUTPUT.PUT_LINE('No data found!');
WHEN OTHERS
  THEN
    DBMS_OUTPUT.PUT_LINE('Error!');
END find_employee;
/

-- execute Q2
BEGIN
  find_employee(&emp_id);
END;
/


-- QUESTION 3 ********************************************************************************************
--  Every year, the company increases the selling price of all products in one product type.
--  For example, the company wants to increase the selling price of products in type Tents by $5.
--  Write a procedure named update_price_fortype to update the selling price of all products in the given type and the
--  given amount to be added to the current selling price if the price is greater than 0.
--  The procedure shows the number of updated rows if the update is successful.
--  The procedure gets two parameters:
--      - Prod_type IN VARCHAR2
--      - amount NUMBER(9,2) this means the amount to increase selling price by
--  Then, print its value in your stored procedure. (Something like this is in the notes supplied to you)
--      Rows_updated := sql%rowcount;
--      SQL%ROWCOUNT stores the number of rows affected by an INSERT, UPDATE, or DELETE.

-- Q3 SOLUTION ------------------------
CREATE OR REPLACE PROCEDURE update_prices(p_type IN VARCHAR2, amount IN NUMBER) AS
  rows_updated NUMBER;
BEGIN
  UPDATE products
    SET prod_sell = prod_sell + amount
    WHERE LOWER(prod_type) = LOWER(p_type);

  rows_updated := SQL%ROWCOUNT;

IF rows_updated > 0 THEN
  dbms_output.put_line(rows_updated || ' Rows Updated');
END IF;
END update_prices;
/

-- execute Q3
BEGIN
  update_prices('&type', &amount);
END;
/

-- rollback Q3
ROLLBACK products;
/

-- QUESTION 4 ********************************************************************************************
--  Every year, the company increases the price of products by 2 to 5% (Example of 2% -- prod_sell * 1.02) based on
--  if the selling price (prod_sell) is less than the average price of all products.
--  Write a stored procedure named update_low_prices_99 where 99 is replaced by your OracleID number. If you
--  are dbs311_213d87 then the number to use will be 87
--  This procedure does not have any parameters. You need to find the average sell price of all products and store it
--  into a variable of the same data type. If the average price is less than or equal to $1000, then update the products
--  selling price by 2% if that products sell price is less than the calculated average.
--  If the average price is greater than $1000, then update products selling price by 1% if the price of the products
--  selling price is less than the calculated average.
--  The query displays an error message if any error occurs. Otherwise, it displays the number of updated rows.

-- Q4 SOLUTION ------------------------
CREATE OR REPLACE PROCEDURE update_low_prices_132194200 AS
  avg_sell products.prod_sell%type; 
BEGIN
  SELECT AVG(prod_sell)
  INTO avg_sell
  FROM products;

IF (avg_sell <= 1000) THEN
  UPDATE products
    SET prod_sell = prod_sell * 1.02
    WHERE prod_sell < avg_sell;
END IF;
IF (avg_sell > 1000) THEN
  UPDATE products
    SET prod_sell = prod_sell * 1.01
    WHERE prod_sell < avg_sell;
END IF;

IF SQL%ROWCOUNT>0 THEN
  dbms_output.put_line(SQL%ROWCOUNT || ' Rows Updated');
END IF;

EXCEPTION
WHEN OTHERS
  THEN
    DBMS_OUTPUT.PUT_LINE('Error!');
    
END update_low_prices_132194200;
/

-- execute Q4
BEGIN
  update_low_prices_132194200();
END;
/

-- rollback Q4
ROLLBACK products;
/

-- QUESTION 5 ********************************************************************************************
--  The company needs a report that shows three categories of products based their prices. The company needs to
--  know if the product price is low, fair, or expensive. Let us assume that
--   - If the list price is less than the (average sell price – minimum sell price) divided by 2
--       o The product’s price is LOW.
--   - If the list price is greater than the maximum less the average divided by 2
--       o The product’ price is HIGH.
--   - If the list price is between (average price – minimum price) / 2 AND (maximum price – average price) / 2 INCLUSIVE
--       o The product’s price is FAIR.

-- Q5 SOLUTION ------------------------
CREATE OR REPLACE PROCEDURE price_report_132194200 AS
  low_price products.prod_sell%type;
  high_price products.prod_sell%type;
  low_count NUMBER;
  fair_count NUMBER;
  high_count NUMBER;
  
  sell_price NUMBER;
  CURSOR prices IS
    SELECT prod_sell
    FROM products;
BEGIN
  low_count := 0;
  fair_count := 0;
  high_count := 0;

  SELECT (AVG(prod_sell) - MIN(prod_sell)) / 2
  INTO low_price
  FROM products;
  
  SELECT (MAX(prod_sell) - AVG(prod_sell)) / 2
  INTO high_price
  FROM products;
  
    OPEN prices;
      LOOP
        FETCH prices INTO sell_price;
          EXIT WHEN prices%notfound;

        IF (sell_price < low_price) THEN
          low_count := low_count + 1;
        ELSIF (sell_price > high_price) THEN
          high_count := high_count + 1;
        ELSIF ((sell_price >= low_price) AND (sell_price <= high_price)) THEN
          fair_count := fair_count + 1;
        END IF;
      END LOOP;

    CLOSE prices;

  dbms_output.put_line('Low: ' || low_count);
  dbms_output.put_line('Fair: ' || fair_count);
  dbms_output.put_line('High: ' || high_count);

END price_report_132194200;
/

-- execute Q5
BEGIN
  price_report_132194200();
END;
/

-- rollback Q5
ROLLBACK products;
/
