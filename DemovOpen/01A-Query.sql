/*Demo 1 - Design, tipos, etc.
Data da criaçao: 25/09/2020
Desenvolvedor: Rodrigo Crespi
Objetivo: Demo #1 - SQL Sat SP
*/

/*TIP #1 Cleanup my cache */
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;

/*My Cache*/
SELECT      CAST(total_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [Total Duration (s)],
            CAST(total_worker_time * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% CPU],
            CAST((total_elapsed_time - total_worker_time) * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% Waiting],
            execution_count,
            CAST(total_elapsed_time / 1000000.0 / execution_count AS DECIMAL(28, 2)) AS [Average Duration (s)],
            SUBSTRING(qt.text,
                      (qs.statement_start_offset / 2) + 1,
                      ((CASE
                          WHEN qs.statement_end_offset = -1 THEN
                            LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                          ELSE
                            qs.statement_end_offset
                        END - qs.statement_start_offset) / 2) + 1) AS [Individual Query],
            SUBSTRING(qt.text, 1, 100) AS [Parent Query], DB_NAME(CAST(pa.value AS INT)) AS [Database]
FROM        sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) AS pa
WHERE       total_elapsed_time > 0
            AND pa.attribute = 'dbid'
            AND DB_NAME(CAST(pa.value AS INT)) = 'tsql'
ORDER BY    total_elapsed_time DESC;

--Try this queries
use tsql
go
select * from tsql.hr.Employees
go
Select getdate()
select * from sys.databases;
go

--Verify buffer
SELECT      CAST(total_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [Total Duration (s)],
            CAST(total_worker_time * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% CPU],
            CAST((total_elapsed_time - total_worker_time) * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% Waiting],
            execution_count,
            CAST(total_elapsed_time / 1000000.0 / execution_count AS DECIMAL(28, 2)) AS [Average Duration (s)],
            SUBSTRING(qt.text,
                      (qs.statement_start_offset / 2) + 1,
                      ((CASE
                          WHEN qs.statement_end_offset = -1 THEN
                            LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                          ELSE
                            qs.statement_end_offset
                        END - qs.statement_start_offset) / 2) + 1) AS [Individual Query],
            SUBSTRING(qt.text, 1, 100) AS [Parent Query], DB_NAME(CAST(pa.value AS INT)) AS [Database]
FROM        sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) AS pa
WHERE       total_elapsed_time > 0
            AND pa.attribute = 'dbid'
            AND DB_NAME(CAST(pa.value AS INT)) = 'tsql'
ORDER BY    total_elapsed_time DESC;


/*Cache Cleanner */
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;


/*TIP #1: Patterns matters		*/
USE TSQL;


GO
SELECT  firstname, lastname
FROM    HR.Employees;
GO
SELECT  lastname
, firstname
FROM    HR.Employees;
GO
SELECT  firstname , lastname
FROM    HR.Employees;
GO

--check queries in cache 
SELECT      CAST(total_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [Total Duration (s)],
            CAST(total_worker_time * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% CPU],
            CAST((total_elapsed_time - total_worker_time) * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% Waiting],
            execution_count,
            CAST(total_elapsed_time / 1000000.0 / execution_count AS DECIMAL(28, 2)) AS [Average Duration (s)],
            SUBSTRING(qt.text,
                      (qs.statement_start_offset / 2) + 1,
                      ((CASE
                          WHEN qs.statement_end_offset = -1 THEN
                            LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                          ELSE
                            qs.statement_end_offset
                        END - qs.statement_start_offset) / 2) + 1) AS [Individual Query],
            SUBSTRING(qt.text, 1, 100) AS [Parent Query], DB_NAME(CAST(pa.value AS INT)) AS [Database]
FROM        sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) AS pa
WHERE       total_elapsed_time > 0
            AND pa.attribute = 'dbid'
            AND DB_NAME(CAST(pa.value AS INT)) = 'tsql'
ORDER BY    total_elapsed_time DESC;


-- try once the first query
SELECT  firstname, lastname
FROM    HR.Employees;
GO

/*check again  */
SELECT      CAST(total_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [Total Duration (s)],
            CAST(total_worker_time * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% CPU],
            CAST((total_elapsed_time - total_worker_time) * 100.0 / total_elapsed_time AS DECIMAL(28, 2)) AS [% Waiting],
            execution_count,
            CAST(total_elapsed_time / 1000000.0 / execution_count AS DECIMAL(28, 2)) AS [Average Duration (s)],
            SUBSTRING(qt.text,
                      (qs.statement_start_offset / 2) + 1,
                      ((CASE
                          WHEN qs.statement_end_offset = -1 THEN
                            LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
                          ELSE
                            qs.statement_end_offset
                        END - qs.statement_start_offset) / 2) + 1) AS [Individual Query],
            SUBSTRING(qt.text, 1, 100) AS [Parent Query], DB_NAME(CAST(pa.value AS INT)) AS [Database]
FROM        sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
CROSS APPLY sys.dm_exec_plan_attributes(qs.plan_handle) AS pa
WHERE       total_elapsed_time > 0
            AND pa.attribute = 'dbid'
            AND DB_NAME(CAST(pa.value AS INT)) = 'tsql'
ORDER BY    total_elapsed_time DESC;


/*TIP #2: Creating objects in diferents filegroups		*/
USE master;
GO
DROP DATABASE IF EXISTS Design;
GO
CREATE DATABASE [Design] CONTAINMENT = NONE
ON PRIMARY (NAME = N'Design', FILENAME = 'c:\sqldata\Design.mdf', 
		SIZE = 1048576KB, FILEGROWTH = 0),
   FILEGROUP [Cliente] (NAME = N'Design_Cliente', FILENAME = 'c:\sqldata\Design_Cliente.ndf',
		 SIZE = 1048576KB, MAXSIZE = 1048576KB, FILEGROWTH = 126976KB)
LOG ON (NAME = N'Design_log', FILENAME = 'c:\sqldata\Design_log.ldf', 
		SIZE = 8192KB, FILEGROWTH = 65536KB);

--What is thew advantage of putting the metadata or files into separete files?


/* Tip #3: Data Type */
use vendas	  --Sell

go
 CREATE TABLE [dbo].selltypeok (idsell   [BIGINT] IDENTITY(1, 1) NOT NULL,
                                      dtsell   datetime NOT NULL,
                                      idclient [BIGINT] NOT NULL,
                                      nryear     [INT]    NOT NULL);
GO
CREATE TABLE [dbo].selltypenotok (idsell   [BIGINT] IDENTITY(1, 1) NOT NULL,
                                      dtsell   CHAR(10) NOT NULL,
                                      idclient [BIGINT] NOT NULL,
                                      nryear     [INT]    NOT NULL);
GO
--Insert into selltype
INSERT INTO dbo.selltypeok (dtsell, idclient, nryear)
SELECT  dtvenda, cdcliente, nrano
FROM    venda;
GO
INSERT INTO dbo.selltypenotok (dtsell, idclient, nryear)
SELECT  dtvenda, cdcliente, nrano
FROM    venda;
GO

--Limpa o Cache
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
--crtl + l
SELECT  dtsell, idclient, nryear
FROM    dbo.selltypeok;
SELECT  dtsell, idclient, nryear
FROM    dbo.selltypenotok;

--Right type, right return
SELECT  dtsell, idclient, nryear
FROM    dbo.selltypenotok
WHERE   dtsell
BETWEEN '2015-01-01' AND '2018-12-31';
GO
SELECT  dtsell, idclient, nryear
FROM    dbo.selltypeok
WHERE   dtsell
BETWEEN '2015-01-01' AND '2018-12-31';


/* Tip #4: Data Type matthers!
This exemple use a 8k because is the size of page 
well not really a page = 8Kb (8096 bytes), but we have a header */
USE TSQL;
GO
DROP TABLE IF EXISTS dbo.testenull;
GO
DROP TABLE IF EXISTS testenullchar;
GO
CREATE TABLE testenull (nome VARCHAR(8000) NULL);
GO
CREATE TABLE testenullchar (nome CHAR(8000) NULL);

--Insert rows only odd row number;
DECLARE @contador AS INT = 0;
WHILE @contador <= 1000
  BEGIN
    IF @contador % 2 = 0
      BEGIN
        INSERT INTO testenull (nome)
        VALUES ('vOpen UY');
        INSERT INTO testenullchar (nome)
        VALUES ('vOpen UY');
      END;
    SET @contador = @contador + 1;
  END;
GO
--do not forget Zoom
SELECT  COUNT(*)
FROM    testenull;
SELECT  COUNT(*)
FROM    testenullchar;
GO

--Results
sp_spaceused 'testenullchar';
GO
sp_spaceused 'testenull';
go

/* TIP #5: Binaries (Blobs, XMLs,MAX)
In Brazil we have a NFe and it's a law the vendor needs to keep safe 
a XML of NFe */


--Limpa o Cache
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO
USE ExBlob;
GO

-- Ex.: A
-- Show table extructure with crlt+m
SELECT  id, nome, data
FROM    comblob.cliente;

SELECT  id, nome, data
FROM    semblob.cliente;

-- Ex.: B
-- Where U lost?
SELECT  id, nome, data, foto
FROM    comblob.cliente;

SELECT      id, nome data
FROM        semblob.cliente c
INNER JOIN  semblob.foto f
  ON c.id = f.[idcliente];



/* TIP #5: Avoid using function before the WHERE clause	*/
--Limpa o Cache
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO
use TSQL
go
--Drop and Create a new table without index based on sales.orders
Drop table if exists orders
select orderid, custid, empid, orderdate into orders from sales.Orders
GO
select * from sys.indexes where object_id = object_id('orders')
GO

--Create a index to cover a query by date and return just orderid
create index ixPedidoData on orders(orderdate) include (orderid)


--Query (crtl + M)
select orderid from orders 
where DATEPART (year, orderdate) = 2006
and DATEPART (month, orderdate) = 8

select orderid from orders
where orderdate between '2006/08/01' and '2006/08/31'


/* TIP #5.1 About Index 
Ctrl + M */
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO
select orderid, custid from pedidos where orderdate between '2006/08/01'and '2006/08/31'

select orderid from pedidos
where orderdate between '2006/08/01' and '2006/08/31'


/* TIP #6: Computations */
use TSQL

DROP TABLE if exists oderdatailwithout
DROP TABLE if exists  oderdatailcomp
DROP TABLE if exists  oderdatailcompper
Checkpoint;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO

SELECT ORDERid, productid, unitprice, qty, discount 
INTO oderdatailwithout FROM sales.OrderDetails
SELECT ORDERid, productid, unitprice, qty, discount 
INTO oderdatailcomp FROM sales.OrderDetails
SELECT ORDERid, productid, unitprice, qty, discount 
INTO oderdatailcompper FROM sales.OrderDetails

-- How to solve computation column problem?
SELECT orderid, productid, unitprice, qty, discount, 
(unitprice * qty) AS total  FROM oderdatailwithout


--what if
ALTER TABLE oderdatailcomp ADD  total AS (qty*unitprice)
ALTER TABLE oderdatailcompper ADD total AS (qty*unitprice) PERSISTED

Checkpoint;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;

--Crtl+M
SELECT orderid, productid, unitprice, qty, discount, (unitprice * qty) AS total  FROM oderdatailwithout
SELECT orderid, productid, unitprice, qty, discount, total   FROM oderdatailcomp
SELECT orderid, productid, unitprice, qty, discount, total FROM oderdatailcompper

--but, persisted worst? :O
--The size of rows are bigger than

--But, we could do this better
CREATE INDEX ix_total ON oderdatailcompper (total) INCLUDE (orderid)
Checkpoint;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO
SELECT orderid,  (unitprice * qty) AS total  FROM oderdatailwithout
SELECT orderid, total   FROM oderdatailcomp
SELECT orderid,  total FROM oderdatailcompper

--But where does it worse? (There is no free lunch)
Checkpoint;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;
GO
INSERT INTO oderdatailwithout ([ORDERid],[productid],[unitprice],[qty],[discount]) VALUES
	(1000, 100, 10, 1, 3)
INSERT INTO oderdatailcomp ([ORDERid],[productid],[unitprice],[qty],[discount]) VALUES
	(1000, 100, 10, 1, 3)
INSERT INTO oderdatailcompper ([ORDERid],[productid],[unitprice],[qty],[discount]) VALUES
	(1000, 100, 10, 1, 3)

--Tuning is related to what you wnat to win or lose