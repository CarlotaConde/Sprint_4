-- SPRINT 4

-- NIVELL 1
-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes:

-- EXERCICI 1:
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.

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
    
-- importar taula
-- comprovació:
SELECT *
FROM users;
















-- taula 'users_ca'
CREATE TABLE IF NOT EXISTS users_ca (
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
    
-- importar taula
-- comprovació:
SELECT *
FROM users_ca;

-- taula 'users_uk'
CREATE TABLE IF NOT EXISTS users_uk (
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
    
-- importar taula
-- comprovació:
SELECT *
FROM users_uk;

-- taula 'users_usa'
CREATE TABLE IF NOT EXISTS users_usa (
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
    
-- importar taula
-- comprovació:
SELECT *
FROM users_usa;
