/* TDC - POA 2016
   SQL Sat 570 SP
   Demo 4
   Data de cria��o: 6/10/16
   Dev: Rodrigo
   Objetivo: t-SQL / Planos
*/


/* Importante: 
ANTES DE TESTAR QUALQUER SITUA��O DE PERFORMANCE LIMPAR OS CACHES
SEMPRE UTILIZAR OS PLANOS DE EXECU��O COMO GUIA PARA MEDIR A EVOLU��O DA QUERY
GUARDAR O PLANO DE EXECU��O ORIGINAL PARA TER UMA BASE DE GANHO OU PERDA
*/
USE ExBlob
go
CHECKPOINT;
DBCC FREEPROCCACHE
GO
SET STATISTICS IO ON
SET STATISTICS TIME ON 
go
SELECT id, nome, f.foto, data FROM semblob.cliente c
INNER JOIN semblob.foto f
ON c.id = f.idcliente ORDER BY nome
GO
SET STATISTICS IO Off
SET STATISTICS TIME Off
--


USE [ExBlob]
GO
ALTER TABLE [semblob].[foto] DROP CONSTRAINT [FK_foto_cliente]
GO
ALTER TABLE [semblob].[cliente] DROP CONSTRAINT [PK_cliente]
GO
DROP INDEX [ix_semblobclientenome] ON [semblob].[cliente]
GO
DROP INDEX [ix_semblobcliente] ON [semblob].[cliente]
GO



-- Como eu fa�o
CHECKPOINT;
DBCC FREEPROCCACHE
--crtl + m
SELECT id, nome, f.foto, data FROM semblob.cliente c
INNER JOIN semblob.foto f
ON c.id = f.idcliente ORDER BY nome
--Salvar o plano


CHECKPOINT;
DBCC FREEPROCCACHE
--crtl + m
CREATE CLUSTERED INDEX [ic_semblob] ON [semblob].[cliente]([nome] ASC )
GO
create index ix_smblobnome on semblob.cliente (id) include (nome)


GO
SELECT id, nome, f.foto, data FROM semblob.cliente c
INNER JOIN semblob.foto f
ON c.id = f.idcliente ORDER BY nome
--Salvar e comparar o plano

