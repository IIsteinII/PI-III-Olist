----------------------------------- 
-- Criação do DW 
----------------------------------- 

------------------------------------
-- CLIENTE
------------------------------------
CREATE TABLE CLIENTE 
(
   COD_CLIENTE          varchar(100)                   not null primary key, 
   CEP_CLIENTE          varchar(100)                   null,
   CIDADE_CLIENTE       varchar(100)                   null,
   UF_CLIENTE           varchar(2)                     null
);

------------------------------------
-- CATEGORIA PRODUTO
------------------------------------
CREATE TABLE CATEGORIA_PRODUTO 
(
   NOME_CATEGORIA_PRODUTO varchar(100)                  not null primary key,
   NOME_CATEGORIA_PRODUTO_INGLES varchar(100)           null
    
);

------------------------------------
-- PRODUTO
------------------------------------

CREATE TABLE PRODUTO
(
   COD_PRODUTO         varchar(100)                   not null primary key,
   NOME_PRODUTO_CATEGORIA varchar(100)                   null,
   QTDE_PRODUTO_FOTOS   smallint                       null,
   PESO_PRODUTO         integer                        null,
   COMPR_PRODUTO        smallint                       null,
   ALTURA_PRODUTO       smallint                       null,
   LARGURA_PRODUTO      smallint                       null
);

------------------------------------
-- FORMA PAGTO
------------------------------------
CREATE TABLE FORMA_PAGAMENTO 
(
   DESCR_FORMA_PAGAMENTO varchar(50) NOT NULL
);

 
------------------------------------
-- AVALIACAO PEDIDO VENDA
------------------------------------ 
CREATE TABLE AVALIACAO_PEDIDO 
(
   COD_AVALIACAO_PEDIDO    smallint     not null primary key,
   DESCR_AVALIACAO_PEDIDO  varchar(50)  null
);

------------------------------------
-- STATUS PEDIDO
------------------------------------  
CREATE table STATUS_PEDIDO 
(
   DESCR_STATUS_PEDIDO  varchar(50)  not null primary key
);


------------------------------------
-- VENDEDORES
------------------------------------
CREATE TABLE VENDEDOR  
(
   COD_VENDEDOR         varchar(100)   not null primary key,
   CEP_VENDEDOR         varchar(100)   null,
   CIDADE_VENDEDOR      varchar(100)   null,
   UF_VENDEDOR          char(10)       null
);


------------------------------------
-- GEOLOCALIZACAO
------------------------------------
CREATE TABLE GEOLOCALIZACAO 
(
   CEP_GEOLOCALIZACAO       varchar(100)  not null primary key,
   LATITUDE_GEOLOCALIZACAO  varchar(100)  null,
   LONGITUDE_GEOLOCALIZACAO varchar(100)  null,
   CIDADE_GEOLOCALIZACAO    varchar(100)  null,
   UF_GEOLOCALIZACAO        varchar(2)    null
);

------------------------------------
-- CALENDARIO
------------------------------------
CREATE TABLE CALENDARIO 
(
   DATA  date not null primary key
 );


------------------------------------
-- BASE VENDAS TOTAL (2016 a 2018)
------------------------------------

CREATE TABLE VENDA 
(  COD_PEDIDO                       varchar(100)                   not null primary key, -- Surrugate Key
   COD_CLIENTE                      varchar(100)                   not null, 
   COD_PRODUTO                      varchar(100)                   not null,
   NOME_CATEGORIA_PRODUTO           varchar(100)                   not null,
   DESCR_FORMA_PAGAMENTO            varchar(50)                    not null,
   COD_AVALIACAIO_PEDIDO            smallint                       not null,
   DESCR_STATUS_PEDIDO              varchar(50)                    not null,
   COD_VENDEDOR                     varchar(100)                   not null,
   CEP_GEOLOCALIZACAO               varchar(100)                   not null,
   DATA_VENDA                       date                           not null,
   COD_SEQUENCIAL_FORMA_PAGAMENTO   smallint                       null,
   VALOR_FORMA_PAGAMENTO            decimal(11,2)                  null,
   COD_PARCELA                      smallint                       null,
   COD_ITEM_PEDIDO                  integer                        null,   
   DATA_HORA_COMPRA                 timestamp                      null,
   DATA_HORA_APROVACAO              timestamp                      null,
   DATA_HORA_ENTREGA_TRANSPORTADORA timestamp                      null,
   DATA_HORA_ENTREGA_CLIENTE        timestamp                      null,
   DATA_HORA_ESTIMADA_ENTREGA       timestamp                      null,
   DATA_HORA_LIMITE_ENVIO           timestamp                      null,
   PRECO_PRODUTO                    decimal(11,2)                  null,
   FRETE_PRODUTO                    decimal(5,2)                   null,
   TOTAL_PEDIDOS                    decimal(19,0)                  null,
   TAMANHO_PEDIDO                   smallint                       null,
   TICKET_MEDIO                     decimal(11,2)                  null,
   FATURAMENTO_VENDA                decimal(21,2)                  null,
   FATURAMENTO_2016                 decimal(21,2)                  null,
   FATURAMENTO_2017                 decimal(21,2)                  null
);

