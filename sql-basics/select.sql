-- Show all users 
SELECT * FROM users;
----------------------------------
--Show users and their email
SELECT user_name, user_email FROM users;
------------------------------------
-- Show all books titles without duplication
SELECT DISTINCT title FROM book ;
------------------------------------
-- Retrieve orders with a total amount greater than 20
SELECT * FROM orders 
	WHERE total_amount > 20 ;
--------------------------------------
-- Retrieve users whose email address contains 'example'
SELECT user_name, user_email FROM users
WHERE user_email Like '%example%';
-------------------------------------
-- Retrieve orders placed by users with IDs 2, or 3:
SELECT * FROM orders 
	WHERE user_id = 2 or user_id = 3;
---------------------------------------
-- Retrieve books published between specific dates:
SELECT * FROM book 
	WHERE publishing_date BETWEEN '1920-01-01' and '1950-01-01' ;
----------------------------------------
-- Retrieve users who have not provided a password:
SELECT user_name, user_password FROM users
	WHERE user_password IS NULL;
------------------------------------------
-- Retrieve authors whose names start with 'H':
SELECT author_name FROM author
	WHERE author_name LIKE 'H%';
------------------------------------------
-- Retrieve orders and show the role for each user who places the order
SELECT o.order_id, o.order_date, r.role_name FROM orders AS o
	JOIN user_role AS ur
		ON o.user_id = ur.user_id 
	JOIN roles AS r
		ON ur.role_id = r.role_id;
------------------------------------------
-- Retrieve orders and the name of the person who places each order
SELECT user_name, order_id  AS order_no FROM orders AS o
	JOIN users AS u 
		ON o.user_id = u.user_id;
------------------------------------------
-- Retrieve what book(s) each  person  orders:)
SELECT u.user_name AS customer, o.order_id AS order_no, b.title  AS book FROM orders AS o
	JOIN users AS u 
		ON o.user_id = u.user_id
	JOIN book_order AS bo 
		ON bo.book_id = o.order_id
	JOIN book AS b
		ON b.book_id = bo.book_id ;
-----------------------------------------------
-- Retrieve orders placed by users who are also admins:
SELECT o.order_id AS order_no, u.user_name, r.role_name FROM orders AS o
	JOIN users u 
		ON u.user_id = o.user_id  
	JOIN user_role ur
		ON ur.user_id = u.user_id
	JOIN roles r
		ON r.role_id = ur.role_id
	WHERE r.role_name = 'Admin' ;
------------------------------------------------------------------------
-- Retrieve books published after 1950 with a price greater than 10
SELECT title, publishing_date, price FROM book
	WHERE publishing_date > '1950-01-01' AND price > 10 ;
-------------------------------------------------------------------------
-- Retrieve users(user_id) and how many orders each one has placed:
SELECT user_id, COUNT(order_id) AS order_times 
	FROM orders
	GROUP BY (user_id);
-------------------------------------------------------------------------
--Retrieve users names and how many orders each one has placed:
SELECT  u.user_id, u.user_name, COUNT(o.order_id) AS order_times
	FROM users u
	JOIN orders o 
		ON o.user_id = u.user_id
	GROUP BY(u.user_id);
--------------------------------------------------------------------------
-- Retrieve users (user_id) who have placed exactly 2 orders:
SELECT user_id, COUNT(order_id)
	FROM orders
	GROUP BY(user_id)
		HAVING COUNT(order_id) =2;
--------------------------------------------------------------------------
SELECT o.user_id,u.user_name, COUNT(o.order_id) FROM orders o
	JOIN users u ON u.user_id = o.user_id
		GROUP BY(o.user_id, u.user_name)
			HAVING COUNT(order_id) =2 ;
---------------------------------------------------------------------------
-- Retrieve users  who have placed at least 2 orders:
SELECT o.user_id,u.user_name, COUNT(o.order_id) FROM orders o
	JOIN users u ON u.user_id = o.user_id
	GROUP BY(o.user_id, u.user_name)
			HAVING COUNT(order_id) >=2 ;
