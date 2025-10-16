--1. Create a customer table with the specified columns, On the customer_id column, 
--create a primary key constraint and a B-tree index and fill it with test data.

CREATE TABLE customer
	(customer_id INT PRIMARY KEy,
	 first_name VARCHAR(50),
	 last_name VARCHAR(50),
	 email VARCHAR(100),
	 modified_date DATE,
	 age INT,
	 active BOOLEAN
	 
	);
---------------------------
--1.2 Create a B-tree index on customer_id column
--(By the way there is a default index 'customer_pkey' created when the column specified as pk )
CREATE INDEX customer_id_idx ON customer(customer_id );
---------------------------
--1.3 ill customer table with the test data.
INSERT into customer
SELECT
    gs AS customer_id,
    concat('firstname', gs) AS first_name,
    concat('lastname', gs) AS last_name,
    concat('firstname', 'lastname', gs, '@email.com') AS email,
    modifieddate + INTERVAL '1 day' * (gs % 365) AS modified_date,
    gs % 90 AS age,
    gs % 7 = 0 AS active
FROM
    GENERATE_SERIES(1, 1000000) as gs
CROSS JOIN
    (SELECT * FROM humanresources.employee LIMIT 1) as emp;
-----------------------------------------------------------------------------------
--2.Make sure your index appears in the pg_indexes system directory. 
 --(Done, it is exist).
 ----------------------------------------------------------------------------------
 --3. Create a B-tree multi-column index on the customer table on the first_name and last_name columns.
CREATE INDEX customer_fname_lname_idx ON  customer USING btree (first_name, last_name);
-- 'using btree' can be omitted:
--CREATE index customer_fname_lname_idx on  customer (first_name, last_name);
-----------------------------------------------------------------------------------
 --4. Create an index on the customer table so that the output of the query below is the specified output.
CREATE INDEX customer_age_idx  ON customer USING btree (age);
--'using btree' can be omitted
--create index customer_age_idx  on customer using btree (age);
-----------------------------------------------------------------------------------
--5.Create a covering index customer_modified_date_idx for fast query execution
--and check that it is used in the query plan:
CREATE INDEX customer_modified_date_idx ON customer(modified_date)
	INCLUDE  (first_name, last_name);
------------------------------------------------------------------------------------
--6. Delete the index/constraint that you created on the customer_id column in first step
-- Drop the index I created 'customer_id_idx':
DROP INDEX IF EXISTS customer_id_idx;
-- Drop the pk constraint and the default 'customer_pkey' index   
ALTER  TABLE customer
	DROP CONSTRAINT customer_pkey;
------------------------------------------------------------------------------------
--7. Rename previously created covering index customer_modified_date_idx to customer_modified_date_idx_covering.
ALTER INDEX customer_modified_date_idx RENAME TO customer_modified_date_idx_covering;
-------------------------------------------------------------------------------------
--8. Create a Hash index called customer_modified_date_idx on the customer table on the modified_date column.
CREATE INDEX customer_modified_date_idx ON customer USING hash (modified_date);
---------------------------------------------------------------------------------------
--9. Create a partial index on the email column only for those records that have active = true. 
--Also, write a query to the table in which this index will be used.
CREATE INDEX customer_active_email_idx 
	ON customer (email) 
	WHERE active = true;
---------------------------------------------------------------------------------------
--10. Create an index on expression on the customer table to quickly find records using the specified rule.
CREATE INDEX customer_flastname_idx 
	ON customer ((LEFT(first_name, 1) || ', ' || last_name));
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--11. Check the query plan that this index is being used.
EXPLAIN (ANALYZE)
SELECT *
FROM customer
WHERE ((LEFT(first_name, 1) || ', ' || last_name)) = 'f, lastname1';
---------------------------------------------------------------------------------------------










 
 
 
 
 
 
 
 
 
 
 
 
 
 
