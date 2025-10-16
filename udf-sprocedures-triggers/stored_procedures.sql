--Part 1: Basic Examples
--Step 1: Table Creation: Create a simple table named practice_table.
CREATE TABLE practice_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL
);
----------------------------------------------------------------------
--Step 2: Inserting Data
--Insert sample data into practice_table.
INSERT INTO practice_table (name, balance) VALUES ('Alice', 1000.00);
INSERT INTO practice_table (name, balance) VALUES ('Bob', 1500.50);
------------------------------------------------------------------------
--Step 3: Creating a Basic Stored Procedure
--Create a stored procedure to update the balance for an account.
CREATE OR REPLACE PROCEDURE update_balance(p_id INT, p_balance DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE practice_table
    SET balance = p_balance
    WHERE id = p_id;
END;
$$;
-------------------------------------------------------------------------------
--Step 4: Running the Stored Procedure
--Update the balance of an account.
CALL update_balance(1, 1200.00);
--------------------------------------------------------------------------------
--Step 5: Verifying the Update
--Check if the stored procedure worked correctly.
SELECT * FROM practice_table;
--------------------------------------------------------------------------------
--Part 2: Advanced Examples
--Example 1: Transfer Funds Between Accounts
--Create a stored procedure for funds transfer.
CREATE OR REPLACE PROCEDURE transfer_funds(sender_id INT, receiver_id INT, amount DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE practice_table SET balance = balance - amount WHERE id = sender_id;
    UPDATE practice_table SET balance = balance + amount WHERE id = receiver_id;
END;
$$;
----------------------------------------------------------------------------------
--Transfer funds between accounts.
CALL transfer_funds(1, 2, 200.00);
----------------------------------------------------------------------------------
--Example 2: Bulk Insert Data
--Create a stored procedure for bulk insertion.
CREATE OR REPLACE PROCEDURE bulk_insert(data JSON)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO practice_table (name, balance)
    SELECT (rec->>'name')::VARCHAR, (rec->>'balance')::DECIMAL
    FROM json_array_elements(data) AS rec;
END;
$$;
-------------------------------------------------------------------------------------
--Bulk insert data into the table.
CALL bulk_insert('[{"name":"Charlie", "balance":3000}, {"name":"Dana", "balance":2500}]'::JSON);
-------------------------------------------------------------------------------------
--Example 3: Conditional Data Update
--Create a stored procedure for conditional updates.
CREATE OR REPLACE PROCEDURE conditional_update(min_balance DECIMAL, bonus DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE practice_table SET balance = balance + bonus WHERE balance >= min_balance;
END;
$$;
---------------------------------------------------------------------------------------
--Conditionally update account balances.
CALL conditional_update(1000, 100);
----------------------------------------------------------------------------------------
--Example 4: Delete Records Safely
--Create a stored procedure for safe deletion.
CREATE OR REPLACE PROCEDURE safe_delete(account_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM practice_table WHERE id = account_id AND balance = 0) THEN
        DELETE FROM practice_table WHERE id = account_id;
    ELSE
        RAISE EXCEPTION 'Account balance is not zero.';
    END IF;
END;
$$;
-----------------------------------------------------------------------------------------
--Safely delete an account.
CALL safe_delete(3);
----------------------------------------------------------------------------------------