-----------------------------------------------------------------------------
-- -- Retrieve users  who have placed at least 2 orders: ( Alternative way)
SELECT  u.*, COUNT(o.order_id) FROM users u
	LEFT JOIN orders o ON u.user_id = o.user_id
	GROUP BY(u.user_id)
		HAVING COUNT(o.order_id) >= 2;
-----------------------------------------------------------------------------
-- Retrieve users (only id, name and number of orders) who have placed at least 2 orders:
SELECT u.user_id,u.user_name, COUNT(o.order_id) AS num_of_orders
	FROM orders o
	JOIN users u ON u.user_id = o.user_id
	GROUP BY(u.user_id)
		HAVING COUNT(order_id) >=2 ;
-------------------------------------------------------------------
-- Retrieve users who have placed orders with a total amount greater than the average total amount of all orders:
SELECT u.*,  SUM(o.total_amount) AS total FROM orders o
	JOIN users u 
		ON u.user_id = o.user_id
	GROUP BY(u.user_id)
		HAVING SUM(o.total_amount) > (SELECT AVG(total_amount) FROM orders);
------------------------------------------------------------------------
--Retrieve users who have not placed any orders:
SELECT *
FROM users
WHERE NOT EXISTS (
    SELECT 1
    FROM orders
    WHERE orders.user_id = users.user_id
);
----------------------------------------------------------------------------
-- Retrieve all authors and their corresponding books:
SELECT au.*, b.title, b.publishing_date 
	FROM author au
	JOIN book_author bu 
		ON bu.author_id = au.author_id
	JOIN book b
		ON b.book_id = bu.book_id;
---------------------------------------------------------------------------
-- Retrieve how many books each author published:
SELECT au.author_name, COUNT(bu.author_id) AS num_book
	FROM author au
	JOIN book_author bu 
		ON bu.author_id = au.author_id
	GROUP BY(au.author_name)
	ORDER BY num_book DESC;	
---------------------------------------------------------------------------
-- Retrieve books written by authors whose names start with 'G':
SELECT b.title, au.author_name FROM author au
	JOIN book_author bu
		ON au.author_id = bu.author_id
	JOIN book b
		ON b.book_id = bu.book_id
	WHERE au.author_name LIKE 'G%';
---------------------------------------------------------------------------
-- Retrieve books written by authors whose names start with 'G' 
-- OR books published after 2010 directly from the book table
SELECT b.title,b.publishing_date, au.author_name FROM author au
	JOIN book_author bu
		ON au.author_id = bu.author_id
	JOIN book b
		ON b.book_id = bu.book_id
	WHERE au.author_name LIKE 'G%'
	
UNION

SELECT b.title,b.publishing_date, au.author_name FROM author au
	JOIN book_author bu
		ON au.author_id = bu.author_id
	JOIN book b
		ON b.book_id = bu.book_id
	WHERE b.publishing_date > '2010-01-01' ;
-------------------------------------------------------------------------
-- Select all books and their authors, including books without authors
SELECT b.title, au.author_name, b.publishing_date FROM book b
	 LEFT JOIN book_author ba
		ON ba.book_id = b.book_id
	 LEFT JOIN author au
		ON au.author_id = ba.author_id;
-----------------------------------------------------------------------------
-- Select all users and their roles, including users without roles
SELECT u.user_name, r.role_name FROM users u
	LEFT JOIN user_role ur
		ON ur.user_id = u.user_id
	LEFT JOIN roles r 
		ON r.role_id = ur.role_id;
-------------------------------------------------------------------------------
-- Calculate the average price of books
SELECT ROUND(AVG(price),2) avg_price FROM book;
-------------------------------------------------------------------------------
-- Convert book titles to uppercase:
SELECT UPPER(user_name), LOWER(user_email) FROM users;
------------------------------------------------------------------------------






