CREATE DATABASE IF NOT EXISTS FINTRACK_DB;

CREATE SCHEMA IF NOT EXISTS FINTRACK_DB.RAW;
CREATE SCHEMA IF NOT EXISTS FINTRACK_DB.STAGING;
CREATE SCHEMA IF NOT EXISTS FINTRACK_DB.MARTS;

CREATE SCHEMA IF NOT EXISTS FINTRACK_DB.SNAPSHOTS;

GRANT USAGE, CREATE TABLE ON SCHEMA FINTRACK_DB.SNAPSHOTS TO ROLE FINTRACK_ROLE;

CREATE WAREHOUSE IF NOT EXISTS FINTRACK_WH
    WITH WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE;

CREATE ROLE IF NOT EXISTS FINTRACK_ROLE;

CREATE OR REPLACE USER  FINTRACK_USER
    PASSWORD = 'Theodoric2604?'
    DEFAULT_ROLE = FINTRACK_ROLE
    DEFAULT_WAREHOUSE = FINTRACK_WH
    MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE FINTRACK_ROLE TO USER FINTRACK_USER;

GRANT USAGE ON DATABASE FINTRACK_DB TO ROLE FINTRACK_ROLE;
GRANT USAGE ON WAREHOUSE FINTRACK_WH TO ROLE FINTRACK_ROLE;

GRANT USAGE, CREATE TABLE, CREATE VIEW
    ON SCHEMA FINTRACK_DB.RAW TO ROLE FINTRACK_ROLE;

GRANT USAGE, CREATE TABLE, CREATE VIEW
    ON SCHEMA FINTRACK_DB.STAGING TO ROLE FINTRACK_ROLE;

GRANT USAGE, CREATE TABLE, CREATE VIEW
    ON SCHEMA FINTRACK_DB.MARTS TO ROLE FINTRACK_ROLE;

GRANT ROLE FINTRACK_ROLE TO ROLE SYSADMIN;

USE ROLE FINTRACK_ROLE;
USE WAREHOUSE FINTRACK_WH;
USE DATABASE FINTRACK_DB;
USE SCHEMA RAW;

CREATE OR REPLACE TABLE raw_comptes (
    id INT,
    nom_client VARCHAR,
    type_compte VARCHAR,
    statut VARCHAR,
    date_ouverture DATE,
    solde_initial NUMBER(12,2)
);

INSERT INTO raw_comptes VALUES
(1,'Amina Kone','courant','Actif','2023-01-15',500.00),
(2,'Amina Kone','epargne','actif','2023-01-15',2000.00),
(3,'Bertrand Loko','courant','ACTIF','2022-11-03',150.00),
(4,'Chantal Mensah','joint','actif','2024-02-20',800.00),
(5,'David Agossou','epargne','inactif','2021-06-10',5000.00);

-- Catégories
CREATE OR REPLACE TABLE raw_categories (
    id INT,
    nom VARCHAR,
    type VARCHAR,
    groupe VARCHAR
);

INSERT INTO raw_categories VALUES
(1,'Salaire','revenu','Revenus'),
(2,'Loyer','depense','Logement'),
(3,'Courses','depense','Alimentation'),
(4,'Restaurant','depense','Alimentation'),
(5,'Transport','depense','Transport'),
(6,'Loisirs','depense','Divers');

-- Transactions
CREATE OR REPLACE TABLE raw_transactions (
    id INT,
    compte_id INT,
    categorie_id INT,
    date_transaction TIMESTAMP,
    montant NUMBER(12,2),
    type_operation VARCHAR,
    statut VARCHAR
);

INSERT INTO raw_transactions VALUES
(1,1,1,'2024-06-01 09:00:00',1200.00,'credit','validee'),
(2,1,2,'2024-06-02 10:00:00',400.00,'debit','validee'),
(3,1,3,'2024-06-05 18:30:00',85.50,'debit','validee'),
(4,1,5,'2024-06-10 08:00:00',45.00,'debit','validee'),
(5,3,1,'2024-06-01 09:00:00',900.00,'credit','validee'),
(6,3,2,'2024-06-03 10:00:00',350.00,'debit','validee'),
(7,3,4,'2024-06-08 20:00:00',60.00,'debit','validee'),
(8,4,1,'2024-06-01 09:00:00',1500.00,'credit','validee'),
(9,4,2,'2024-06-04 10:00:00',600.00,'debit','validee'),
(10,4,6,'2024-06-15 19:00:00',120.00,'debit','en_attente'),
(11,1,1,'2024-07-01 09:00:00',1200.00,'credit','validee'),
(12,1,3,'2024-07-04 18:00:00',92.00,'debit','validee'),
(13,3,1,'2024-07-01 09:00:00',900.00,'credit','validee'),
(14,3,5,'2024-07-06 08:00:00',50.00,'debit','validee'),
(15,4,1,'2024-07-01 09:00:00',1500.00,'credit','validee'),
(16,4,3,'2024-07-05 18:00:00',210.00,'debit','validee');

-- Budgets
CREATE OR REPLACE TABLE raw_budgets (
    id INT,
    compte_id INT,
    categorie_id INT,
    mois DATE,
    montant NUMBER(12,2)
);

INSERT INTO raw_budgets VALUES
(1,1,2,'2024-06-01',400.00),
(2,1,3,'2024-06-01',100.00),
(3,1,5,'2024-06-01',60.00),
(4,3,2,'2024-06-01',350.00),
(5,3,4,'2024-06-01',80.00),
(6,4,2,'2024-06-01',600.00),
(7,4,6,'2024-06-01',100.00),
(8,1,3,'2024-07-01',100.00),
(9,3,5,'2024-07-01',60.00),
(10,4,3,'2024-07-01',180.00);