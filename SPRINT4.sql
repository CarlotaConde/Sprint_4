-- SPRINT 4

-- NIVELL 1
-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes:

-- Primer de tot he de crear la base de dades:

CREATE DATABASE IF NOT EXISTS bd;
USE bd;

-- taula companies:
CREATE TABLE IF NOT EXISTS companies (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );
-- importar taula
-- comprovació:
SELECT *
FROM companies;

-- taula credit_cards:
CREATE TABLE IF NOT EXISTS credit_cards (
    id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(5),
    iban VARCHAR(50),
    pan VARCHAR(25),
    pin VARCHAR(4),
    cvv VARCHAR(3),
    track1 VARCHAR(200),
    track2 VARCHAR(200),
    expiring_date VARCHAR(10)
);

-- importar taula
-- comprovació:
SELECT *
FROM credit_cards;

-- taula products:
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(50),
    price VARCHAR(10),
    colour VARCHAR(7),
    weight VARCHAR(4),
    warehouse_id VARCHAR(10)
);

-- importar taula
-- comprovació:
SELECT *
FROM products;

-- Taula transactions:
CREATE TABLE IF NOT EXISTS transactions (
        id VARCHAR(255) PRIMARY KEY,
        card_id VARCHAR(10),
        business_id VARCHAR(10), 
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
	declined BOOLEAN,
        products_ids VARCHAR(20),
        user_id INT,
        lat FLOAT,
        longitude FLOAT
    );
    
-- importar taula
-- comprovació:
SELECT *
FROM transactions;

-- tabla users
CREATE TABLE IF NOT EXISTS users (
        id INT PRIMARY KEY,
        name VARCHAR(20),
        surname VARCHAR(20),
        phone VARCHAR(15),
        email VARCHAR(100),
        birth_date VARCHAR(15),
        country VARCHAR(100),
        city VARCHAR(100),
        postal_code VARCHAR(10),
        address VARCHAR(200)
    );
    
-- importar taules (3 arxius: users_ca, users_uk i users_usa)
-- comprovació:
SELECT *
FROM users;

-- creem INDEXS i FK:

-- COMPANIES:
ALTER TABLE transactions
ADD INDEX idx_business_id (business_id ASC);

ALTER TABLE transactions
ADD FOREIGN KEY (business_id) REFERENCES companies(id);

-- CREDIT_CARDS:
ALTER TABLE transactions
ADD INDEX idx_card_id (card_id ASC);

ALTER TABLE transactions
ADD FOREIGN KEY (card_id) REFERENCES credit_cards(id);

-- PRODUCTS:
ALTER TABLE transactions
ADD INDEX idx_products_ids (products_ids ASC);

ALTER TABLE transactions
ADD FOREIGN KEY (products_ids) REFERENCES products(id);

-- USERS:
ALTER TABLE transactions
ADD INDEX idx_user_id (user_id ASC);

ALTER TABLE transactions
ADD FOREIGN KEY (user_id) REFERENCES users(id);


-- EXERCICI 1:
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.
