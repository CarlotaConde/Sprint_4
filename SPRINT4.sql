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

-- Taula 'users':
ALTER TABLE transactions
ADD INDEX idx_user_id (user_id ASC);
ALTER TABLE transactions
ADD FOREIGN KEY (user_id) REFERENCES users(id);


-- EXERCICI 1:
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.

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
                    
-- EXERCICI 2:
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
SELECT 
  credit_cards.iban AS 'IBAN', 
  ROUND(AVG(transactions.amount),2) AS 'Mitja (€)'
FROM transactions 
JOIN credit_cards  
ON transactions.card_id = credit_cards.id
JOIN companies  
ON transactions.business_id = companies.id
WHERE companies.company_name = 'Donec Ltd'
GROUP BY credit_cards.iban;

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


-- He intentat crear una taula intermitja de ‘transaction_product’, 
-- per fer l’unió entre ‘products’ i ‘transactions’ per no em sortía com separar els ‘id’, 
-- perque a la taula ‘transactions’ els ‘products_ids’ están separats per comes.

-- Creem l'índex i la 'Foreign Key'(FK) per poder estbalir la relació entre les taules 'products' i 'transactions'
-- Primer creo l'índex a la taula 'transactions', ja que aquesta taula és el punt d'unió de totes (model estrella).
-- Després indico quina es la FK per després indicar-li a quina columna de la taula fa referència.
ALTER TABLE transactions
ADD INDEX idx_products_ids (products_ids ASC);
-- Surt un error al establir la relació, ho soluciono fent (sé que no es el més convenient, però es de la única manera que ho he pogut solucionar):
SET FOREIGN_KEY_CHECKS=0;
-- Estableixo la relació:
ALTER TABLE transactions
ADD FOREIGN KEY (products_ids) REFERENCES products(id);
-- Ho tornem a activar:
SET FOREIGN_KEY_CHECKS=1;

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
