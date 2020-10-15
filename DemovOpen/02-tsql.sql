/*Demo 2
Data da criaçao: 25/09/2020
Desenvolvedor: Rodrigo Crespi
Objetivo: Demo #2 - SQL Sat SP
*/

-- Ex 1
-- Evitar fun��es no Where da busca
-- Exemplo com data
use TSQL
go
Drop table if exists pedidos
--Criar uma c�pia da tabela e mostrar que n�o tem �ndice.
select orderid, custid, empid, orderdate into pedidos from sales.Orders
GO
select * from sys.indexes where object_id = object_id('pedidos')
GO

--Criar o indice para usar na data
create index ixPedidoData on Pedidos(orderdate) include (orderid)

--Query (crtl + M)
-- n�o utilizar fun��es no WHERE
select orderid from pedidos 
where DATEPART (year, orderdate) = 2006
and DATEPART (month, orderdate) = 8

select orderid from pedidos
where orderdate between '2006/08/01' and '2006/08/31'

--S� para deixar claro o BETWEEN ser mais r�pido que o >= e o <= � mito
select orderid from pedidos
where orderdate >= '2006/08/01' and  orderdate <='2006/08/31'

-- Ex 1a Mais um detalhe. Agora sobre *indices*
select orderid, custid from pedidos where orderdate between '2006/08/01'and '2006/08/31'

select orderid from pedidos
where orderdate between '2006/08/01' and '2006/08/31'

--Por�m
CREATE CLUSTERED INDEX ic_Pedidos_orderid ON dbo.pedidos (orderid ASC)
go

dbcc freeproccache
--Testar novamente com o crtl+M
select orderid, custid from pedidos where orderdate between '2006/08/01'and '2006/08/31'

select orderid from pedidos
where orderdate between '2006/08/01' and '2006/08/31'




-- Ex2 LIKE
use tsql
go
drop table if exists empregados
go
select empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city,
region, postalcode, country, phone, mgrid into Empregados from hr.Employees
GO
select * from sys.indexes where object_id = object_id('empregados')
select * from sys.indexes where object_id = object_id('hr.Employees')
GO
DBCC FREEPROCCACHE
-- Criar Indice
create index ix_empregadolastname on empregados (lastname) include (empid, firstname, title, titleofcourtesy, birthdate, hiredate, address, city,
region, postalcode, country, phone, mgrid)
-- crtl + M (ver CPU index seek e do index scan)
select empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city,
region, postalcode, country, phone, mgrid from empregados where lastname = 'Davis'
select empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city,
region, postalcode, country, phone, mgrid from empregados where lastname like '%avis'
select empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city,
region, postalcode, country, phone, mgrid from empregados where lastname like '_avis'
select empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city,
region, postalcode, country, phone, mgrid from empregados where lastname like 'Davi_'
select empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city,
region, postalcode, country, phone, mgrid from empregados where lastname like 'Davi%'


-- Ex3 Fun��es de Calculo
DBCC FREEPROCCACHE
DROP TABLE if exists detalhepedido
DROP TABLE if exists  detalhepedidocomp
DROP TABLE if exists  detalhepedidocompper

SELECT ORDERid, productid, unitprice, qty, discount 
INTO detalhepedido FROM sales.OrderDetails
SELECT ORDERid, productid, unitprice, qty, discount 
INTO detalhepedidocomp FROM sales.OrderDetails
SELECT ORDERid, productid, unitprice, qty, discount 
INTO detalhepedidocompper FROM sales.OrderDetails

-- Como resolver a computac�o do valor????
SELECT orderid, productid, unitprice, qty, discount, (unitprice * qty) AS total  FROM detalhepedido


--Assim!!!
ALTER TABLE detalhepedidocomp ADD  total AS (qty*unitprice)
ALTER TABLE detalhepedidocompper ADD total AS (qty*unitprice) PERSISTED

SELECT orderid, productid, unitprice, qty, discount, (unitprice * qty) AS total  FROM detalhepedido
SELECT orderid, productid, unitprice, qty, discount, total   FROM detalhepedidocomp
SELECT orderid, productid, unitprice, qty, discount, total FROM detalhepedidocompper

--Mas o persistido piorou? :O

CREATE INDEX ix_total ON detalhepedidocompper (total) INCLUDE (orderid)
DBCC FREEPROCCACHE
GO
SELECT orderid,  (unitprice * qty) AS total  FROM detalhepedido
SELECT orderid, total   FROM detalhepedidocomp
SELECT orderid,  total FROM detalhepedidocompper

-- Mas onde piora? (N�o existe almo�o gr�tis)
INSERT INTO [detalhepedido] ([ORDERid],[productid],[unitprice],[qty],[discount]) VALUES
	(1000, 100, 10, 1, 3)
INSERT INTO [detalhepedidocomp] ([ORDERid],[productid],[unitprice],[qty],[discount]) VALUES
	(1000, 100, 10, 1, 3)
INSERT INTO [detalhepedidocompper] ([ORDERid],[productid],[unitprice],[qty],[discount]) VALUES
	(1000, 100, 10, 1, 3)



-- Ex 4 * from 
-- IMPORTANTE: SE TROCARMOS UMA COLUNA DE LUGAR, OU ADICIONARMOS OUTRA NA TABELA
-- DEVEMOS PESQUISAR EM TODOS OS C�DIGOS DO SISTEMA PROCURANDO ALTERA��ES;
-- OUTRO EXEMPLO � A FALTA DE PADR�O VISTO NO T�PICO DESIGN ;)
USE ExBlob
GO
--CRTL + l
SELECT * FROM semblob.cliente
GO
SELECT ID, NOME, DATA FROM comblob.cliente


-- Ex 5 Order by, or not, order by;
USE TSQL
GO
DBCC FREEPROCCACHE
--CRTL + M
SELECT empid, lastname, firstname, title, city FROM empregados

SELECT empid, lastname, firstname, title, city FROM empregados ORDER by firstname, lastname


-- Mas e o �ndice?
--DROP INDEX [ic_empregado] ON [dbo].[Empregados] WITH ( ONLINE = OFF )
--DROP INDEX ix_empregados2 ON [dbo].[Empregados] WITH ( ONLINE = OFF )
--DROP INDEX ix_empregados ON [dbo].[Empregados] WITH ( ONLINE = OFF )

CREATE INDEX ix_empregados ON empregados (lastname, firstname)

CREATE INDEX ix_empregados2 ON empregados (firstname, lastname)
DBCC FREEPROCCACHE


--CRTL + M
SELECT empid, lastname, firstname, title, city FROM empregados

SELECT empid, lastname, firstname, title, city FROM empregados ORDER by firstname, lastname

-- Da para melhorar?
-- o custo � o mesmo, mas nao estou mais fazendo um rid lookup
CREATE CLUSTERED INDEX ic_empregados ON empregados (empid)
DBCC FREEPROCCACHE


--CRTL + M
SELECT empid, lastname, firstname, title, city FROM empregados

SELECT empid, lastname, firstname, title, city FROM empregados ORDER by firstname, lastname

-- Melhor ainda seria ...
-- Mas algu�m pode fazer isso??? 
DROP INDEX [ic_empregados] ON [dbo].[Empregados] WITH ( ONLINE = OFF )
CREATE CLUSTERED INDEX ic_empregados ON empregados (firstname, lastname )
DBCC FREEPROCCACHE


--CRTL + M
SELECT empid, lastname, firstname, title, city FROM empregados

SELECT empid, lastname, firstname, title, city FROM empregados ORDER by firstname, lastname