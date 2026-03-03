/*
=========================================================
Creeate Database and schemas
=========================================================

Purpose:
Checks if the database exists. If it does, it is dropped and recreated. 
Creates a new database with three schemas: bronze, silver, and gold.

Warning:
Existing databases with the same name will be overwritten/dropped.
*/
USE master

IF (SELECT count(name) FROM sys.databases WHERE name = 'DataWarehouse') = 1
BEGIN
	IF (SELECT database_id 
		FROM sys.dm_exec_sessions 
		WHERE EXISTS(SELECT database_id 
						FROM sys.databases 
						WHERE name = 'DataWarehouse') 
		and status = 'running') = 1
	BEGIN
		ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE DataWarehouse;
	END;
	ELSE
	BEGIN
		DROP DATABASE DataWarehouse;
	END;
END;

create database DataWarehouse;
GO

use DataWarehouse;
GO

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO