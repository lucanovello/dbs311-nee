--------------------------------------------------------------------------------------
-- Name       : Luca Novello
-- Student ID : 038515003
-- User ID    : dbs311_243nbb26
-- Date       : 09-05-2024
-- Purpose    : DBS311 Lab 1
--------------------------------------------------------------------------------------


-- Q1: Write a query to display the tomorrow’s date in the following format: `January 10th of year 2019`
-- the result will depend on the day when you RUN/EXECUTE this query. Label the column “Tomorrow”.
-- Advanced Option: Define an SQL variable called “tomorrow”, assign it a value of tomorrow’s date and use it in an SQL statement. Here the question is asking you to use a Substitution variable. Instead of using the constant values in your queries, you can use variables to store and reuse the values.

DEFINE tomorrow = SYSDATE + 1;
SELECT to_char(&tomorrow, 'Month ddth "of year" YYYY') AS "Tomorrow"
FROM dual;
