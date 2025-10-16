CREATE TABLE users
(	user_id SERIAL PRIMARY KEY,
  	user_name VARCHAR(256) NOT NUll,
 	user_password VARCHAR(256),
 	user_email VARCHAR(256) NOT NULL	
 );
----------------------------------------------
 CREATE TABLE role
(	rol_id SERIAL PRIMARY KEY,
	role_name VARCHAR(256) NOT NUll	
 );
 ---------------------------------------------
DROP TABLE role;

CREATE TABLE roless
(	rol_id SERIAL PRIMARY KEY,
 	role_name VARCHAR(256) NOT NUll	
);
--------------------------------------------
ALTER TABLE roless
RENAME TO roles ;
--------------------------------------------
ALTER TABLE roles
DROP COLUMN rol_id ;
--------------------------------------------
ALTER TABLE roles
ADD COLUMN role_id SERIAL PRIMARY KEY;
--------------------------------------------
CREATE TABLE user_role
( 	user_id INTEGER,
	role_id INTEGER,
	FOREIGN KEY(user_id) REFERENCES users(user_id),
	FOREIGN KEY(role_id) REFERENCES roles(role_id),
	PRIMARY KEY(user_id, role_id)
);
-----------------------------------------------
CREATE TABLE orders
( 
	order_id SERIAL PRIMARY KEY,
	user_id  INT,
	order_date DATE,
	total_amount INTEGER,
	FOREIGN KEY(user_id) REFERENCES users(user_id)
);

 CREATE TABLE book
 ( 
	 book_id SERIAL PRIMARY KEY,
	title VARCHAR(256) NOT NULL,
 	price INT NOT NULL,
 	publishing_date DATE
);

 CREATE TABLE book_order
( 	book_id INTEGER,
 	order_id INTEGER,
 	quantity INTEGER NOT NULL,
 	FOREIGN KEY(book_id) REFERENCES book(book_id),
	FOREIGN KEY(order_id) REFERENCES orders(order_id),
 	PRIMARY KEY(book_id, order_id)
 );
----------------------------------------------------
 CREATE TABLE bookexampler
( 
 	exampler_id SERIAL PRIMARY KEY,
 	book_id INTEGER,
 	quantity INTEGER,
 	FOREIGN KEY(book_id) REFERENCES book (book_id)
);
------------------------------------------------------
CREATE TABLE author
(
	author_id SERIAL PRIMARY KEY,
	author_name VARCHAR(256) NOT NULL
);
--------------------------------------------------------- 
CREATE TABLE book_author
 ( 	book_id INT,
 	author_id INT,
 	FOREIGN KEY(book_id) REFERENCES book(book_id),
 	FOREIGN KEY( author_id) REFERENCES author(author_id),
 	PRIMARY KEY( book_id, author_id)
);




