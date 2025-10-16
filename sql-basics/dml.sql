-- Populate users table with data samples.
INSERT INTO users (user_id, user_name, user_password, user_email) VALUES
	(1,'MOhammed', 'MO123','mohammed@example.com' ),
	(2,'Sami','Sami123','sami@example.com'),
	(3,'Alex','Alex123','Alex@example.com');
-----------------------------------------------
-- Correct the typo 'O' --> 'o'
UPDATE users 
SET user_name = 'Mohammed'
WHERE user_id = 1 ;
------------------------------------------------
-- Populate roles table with data samples.
INSERT INTO roles VALUES 
	('Admin'),
	('Customer');
-------------------------------------------------
-- Populate user_role table with data samples.
INSERT INTO user_role (user_id, role_id) vALUES
	(1,1),
	(2,2),
	(3,1),
	(1,2);
-------------------------------------------------
-- Populate orders table with data samples.
INSERT INTO orders (user_id, order_date, total_amount) VALUES
	(1, '2024-02-09', 50),
	(2, '2024-02-09', 30),
	(3, '2024-02-08', 20);
------------------------------------------------
-- Populate book table with data samples.
INSERT INTO book (title, price, publishing_date) VALUES
('The Great Gatsby', 15, '1925-04-10'),
('To Kill a Mockingbird', 12, '1960-07-11'),
('1984', 10, '1949-06-08');
----------------------------
INSERT INTO book VALUES
	(4,'Big Dreams',16,'2030-12-12');
-----------------------------
INSERT INTO book (book_id,title,price) 
	VALUES (5,'Puzzle',19);
--------------------------------------------------
INSERT INTO book_order (book_id, order_id, quantity) VALUES
(1, 1, 2),
(2, 2, 1),
(3, 3, 3);	
----------------------------------------------------
INSERT INTO bookexampler (book_id, quantity) VALUES
(1, 10),
(2, 5),
(3, 8);
----------------------------------------------------
INSERT INTO author (author_name) VALUES
('F. Scott Fitzgerald'),
('Harper Lee'),
('George Orwell');
---------------------------------------------------
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4,1)
;
---------------------------------------------------
UPDATE  users
SET user_name = 'Alexes'
WHERE user_id = 3;
-----------------------------------------------------
DELETE FROM bookexampler 
WHERE book_id = 2;
-----------------------------------------------------
INSERT INTO bookexampler VALUES 
	(2,2,7);
-----------------------------------------------------
INSERT INTO users (user_id,user_name, user_email) 
	VALUES (4,'Yaser','yaser@unauthorized.com');
-----------------------------------------------------






