/*Demo 1 - Design, tipos, etc.
Data da criaçao: 25/09/2020
Desenvolvedor: Rodrigo Crespi
Objetivo: Demo #2 - SQL Sat SP
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


/*Ex 1
Padr�o de nomenclatura e padr�o de codifica��o */
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


/* another pattern issue
Creating objects in diferents filegroups		*/
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

--What advantages of placing metadata in a separate file?



-- Ex3
-- Padr�o de nomenclatura
--DROP dbo.cliente
USE Design;
GO
CREATE TABLE dbo.Clients -- ou dbo.AD_Cliente
( id   INT          NOT NULL IDENTITY(1, 1),
  name VARCHAR(200) NOT NULL); -- Cliente -- ON PRIMARY

GO

-- Com Sugest�o de Padr�o
CREATE SCHEMA Administrative;
GO
-- drop table administrativo.cliente
CREATE TABLE Administrative.Client (cdclient INT          NOT NULL IDENTITY(1, 1),
                                     nmclient VARCHAR(200) NOT NULL) ;
GO
CREATE USER [adm] WITHOUT LOGIN WITH DEFAULT_SCHEMA = Administrative;
GO
ALTER ROLE [db_owner] ADD MEMBER [adm];
GO

-- Ex 4.1
-- Tipagem de dados e tamanhos

CREATE SCHEMA Operacional;
GO
-- N�o FAZER DESTA FORMA - Cuidado com os tipos de hora e data
CREATE TABLE Operacional.workloadtime_donot (cdworkloadtime INT     NOT NULL IDENTITY(1, 1),
                                             hrstart    CHAR(5) NOT NULL,  --00:00
                                             hrend       CHAR(5) NOT NULL);
GO
-- FAZER DESTA MANEIRA
CREATE TABLE Operacional.workloadtime (cdworkloadtime INT  IDENTITY(1, 1) NOT NULL,
                                    hrstart    TIME NOT NULL,
                                    hrend       TIME NOT NULL);
GO

-- Ex 4.2
-- TIPO
USE vendas;
GO
--Criar duas tabelas uma com data como char e outra com Datetime
CREATE TABLE [dbo].[vendaTipoCerto] ([cdvenda]   [BIGINT]   IDENTITY(1, 1) NOT NULL,
                                     [dtvenda]   [DATETIME] NOT NULL,
                                     [cdcliente] [BIGINT]   NOT NULL,
                                     [nrano]     [INT]      NOT NULL);
GO
CREATE TABLE [dbo].[vendaTipoErrado] ([cdvenda]   [BIGINT] IDENTITY(1, 1) NOT NULL,
                                      [dtvenda]   CHAR(10) NOT NULL,
                                      [cdcliente] [BIGINT] NOT NULL,
                                      [nrano]     [INT]    NOT NULL);
GO
--Insere os registros da tabela venda
INSERT INTO dbo.vendaTipoCerto (dtvenda, cdcliente, nrano)
SELECT  dtvenda, cdcliente, nrano
FROM    venda;
GO
INSERT INTO dbo.vendaTipoErrado (dtvenda, cdcliente, nrano)
SELECT  dtvenda, cdcliente, nrano
FROM    venda;
GO

--Limpa o Cache
checkpoint;
DBCC FREEPROCCACHE();
--crtl + l
SELECT  dtvenda, cdcliente, nrano
FROM    dbo.vendaTipoCerto;
SELECT  dtvenda, cdcliente, nrano
FROM    dbo.vendaTipoErrado;

-- Usar o tipo certo evita gambiarra!
SELECT  dtvenda, cdcliente, nrano
FROM    dbo.vendaTipoErrado
WHERE   dtvenda
BETWEEN '2015-01-01' AND '2018-12-31';
GO
SELECT  dtvenda, cdcliente, nrano
FROM    dbo.vendaTipoCerto
WHERE   dtvenda
BETWEEN '2015-01-01' AND '2018-12-31';







/* TDC - POA 2016
   SQL Sat 570 SP
   Demo 2
   Data de cria��o: 5/10/16
   Dev: Rodrigo
   Objetivo: Design/t-SQL
*/

-- Ex1 (Char e os nulos)

USE TSQL;
GO
DROP TABLE IF EXISTS dbo.testenull;
GO
DROP TABLE IF EXISTS testenullchar;
GO
CREATE TABLE testenull (nome VARCHAR(8000) NULL);
GO
CREATE TABLE testenullchar (nome CHAR(8000) NULL);


DECLARE @contador AS INT = 0;
WHILE @contador <= 1000
  BEGIN
    IF @contador % 2 = 0
      BEGIN
        INSERT INTO testenull (nome)
        VALUES ('TDC - SP');
        INSERT INTO testenullchar (nome)
        VALUES ('TDC - SP');
      END;
    SET @contador = @contador + 1;
  END;
GO
SELECT  COUNT(*)
FROM    testenull;
SELECT  COUNT(*)
FROM    testenullchar;
GO

--Resultado
sp_spaceused 'testenullchar';
GO
sp_spaceused 'testenull';



-- Ex2 (Tabela Tempor�ria_
--drop table ##TG

--Cria a tabela tempor�ria
--reiniciar o sql server
DBCC SHRINKDATABASE(N'tempdb');
GO
DROP TABLE IF EXISTS ##TG;
GO
CREATE TABLE ##TG (id        INT NOT NULL IDENTITY(1, 1),
                   nome      CHAR(4000),
                   sobrenome CHAR(4000));
GO

--Verifica o tamanho
USE tempdb;
GO
SELECT  DB_NAME() AS DbName, name AS FileName, size / 128.0 AS CurrentSizeMB,
        size / 128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT) / 128.0 AS FreeSpaceMB,
        ((size / 128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT) / 128.0) * 100) / (size / 128.0) AS 'PercentSpace(%)',
        physical_name
FROM    sys.database_files;

-- Insere registros
INSERT INTO ##TG
VALUES ('TDC', 'SP');
GO 8192
SELECT  *
FROM    ##TG;
GO

-- Novamente verifica o tamanho 
SELECT  DB_NAME() AS DbName, name AS FileName, size / 128.0 AS CurrentSizeMB,
        size / 128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT) / 128.0 AS FreeSpaceMB,
        ((size / 128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT) / 128.0) * 100) / (size / 128.0) AS 'PercentSpace(%)',
        physical_name
FROM    sys.database_files;



-- EX3 - Blobs, XMLs,MAX
USE ExBlob;
GO

-- Ex A
-- Mostrar a estrutura das tabelas
-- trazer todos os dados das tuas tabelas sem a foto crlt+m
SELECT  id, nome, data
FROM    comblob.cliente;

SELECT  id, nome, data
FROM    semblob.cliente;

-- Ex B
-- Trazer a foto dos dois
SELECT  id, nome, data, foto
FROM    comblob.cliente;

SELECT      id, nome data
FROM        semblob.cliente c
INNER JOIN  semblob.foto f
  ON c.id = f.[idcliente];

-- Ex C 
-- Evitar usar o * from tabela 
SELECT  *
FROM    comblob.cliente;

SELECT  *
FROM    semblob.cliente;














