--Creating a Sample Table for Examples
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2),
    creation_date DATE,
    last_update DATE
);
----------------------------------------------------------------
--Populating the Sample Table with Data
INSERT INTO employees (name, salary, creation_date, last_update)
VALUES ('John Doe', 50000, '2023-01-01', '2023-01-01');

INSERT INTO employees (name, salary, creation_date, last_update)
VALUES ('Jane Smith', 60000, '2023-01-02', '2023-01-02');

INSERT INTO employees (name, salary, creation_date, last_update)
VALUES ('Emily Johnson', 55000, '2023-01-03', '2023-01-03');
----------------------------------------------------------------
--Writing a Trigger Function that updates the last_update column to the current date
--whenever a record in the employees table is updated.
CREATE OR REPLACE FUNCTION update_last_update_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_update = CURRENT_DATE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
----------------------------------------------------------------
--Attaching the Trigger Function to a Table
CREATE TRIGGER update_last_update
BEFORE UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();
------------------------------------------------------------------
SELECT * FROM employees;

UPDATE employees SET name ='John Snow' WHERE id=1;

SELECT * FROM employees;
------------------------------------------------------------------
--Advanced Trigger Examples
--Example: Auditing Changes
--Creating the Audit Log Table
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
------------------------------------------------------------------
--Writing the Trigger Function for Auditing
CREATE OR REPLACE FUNCTION log_salary_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.salary IS DISTINCT FROM NEW.salary THEN
        INSERT INTO audit_log (employee_id, old_salary, new_salary)
        VALUES (NEW.id, OLD.salary, NEW.salary);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------
--Attaching the Trigger to the Employees Table
CREATE TRIGGER trigger_audit_salary_change
AFTER UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_change();
--------------------------------------------------------------------
SELECT * FROM audit_log;

UPDATE employees SET salary=90000 WHERE name ='Jane Smith';

SELECT * FROM audit_log;
------------------------------------------------------------------
--Examples of Different Types of Triggers:
--BEFORE Triggers
--Example: Validating Data Before Insert
CREATE OR REPLACE FUNCTION check_salary_before_insert()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salary < 30000 THEN
        RAISE EXCEPTION 'Salary must be at least 30000';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_salary_before_insert_trigger
BEFORE INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION check_salary_before_insert();
-------------------------------------------------------------------------------
--Scenario: Ensure that the salary of a new employee is not less than a minimum threshold (e.g., 30000).
-- This should raise an exception
INSERT INTO employees (name, salary, creation_date, last_update)
VALUES ('Test Employee', 25000, CURRENT_DATE, CURRENT_DATE);
---------------------------------------------------------------------------
--AFTER Triggers
--Example: Logging Changes After Update
CREATE OR REPLACE FUNCTION log_salary_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.salary IS DISTINCT FROM NEW.salary THEN
        INSERT INTO audit_log (employee_id, old_salary, new_salary)
        VALUES (NEW.id, OLD.salary, NEW.salary);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_salary_changes_trigger
AFTER UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_changes();
----------------------------------------------------------------------------
--Scenario: Log any changes made to the salary field of an employee.
-- This should log the salary change
UPDATE employees SET salary = 56000 WHERE id = 1;
---------------------------------------------------------------------------- 
--INSTEAD OF Triggers (For Views)
--Example: Custom Action on View Update
CREATE VIEW employee_salary_view AS SELECT id, salary FROM employees;

CREATE OR REPLACE FUNCTION update_salary_through_view()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE employees SET salary = NEW.salary WHERE id = NEW.id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_salary_view_trigger
INSTEAD OF UPDATE ON employee_salary_view
FOR EACH ROW
EXECUTE FUNCTION update_salary_through_view();
-----------------------------------------------------------------------------------
--Scenario: Allow updates to the salary field through a view. Usage Example:
-- This should update the salary through the view
UPDATE employee_salary_view SET salary = 60000 WHERE id = 1;
------------------------------------------------------------------------------------
--Row-Level Triggers
--Example: Checking Balance Before Deletion
CREATE OR REPLACE FUNCTION prevent_high_salary_deletion()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.salary > 60000 THEN
        RAISE EXCEPTION 'Cannot delete employees with a salary above 70000';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_high_salary_deletion_trigger
BEFORE DELETE ON employees
FOR EACH ROW
EXECUTE FUNCTION prevent_high_salary_deletion();
----------------------------------------------------------------------------
--Scenario: Prevent deletion of employees who have a salary above a certain threshold (e.g., 60000).
--Usage Example:
CREATE OR REPLACE FUNCTION prevent_high_salary_deletion()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.salary > 60000 THEN
        RAISE EXCEPTION 'Cannot delete employees with a salary above 70000';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_high_salary_deletion_trigger
BEFORE DELETE ON employees
FOR EACH ROW
EXECUTE FUNCTION prevent_high_salary_deletion();
------------------------------------------------------------------------
-- Assuming an employee with id 2 has a salary above 60000, this should raise an exception
DELETE FROM employees WHERE id = 2;
-----------------------------------------------------------------------
--Statement-Level Triggers
--Example: Audit on Bulk Update
CREATE TABLE bulk_update_log (
    log_id SERIAL PRIMARY KEY,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by TEXT
);

CREATE OR REPLACE FUNCTION log_bulk_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO bulk_update_log (updated_by)
    VALUES (CURRENT_USER);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_bulk_update_trigger
AFTER UPDATE ON employees
FOR EACH STATEMENT
EXECUTE FUNCTION log_bulk_update();
------------------------------------------------------------------------------
--Scenario: Record the occurrence of any bulk update operation on the employees table.
--Usage Example:
-- This should log the bulk update operation
UPDATE employees SET salary = salary * 1.05;
----------------------------------------------------------------------------------


