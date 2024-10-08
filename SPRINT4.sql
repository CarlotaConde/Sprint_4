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
    id VARCHAR(20) PRIMARY KEY,
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
-- dona error al establir la relació, ho soluciono fent:
SET FOREIGN_KEY_CHECKS=0;
-- estableixo la relació:
ALTER TABLE transactions
ADD FOREIGN KEY (products_ids) REFERENCES products(id);
-- ho tornem a actvar
SET FOREIGN_KEY_CHECKS=1;

-- USERS:
ALTER TABLE transactions
ADD INDEX idx_user_id (user_id ASC);
ALTER TABLE transactions
ADD FOREIGN KEY (user_id) REFERENCES users(id);


-- EXERCICI 1:
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.

-- amb JOIN (totes les transaccions, denegades o no):
SELECT  
  COUNT(transactions.id) AS 'Total de transaccions', 
  SUM(transactions.amount) AS 'Quantitat total (€)',
  user_id AS "ID de l'usuari", 
  users.name AS 'Nom', 
  users.surname AS 'Cognom', 
  users.country AS 'Pais', 
  users.city AS 'Ciutat', 
  users.postal_code AS 'Codi postal',
  users.phone AS 'Telèfon'
FROM transactions
JOIN users
ON transactions.user_id = users.id
GROUP BY 
  user_id, users.name, users.surname, users.country, users.city, users.postal_code, users.phone
HAVING COUNT(transactions.id) >30
ORDER BY COUNT(transactions.id) DESC;

-- amb JOIN (solament les no denegades)
SELECT  
  COUNT(transactions.id) AS 'Total de transaccions', 
  SUM(transactions.amount) AS 'Quantitat total (€)',
  user_id AS "ID de l'usuari", 
  users.name AS 'Nom', 
  users.surname AS 'Cognom', 
  users.country AS 'Pais', 
  users.city AS 'Ciutat', 
  users.postal_code AS 'Codi postal',
  users.phone AS 'Telèfon'
FROM transactions
JOIN users
ON transactions.user_id = users.id
WHERE transactions.declined = 0
GROUP BY 
  user_id, users.name, users.surname, users.country, users.city, users.postal_code, users.phone
HAVING COUNT(transactions.id) >30
ORDER BY COUNT(transactions.id) DESC;

-- amb subquery (totes les transaccions, denegades o no):
SELECT  
  id AS 'ID',
  name AS 'Nom', 
  surname AS 'Cognom', 
  country AS 'Pais', 
  city AS 'Ciutat', 
  postal_code AS 'Codi postal',
  phone AS 'Telèfon'
FROM users
WHERE users.id IN (SELECT user_id
		   FROM transactions
		   GROUP BY user_id
		   HAVING COUNT(transactions.id) >30);
                    
-- amb subquery (solament les no denegades):
SELECT  
  id AS 'ID',
  name AS 'Nom', 
  surname AS 'Cognom', 
  country AS 'Pais', 
  city AS 'Ciutat', 
  postal_code AS 'Codi postal',
  phone AS 'Telèfon'
FROM users
WHERE users.id IN (SELECT user_id
		   FROM transactions
		   WHERE declined = 0
		   GROUP BY user_id
		   HAVING COUNT(transactions.id) >30);

-- EXERCICI 2:
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

-- amb JOIN:
SELECT 
  AVG(transactions.amount) AS 'Mitja (€)', 
  credit_cards.iban AS 'IBAN', 
  companies.company_name AS 'Nom de la companyia', 
  companies.country AS 'Pais'
FROM transactions
JOIN credit_cards
ON transactions.card_id = credit_cards.id
JOIN companies
ON transactions.business_id = companies.id
WHERE companies.company_name = 'Donec Ltd'
GROUP BY credit_cards.iban, companies.company_name, companies.country
ORDER BY AVG(transactions.amount) DESC;

