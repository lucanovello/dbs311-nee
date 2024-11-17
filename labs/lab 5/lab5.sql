-- Purpose:     DBS311NEE - Lab 5 PL/SQL part 1
-- Name:        Luca Novello
-- Student #:   038515003
-- ***********************
/*
Please ensure your file runs when the entire file is executed in SQL Developer..
The file will be run in Oracle. If it runs well, it gets the full marks. Not running gets a much lesser mark
*/

SET SERVEROUTPUT ON

-- Question 1 - Receive input from user and output if it's odd or even
-- Q1 SOLUTION
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


-- Question 2 - Retrieve info from EMPLOYEES, store in variables and output to screen
-- Q2 SOLUTION
 
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


-- Question 3 - Retrieve rows from products that match the entered product type, then increase the selling price by the amount entered
-- Q3 SOLUTION
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

-- Question 4 - Update sell price for those whose sell price is less than the average of all products
-- Q4 SOLUTION
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

-- Question 5
-- Q5 SOLUTION
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
