
/*Setup - Palestra DicasPDev
Data da criaçao: 25/09/2020
Desenvolvedor: Rodrigo Crespi
Objetivo: Setup da SQL Sat SP
*/

USE [master];

DECLARE @Origem VARCHAR(120) = 'c:\demo\Backup\AdventureWorks.bak';
DECLARE @OrigemTSQL VARCHAR(120) = 'c:\demo\Backup\TSQL.bak';
DECLARE @OrigemExBlob VARCHAR(120) = 'c:\demo\Backup\Exblog.bak';
DECLARE @OrigemVendas VARCHAR(120) = 'c:\demo\Backup\vendas.bak';

RESTORE DATABASE [AdventureWorks]
FROM DISK = @Origem
WITH FILE = 1, MOVE N'AdventureWorks2012_Data'
               TO N'F:\data\AdventureWorks_Data.mdf', MOVE N'AdventureWorks2012_Log'
                                                         TO N'G:\log\AdventureWorks_log.ldf', NOUNLOAD, REPLACE,
     STATS = 5;

RESTORE DATABASE [TSQL]
FROM DISK = @OrigemTSQL
WITH FILE = 1, MOVE N'TSQL'
               TO N'F:\data\TSQL.mdf', MOVE N'TSQL_log'
                                          TO N'G:\log\TSQL_log.ldf', NOUNLOAD, REPLACE, STATS = 5;


RESTORE DATABASE [ExBlob]
FROM DISK = @OrigemExBlob
WITH FILE = 1, MOVE N'ExBlog'
               TO N'F:\data\ExBlog.mdf', MOVE N'ExBlog_log'
                                            TO N'G:\log\ExBlog_log.ldf', NOUNLOAD, REPLACE, STATS = 5;


RESTORE DATABASE vendas
FROM DISK = @OrigemVendas
WITH FILE = 1, MOVE 'Vendas'
               TO 'F:\data\vendas.mdf', MOVE 'vendas_log'
                                           TO 'G:\log\vendas.ldf', NOUNLOAD, REPLACE, STATS = 5;


GO
--Lab 
USE vendas;
GO
DROP INDEX IF EXISTS [Ix_Venda] ON vendas.[dbo].[venda];
GO
UPDATE  venda
SET     nrano = YEAR(dtvenda)
WHERE   nrano = 9;
GO
ALTER TABLE venda DROP CONSTRAINT PK_Venda;
GO
ALTER TABLE venda ADD CONSTRAINT PK_Venda PRIMARY KEY (cdvenda, nrano);
GO
CHECKPOINT;
DBCC DROPCLEANBUFFERS;
DBCC FREEPROCCACHE;