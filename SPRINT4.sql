-- SPRINT 4

-- NIVELL 1
-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes:

-- EXERCICI 1:
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.

-- Primer de tot he de crear les taules:

-- taula companies:
CREATE DATABASE IF NOT EXISTS bd;
USE bd;

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
	id varchar(20) PRIMARY KEY,
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
	id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price VARCHAR(10),
    colour VARCHAR(7),
    weight VARCHAR(4),
    cvv VARCHAR(3),
    warehouse_id VARCHAR(10)
);


SELECT *
FROM products;

    -- Creamos la tabla transaction
    CREATE TABLE IF NOT EXISTS transactions (
        id VARCHAR(255) PRIMARY KEY,
        card_id VARCHAR(15) 
        -- REFERENCES credit_card(id),
        business_id VARCHAR(20), 
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
		declined BOOLEAN,
        products_ids VARCHAR(20),
        user_id INT 
        -- REFERENCES user(id),
        lat FLOAT,
        longitude FLOAT,
        FOREIGN KEY (company_id) REFERENCES company(id) 
    );
    

SELECT *
FROM transactions;
