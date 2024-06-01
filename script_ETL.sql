-- Criação das tabelas para carga de Dados
-- Origem Dados: Kaggle
-- Passos: 
-- 1) Após criação das tabelas para receber dados Kaggle.
-- 2) Importação de Dados do Kaggle - Extração dos Dados
-- 3) Transformação dos Dados
-- 4) Carga dos Dados no DW a partir das tabelas criadas.


----------------------------------------------------
-- Clientes
----------------------------------------------------
CREATE TABLE olist_customers_dataset (
     customer_id                    VARCHAR(100),
	 customer_unique_id             VARCHAR(100),
	 customer_zip_code_prefix       VARCHAR(100),
	 customer_city                  VARCHAR(100),
	 customer_state                 VARCHAR(02));
	 
SELECT * FROM olist_customers_dataset;	 

---------------------------------------------------
-- Pedidos de Venda
---------------------------------------------------
CREATE TABLE olist_orders_dataset
(
    order_id                     VARCHAR(100),
    customer_id                  VARCHAR(100),
    order_status                 VARCHAR(20),
    order_purchase_timestamp     TIMESTAMP,
    order_approved_at            TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

--SELECT * FROM olist_orders_dataset;
SELECT distinct order_status FROM olist_orders_dataset;
SELECT distinct order_purchase_timestamp FROM olist_orders_dataset order by order_purchase_timestamp ;

---------------------------------------------------
-- Itens do Pedido
-- Nota:
-- Um pedido pode ter vários itens.
-- Cada item pode ser entregue por um vendedor distinto.
---------------------------------------------------
CREATE TABLE olist_order_items_dataset(
	order_id                        VARCHAR(100), 
	order_item_id                   INTEGER,
	product_id                      VARCHAR(100),
	seller_id                       VARCHAR(100),
	shipping_limit_date             TIMESTAMP,
	price                           DECIMAL(11,2), 
	freight_value                   DECIMAL(5,2)
); 

SELECT * FROM olist_order_items_dataset;

---------------------------------------------------
-- Produtos
---------------------------------------------------
CREATE TABLE olist_products_dataset(
	product_id				       VARCHAR(100),
	product_category_name          VARCHAR(100),
	product_name_lenght			   SMALLINT,
	product_description_lenght     SMALLINT,
	product_photos_qty             SMALLINT,
	product_weight_g               INTEGER,
	product_length_cm              SMALLINT,
	product_height_cm              SMALLINT,
	product_width_cm               SMALLINT 
);

SELECT * FROM olist_products_dataset;

---------------------------------------------------
-- Categoria do Produto
---------------------------------------------------
CREATE TABLE product_category_name_translation(
	product_category_name          VARCHAR(100),
	product_category_name_english  VARCHAR(100)
);

SELECT count(*) FROM product_category_name_translation;


---------------------------------------------------
-- Pagamentos de Pedidos de Venda
---------------------------------------------------
CREATE TABLE olist_order_payments_dataset (
	order_id                      VARCHAR(100),  -- codigo do pedido de venda 
	payment_sequential            SMALLINT,      -- numero sequencial do tipo de pagamento
	payment_type                  VARCHAR(100),  -- tipo de pagamento
	payment_installments          SMALLINT,      -- Parcela
	payment_value 	              DECIMAL(11,2)  -- valor pago
);

SELECT distinct payment_type FROM olist_order_payments_dataset;

---------------------------------------------------
-- Avaliações dos Pedidos de Venda
---------------------------------------------------
CREATE TABLE olist_order_reviews_dataset (
	review_id                         VARCHAR(100),
	order_id                          VARCHAR(100),
	review_score                      SMALLINT,
	review_comment_title              VARCHAR(100),
	review_comment_message            VARCHAR(500),
	review_creation_date              TIMESTAMP,
	review_answer_timestamp           VARCHAR(200)
);

SELECT * FROM olist_order_reviews_dataset;


---------------------------------------------------
-- Vendedores dos Produtos
---------------------------------------------------
CREATE TABLE olist_sellers_dataset(
	seller_id                     VARCHAR(100),
	seller_zip_code_prefix		  VARCHAR(100),
	seller_city                   VARCHAR(100),
	seller_state                  VARCHAR(02)   
);

SELECT * FROM olist_sellers_dataset;

---------------------------------------------------
-- Geolocalização
---------------------------------------------------
CREATE TABLE olist_geolocation_dataset(
		geolocation_zip_code_prefix VARCHAR(100),
		geolocation_lat             DECIMAL(20,17), 
		geolocation_lng             DECIMAL(20,17),
		geolocation_city            VARCHAR(100),
		geolocation_state           VARCHAR(02) 
);

SELECT * FROM olist_geolocation_dataset;

----------------------------------- 
-- Carregando o DW   
----------------------------------- 

------------------------------------
-- CLIENTE
------------------------------------
INSERT INTO CLIENTE ( 
      SELECT 
         customer_id,                   
	     customer_zip_code_prefix,       
	     customer_city,                  
	     customer_state                 
      FROM 
         olist_customers_dataset	
);

------------------------------------
-- CATEGORIA PRODUTO
------------------------------------
INSERT INTO CATEGORIA_PRODUTO (NOME_CATEGORIA_PRODUTO, NOME_CATEGORIA_PRODUTO_INGLES) 
		  (SELECT  product_category_name,
	    		   product_category_name_english
			FROM product_category_name_translation)
;
------------------------------------
-- PRODUTO
------------------------------------
INSERT INTO PRODUTO (COD_PRODUTO, NOME_PRODUTO_CATEGORIA, QTDE_PRODUTO_FOTOS, PESO_PRODUTO, COMPR_PRODUTO, 
					 ALTURA_PRODUTO, LARGURA_PRODUTO  )
(SELECT 
    product_id				  ,
	product_category_name     ,
	product_photos_qty        ,
	product_weight_g          ,
	product_length_cm         ,
	product_height_cm         ,
	product_width_cm      
 FROM olist_products_dataset)
 
 
------------------------------------
-- FORMA PAGTO
------------------------------------
 INSERT INTO FORMA_PAGAMENTO (DESCR_FORMA_PAGAMENTO)
(SELECT 
     DISTINCT       
 	payment_type  
 FROM olist_order_payments_dataset)
 
 
------------------------------------
-- AVALIACAO PEDIDO VENDA
------------------------------------ 
INSERT INTO AVALIACAO_PEDIDO VALUES (5, 'OTIMO');
INSERT INTO AVALIACAO_PEDIDO VALUES (4, 'BOM');
INSERT INTO AVALIACAO_PEDIDO VALUES (3, 'REGULAR');
INSERT INTO AVALIACAO_PEDIDO VALUES (2, 'RUIM');
INSERT INTO AVALIACAO_PEDIDO VALUES (1, 'PESSIMO');

------------------------------------
-- STATUS PEDIDO
------------------------------------  
INSERT INTO STATUS_PEDIDO VALUES ('CRIADO');
INSERT INTO STATUS_PEDIDO VALUES ('APROVADO');
INSERT INTO STATUS_PEDIDO VALUES ('FATURADO');
INSERT INTO STATUS_PEDIDO VALUES ('ENVIADO');
INSERT INTO STATUS_PEDIDO VALUES ('ENTREGUE');
INSERT INTO STATUS_PEDIDO VALUES ('CANCELADO');
INSERT INTO STATUS_PEDIDO VALUES ('EM PROCESSAMENTO');
INSERT INTO STATUS_PEDIDO VALUES ('INDISPONIVEL');

------------------------------------
-- VENDEDORES
------------------------------------
INSERT INTO VENDEDOR (SELECT * FROM olist_sellers_dataset);

------------------------------------
-- GEOLOCALIZACAO
------------------------------------
INSERT INTO GEOLOCALIZACAO ( SELECT * FROM olist_geolocation_dataset);

------------------------------------
-- BASE VENDAS TOTAL (2016 a 2018)
------------------------------------
INSERT INTO VENDA (
SELECT 
 a.order_id,                                      --COD_PEDIDO                       varchar(100)                   null,
 a.customer_id,                                   --COD_CLIENTE                      varchar(100)                   null,
 c.product_id,                                    --COD_PRODUTO                      varchar(100)                   null,
 c.product_category_name,                         --NOME_CATEGORIA_PRODUTO           varchar(100)                   null,
 d.payment_type,                                  --DESCR_FORMA_PAGAMENTO            smallint                       null,
 e.review_score,                                  --COD_AVALIACAO_PEDIDO             smallint                       null,
 a.order_status,                                  --DESCR_STATUS_PEDIDO              smallint                       null,
 b.seller_id,                                     --COD_VENDEDOR                     varchar(100)                   null,
 f.customer_zip_code_prefix,                      --CEP_GEOLOCALIZACAO               varchar(100)                   null,
 DATE(a.order_purchase_timestamp),                --DATA_VENDA                       date                           null,
 d.payment_sequential,                            --COD_SEQUENCIAL_FORMA_PAGAMENTO   smallint                       null,
 d.payment_value,                                 --VALOR_FORMA_PAGAMENTO            decimal(11,2)                  null,
 d.payment_installments,                          --COD_PARCELA                      smallint                       null,
 b.order_item_id,                                 --COD_ITEM_PEDIDO                  integer                        null,
 a.order_purchase_timestamp,                      --DATA_HORA_COMPRA                 timestamp                      null,
 a.order_approved_at,                             --DATA_HORA_APROVACAO              timestamp                      null,
 a.order_delivered_carrier_date,                  --DATA_HORA_ENTREGA_TRANSPORTADORA timestamp                      null,
 a.order_delivered_customer_date,                 --DATA_HORA_ENTREGA_CLIENTE        timestamp                      null,
 a.order_estimated_delivery_date,                 --DATA_HORA_ESTIMADA_ENTREGA       timestamp                      null,
 b.shipping_limit_date,                           --DATA_HORA_LIMITE_ENVIO           timestamp                      null,
 b.price,                                         --PRECO_PRODUTO                    decimal(11,2)                  null,
 b.freight_value,                                 --FRETE_PRODUTO                    decimal(5,2)                   null,
 null,                                            --TOTAL_PEDIDOS                    decimal(19,0)                  null,
 null,                                            --TAMANHO_PEDIDO                   smallint                       null,
 null,                                            --TICKET_MEDIO                     decimal(11,2)                  null,
 null,                                            --FATURAMENTO_VENDA                decimal(21,2)                  null,
 null,                                            --FATURAMENTO_2016                 decimal(21,2)                  null,
 null                                             --FATURAMENTO_2017                 decimal(21,2)                  null 
FROM
olist_orders_dataset a,
olist_order_items_dataset b,
olist_products_dataset c,
olist_order_payments_dataset d,
olist_order_reviews_dataset e,
olist_customers_dataset f,
olist_sellers_dataset g
WHERE
a.order_id   = b.order_id     AND 
b.product_id = c.product_id   AND
a.order_id   = d.order_id     AND
d.order_id   = e.order_id     AND
b.seller_id  = g.seller_id    AND
a.customer_id = f.customer_id
--ORDER BY a.order_id, b.order_item_id, d.payment_installments, d.payment_sequential
ORDER BY a.order_purchase_timestamp );


--TRATAMENTO DOS DADOS - TRADUZINDO DO STATUS DO PEDIDO
SELECT count(*)
FROM VENDA
WHERE DESCR_STATUS_PEDIDO = 'enviado';  -- 1167

SELECT count(*)
FROM VENDA
WHERE DESCR_STATUS_PEDIDO = 'indisponivel';  -- 7 

SELECT count(*)
FROM VENDA
WHERE DESCR_STATUS_PEDIDO = 'faturado';  -- 370

SELECT count(*)
FROM VENDA
WHERE DESCR_STATUS_PEDIDO = 'aprovado';  -- 3

SELECT count(*)
FROM VENDA
WHERE DESCR_STATUS_PEDIDO = 'em processamento';  -- 370

SELECT count(*)
FROM VENDA
WHERE DESCR_STATUS_PEDIDO = 'entregue';  -- 114859

SELECT count(*)
FROM VENDA
WHERE DESCR_STATUS_PEDIDO = 'cancelado';  -- 553 


UPDATE VENDA SET DESCR_STATUS_PEDIDO = 'enviado' WHERE DESCR_STATUS_PEDIDO = 'shipped';
UPDATE VENDA SET DESCR_STATUS_PEDIDO = 'indisponivel' WHERE DESCR_STATUS_PEDIDO = 'unavailable';
UPDATE VENDA SET DESCR_STATUS_PEDIDO = 'faturado' WHERE DESCR_STATUS_PEDIDO = 'invoiced';
UPDATE VENDA SET DESCR_STATUS_PEDIDO = 'aprovado' WHERE DESCR_STATUS_PEDIDO = 'approved';
UPDATE VENDA SET DESCR_STATUS_PEDIDO = 'em processamento' WHERE DESCR_STATUS_PEDIDO = 'processing';
UPDATE VENDA SET DESCR_STATUS_PEDIDO = 'entregue' WHERE DESCR_STATUS_PEDIDO = 'delivered';
UPDATE VENDA SET DESCR_STATUS_PEDIDO = 'cancelado' WHERE DESCR_STATUS_PEDIDO = 'canceled';

