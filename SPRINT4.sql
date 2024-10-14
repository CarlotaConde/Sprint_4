-- SPRINT 4

-- NIVELL 1
-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes:

-- Primer de tot he de crear la base de dades:

CREATE DATABASE IF NOT EXISTS bd;
USE bd;

-- Crear la taula 'companies':
CREATE TABLE IF NOT EXISTS companies (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );

-- Un cop tenim tots els arxius '.csv' a la carpeta 'Uploads' de MySQL
-- Importar l'arxiu 'companies.csv' a la taula creada 'companies'
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv" 
INTO TABLE companies
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

-- Comprovació:
SELECT *
FROM companies;

-- Crear la taula 'credit_cards':
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

-- Importar l'arxiu 'credit_cards.csv' a la taula creada 'credit_cards'
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv" 
INTO TABLE credit_cards
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

-- Comprovació:
SELECT *
FROM credit_cards;

-- Crear la taula 'products':
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(50),
    price VARCHAR(10),
    colour VARCHAR(7),
    weight VARCHAR(4),
    warehouse_id VARCHAR(10)
);

-- Importar l'arxiu 'products.csv' a la taula creada 'products'
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv" 
INTO TABLE products
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

-- Comprovació:
SELECT *
FROM products;

-- Crear la taula 'transactions':
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
    
-- Importar l'arxiu 'transactions.csv' a la taula creada 'transactions'
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv" 
INTO TABLE transactions
FIELDS TERMINATED BY ';' 
IGNORE 1 LINES;

-- Comprovació:
SELECT *
FROM transactions;

-- Crear la taula 'users':
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
    
-- Importar les taules (3 arxius: users_ca.csv, users_uk.csv i users_usa.csv)
-- Taula 'USA'
-- Importar l'arxiu 'users_usa.csv' a la taula creada 'users'
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv" 
INTO TABLE users
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
-- Taula 'UK'
-- Importar l'arxiu 'users_uk.csv' a la taula creada 'users'
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv" 
INTO TABLE users
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
-- Taula 'CA'
-- Importar l'arxiu 'users_ca.csv' a la taula creada 'users'
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv" 
INTO TABLE users
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- Comprovació:
SELECT *
FROM users;

-- Creem els 'Índexs' i les 'Foreign Keys'(FK) per poder estbalir les relacions entre les taules:
-- Primer creo l'índex a la taula 'transactions', ja que aquesta taula és el punt d'unió de totes (model estrella).
-- Després indico quina es la FK per després indicar-li a quina columna de la taula fa referència.

-- Taula 'companies':
ALTER TABLE transactions
ADD INDEX idx_business_id (business_id ASC);
ALTER TABLE transactions
ADD FOREIGN KEY (business_id) REFERENCES companies(id);

-- Taula 'credit_cards':
ALTER TABLE transactions
ADD INDEX idx_card_id (card_id ASC);
ALTER TABLE transactions
ADD FOREIGN KEY (card_id) REFERENCES credit_cards(id);

-- Taula 'products':
ALTER TABLE transactions
ADD INDEX idx_products_ids (products_ids ASC);
-- Surt un error al establir la relació, ho soluciono fent:
SET FOREIGN_KEY_CHECKS=0;
-- Estableixo la relació:
ALTER TABLE transactions
ADD FOREIGN KEY (products_ids) REFERENCES products(id);
-- Ho tornem a activar:
SET FOREIGN_KEY_CHECKS=1;

-- Taula 'users':
ALTER TABLE transactions
ADD INDEX idx_user_id (user_id ASC);
ALTER TABLE transactions
ADD FOREIGN KEY (user_id) REFERENCES users(id);


-- EXERCICI 1:
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.
-- L'he fet amb subquery i amb JOIN, fent-lo amb JOIN per poder visualitzar més dades que fent una subquery no surten.
-- A més, després ho he fet de 2 maneres, en una he mostrat tota la informació de la consulta, ja sigui que les transaccions que han fet els usuaris s'hagin denegat o no,
-- i en l'altre filtrant solament per aquelles transaccions que no han sigut denegades i si que s'han dut a terme.

-- Amb subquery (totes les transaccions, denegades o no):
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
                    
-- Amb subquery (solament les no denegades):
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


-- Amb JOIN (totes les transaccions, denegades o no):
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

-- Amb JOIN (solament les no denegades)
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

-- EXERCICI 2:
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

-- Amb subquery (per veure de manera resumida la mitjana):
SELECT 
  ROUND(AVG(amount),2) AS 'Mitja (€)'
FROM transactions
WHERE transactions.business_id IN (SELECT companies.id
				   FROM companies
                                   WHERE company_name = 'Donec Ltd');

-- Amb JOIN (per veure a part de la mitjana, més informació adicional):
SELECT 
  ROUND(AVG(transactions.amount),2) AS 'Mitja (€)', 
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
ORDER BY  ROUND(AVG(transactions.amount),2) DESC;

-- NIVELL 2
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades i genera la següent consulta:

CREATE TABLE card_estat AS
SELECT 
    credit_cards.id,
    credit_cards.iban,
     CASE
        WHEN (COUNT(transactions.declined) = 1) >= 3 THEN 'bloquejada'
        ELSE 'activa'
	END AS 'Estat'
FROM transactions
JOIN credit_cards
ON transactions.card_id = credit_cards.id
GROUP BY credit_cards.id, credit_cards.iban;

-- Comprovació:
SELECT *
FROM card_estat;

-- Crear la relació amb la taula 'credit_cards', crent primer l'índex i després relacionant la FK amb la columna de l'altre taula:
ALTER TABLE credit_cards
ADD INDEX idx_card_id (id ASC);
ALTER TABLE card_estat
ADD FOREIGN KEY (id) REFERENCES credit_cards(id);

-- EXERCICI 1
-- Quantes targetes estan actives?

SELECT 
  COUNT(id) AS 'Targetes actives'
FROM card_estat
WHERE Estat = 'activa';
-- El resultat vol dir que totes estan actives, ja que el número total de targetes es 275.

-- NIVELL 3
-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

-- (taula creada al principi de l'exercici)

-- EXERCICI 1
-- Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

SELECT 
  COUNT(transactions.id) AS 'Quantitat de vegades venut',
  products.product_name AS 'Nom del producte',
  products.id AS 'ID del producte',
  products.price AS 'Preu per unitat'
FROM transactions
JOIN products
ON transactions.products_ids = products.id
WHERE transactions.declined = 0
GROUP BY products.id, products.product_name, products.price
ORDER BY COUNT(transactions.id) DESC;
