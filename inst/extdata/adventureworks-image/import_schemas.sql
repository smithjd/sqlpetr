-- Create foreign server
DROP SERVER IF EXISTS mssql CASCADE;
CREATE SERVER mssql
    FOREIGN DATA WRAPPER tds_fdw
    OPTIONS (database 'AdventureWorks2017', servername 'mssql', port '1433', msg_handler 'notice');
CREATE USER MAPPING FOR postgres SERVER mssql
    OPTIONS (username 'sa', password 'sit-d0wn-COMIC');

-- Import the schemas
DROP SCHEMA IF EXISTS dbo;
CREATE SCHEMA dbo;
IMPORT FOREIGN SCHEMA dbo
	FROM SERVER mssql
	INTO dbo;

DROP SCHEMA IF EXISTS "HumanResources";
CREATE SCHEMA "HumanResources";
IMPORT FOREIGN SCHEMA "HumanResources"
	FROM SERVER mssql
	INTO "HumanResources";

DROP SCHEMA IF EXISTS "Person";
CREATE SCHEMA "Person";
IMPORT FOREIGN SCHEMA "Person"
	FROM SERVER mssql
	INTO "Person";

DROP SCHEMA IF EXISTS "Production";
CREATE SCHEMA "Production";
IMPORT FOREIGN SCHEMA "Production"
	FROM SERVER mssql
	INTO "Production";

DROP SCHEMA IF EXISTS "Purchasing";
CREATE SCHEMA "Purchasing";
IMPORT FOREIGN SCHEMA "Purchasing"
	FROM SERVER mssql
	INTO "Purchasing";

DROP SCHEMA IF EXISTS "Sales";
CREATE SCHEMA "Sales";
IMPORT FOREIGN SCHEMA "Sales"
	FROM SERVER mssql
	INTO "Sales";
