-- ***********************
-- Name:        Luca Novello
-- Student ID:  038515003
-- Date:        Nov 15, 2024
-- Purpose:     DBS311NEE - Lab 6 | PL/SQL part 2
-- ***********************

SET SERVEROUTPUT ON

-- Q1. The company wants to calculate what the employees’ annual salary would be

CREATE OR REPLACE PROCEDURE calculate_salary45 (emp_id IN NUMBER) AS
    v_first_name  VARCHAR2(50);
    v_last_name   VARCHAR2(50);
    v_hire_date   DATE;
    v_years       NUMBER;
    v_salary      NUMBER := 10000;
BEGIN
    SELECT first_name, last_name, hire_date
    INTO v_first_name, v_last_name, v_hire_date
    FROM employees
    WHERE employee_id = emp_id;
    v_years := FLOOR(MONTHS_BETWEEN(SYSDATE, v_hire_date) / 12);
    v_salary := v_salary * POWER(1.05, v_years);
    DBMS_OUTPUT.PUT_LINE('First Name: ' || v_first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Salary: $' || TO_CHAR(v_salary, '999G999D99'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred.');
END calculate_salary45;
/


-- Q2. Do these 3 tries without an exception handler. There are 3 scenarios here:
--      - In a given CITY, there is a SINGLE department
--      - In a given CITY, there is a MORE THAN ONE department
--      - In a given CITY, there is NO department

CREATE OR REPLACE PROCEDURE GetDepartmentsByCity (city_name IN VARCHAR2) IS
    -- Declare local variables
    v_department_id DEPARTMENTS.DEPARTMENT_ID%TYPE;
    v_department_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    v_count NUMBER;
BEGIN
    -- Query to check how many departments are in the given city
    SELECT COUNT(*)
    INTO v_count
    FROM LOCATIONS l
    JOIN DEPARTMENTS d
        ON l.LOCATION_ID = d.LOCATION_ID
    WHERE l.CITY = city_name;

    -- If there are no departments in the city
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No departments found in ' || city_name);

    -- If there is exactly one department in the city
    ELSIF v_count = 1 THEN
        SELECT d.DEPARTMENT_ID, d.DEPARTMENT_NAME
        INTO v_department_id, v_department_name
        FROM LOCATIONS l
        JOIN DEPARTMENTS d
            ON l.LOCATION_ID = d.LOCATION_ID
        WHERE l.CITY = city_name;

        DBMS_OUTPUT.PUT_LINE('Department ID: ' || v_department_id || ', Department Name: ' || v_department_name);

    -- If there is more than one department in the city
    ELSE
        FOR rec IN (SELECT d.DEPARTMENT_ID, d.DEPARTMENT_NAME
                    FROM LOCATIONS l
                    JOIN DEPARTMENTS d
                        ON l.LOCATION_ID = d.LOCATION_ID
                    WHERE l.CITY = city_name) LOOP
            DBMS_OUTPUT.PUT_LINE('Department ID: ' || rec.DEPARTMENT_ID || ', Department Name: ' || rec.DEPARTMENT_NAME);
        END LOOP;
    END IF;

EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Too many rows returned.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No data found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/

-- SOUTHLAKE
EXEC GetDepartmentsByCity('SOUTHLAKE');

--------- Result ---------
-- No departments found in SOUTHLAKE

-- TORONTO
EXEC GetDepartmentsByCity('TORONTO');

--------- Result ---------
-- No departments found in TORONTO

-- SEATTLE
EXEC GetDepartmentsByCity('SEATTLE');

--------- Result ---------
-- No departments found in SEATTLE

-- Q3. Write a stored procedure named employee_works_hereXX to print the employee_id, employee Last name and department name.

CREATE OR REPLACE PROCEDURE employee_works_hereXX AS
    v_employee_id  NUMBER := 45;
    v_last_name    VARCHAR2(50);
    v_department_name VARCHAR2(50);
BEGIN
    WHILE v_employee_id <= 105 LOOP
        BEGIN
            SELECT last_name, NVL((SELECT department_name 
                                   FROM departments d 
                                   WHERE d.department_id = e.department_id), 
                                   'no department name')
            INTO v_last_name, v_department_name
            FROM employees e
            WHERE employee_id = v_employee_id;
            DBMS_OUTPUT.PUT_LINE('Employee #: ' || v_employee_id || ' Last Name: ' || v_last_name || ' Department Name: ' || v_department_name);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Employee #: ' || v_employee_id || ' not found.');
        END;
        v_employee_id := v_employee_id + 1;
    END LOOP;
END employee_works_hereXX;
/










