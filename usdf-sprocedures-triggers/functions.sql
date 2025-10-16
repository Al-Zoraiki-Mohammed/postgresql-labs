--1. Step 1: Create a PostgreSQL Table.
----Create a table named employees.
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name TEXT,
    email TEXT,
    department_id INTEGER,
    salary NUMERIC
);
-----------------------------------------------------------------
--Step 2: Insert Data into the Table
INSERT INTO employees (name, email, department_id, salary) VALUES
('John Doe', 'john@example.com', 1, 50000),
('Jane Smith', 'jane@example.com', 2, 60000),
('Alice Johnson', 'alice@example.com', 1, 55000),
('Bob Brown', 'bob@example.com', 3, 45000),
('Carol White', 'carol@example.com', 2, 62000);
-------------------------------------------------------------------
--Step 3: Create Functions.
----3.1 Basic Custom Function.
-----Create a function calculate_bonus(salary numeric) that calculates a 10% bonus on the provided salary.
CREATE FUNCTION calculate_bonus(salary NUMERIC) RETURNS NUMERIC AS $$
BEGIN
    RETURN salary * 0.15;
END;
$$ LANGUAGE PLPGSQL;

-- Test calculate_bonus
SELECT name, salary, calculate_bonus(salary) AS bonus
FROM employees;
----------------------------------------------------------------------
--3.2 Function Using Conditional Logic
--reate a function department_status(department_id integer) that 
--returns 'Large' if the number of employees in a department is greater than 10, otherwise 'Small'.
CREATE FUNCTION department_status(department_id_var INTEGER) RETURNS TEXT AS $$
DECLARE
    employee_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO employee_count FROM employees WHERE department_id = department_id_var;
    IF employee_count > 10 THEN
        RETURN 'Large';
    ELSE
        RETURN 'Small';
    END IF;
END;
$$ LANGUAGE PLPGSQL;

-- Test department_status
SELECT department_id, department_status(department_id)
FROM employees GROUP BY department_id;
------------------------------------------------------------------------
--3.3 Aggregate Function: Create a custom aggregate function total_salaries() 
-----that calculates the total salaries of all employees.
CREATE OR REPLACE FUNCTION sum_salary(state NUMERIC, salary NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN state + salary;
END;
$$ LANGUAGE PLPGSQL;

CREATE AGGREGATE total_salaries(NUMERIC) (
    SFUNC = sum_salary,
    STYPE = NUMERIC,
    INITCOND = '0'
);

-- Test total_salaries
SELECT total_salaries(salary)
FROM employees;
-----------------------------------------------------------
--3.4 Error Handling in Function
----- Create a function safe_divide(numerator numeric,denominator numeric) 
-----that safely divides two numbers and handles division by zero.
CREATE FUNCTION safe_divide(numerator NUMERIC, denominator NUMERIC) RETURNS NUMERIC AS $$
BEGIN
    IF denominator = 0 THEN
        RAISE EXCEPTION 'Division by zero';
    END IF;
    RETURN round(numerator / denominator);
EXCEPTION
    WHEN others THEN
        RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

-- Test safe_divide
SELECT safe_divide(10, 0); -- Should handle division by zero
SELECT safe_divide(10, 2); -- Should return 5
-------------------------------------------------------------------
--3.5 Using Built-in String Function
----Write a query using the LENGTH function to find the length of each employee’s name.
SELECT name, LENGTH(name) AS name_length FROM employees;
------------------------------------------------------------------
--3.6 String Manipulation Function
-----Create a function email_domain(email text) that extracts the domain part from an employee’s email address.
CREATE FUNCTION email_domain(email TEXT) RETURNS TEXT AS $$
BEGIN
    RETURN split_part(email, '@', 2);
END;
$$ LANGUAGE PLPGSQL;
---------
SELECT name, email, email_domain(email) AS domain
FROM employees;
----------------------------------------------------------------------------------------
--3.7 Complex Calculation Function
----Create a function net_salary(salary NUMERIC, tax_rate NUMERIC) to calculate 
----the net salary after applying a tax rate.
CREATE FUNCTION net_salary(salary NUMERIC, tax_rate NUMERIC) RETURNS NUMERIC AS $$
BEGIN
    RETURN salary - (salary * tax_rate);
END;
$$ LANGUAGE PLPGSQL;

-- Test net_salary
SELECT name, salary, net_salary(salary, 0.2) AS net_salary
FROM employees;
--------------------------------------------------------------------
---3.8 Table Function
----Create a function department_employees(dept_id INTEGER) 
----that returns a set of employees belonging to a specific department.
CREATE FUNCTION department_employees(dept_id INTEGER) RETURNS SETOF employees AS $$
BEGIN
    RETURN QUERY SELECT * FROM employees WHERE department_id = dept_id;
END;
$$ LANGUAGE PLPGSQL;

-- Test department_employees
SELECT * FROM department_employees(1);
----------------------------------------------------------------
--Step 4: Cleanup
----Drop Functions: If you wish to clean up the database, 
----write SQL statements to drop the functions created during this exercise. For example:
DROP FUNCTION calculate_bonus;
DROP FUNCTION department_status;
DROP AGGREGATE IF EXISTS total_salaries(NUMERIC);
DROP FUNCTION safe_divide;
DROP FUNCTION department_employees;
DROP FUNCTION net_salary;
DROP FUNCTION email_domain;
-----
DROP TABLE employees;
-----------------------------------------------------------


