-- ============================================================================
-- PRACTICA 04 - 5 CASOS DE PRUEBA RESUELTOS EN db_test
-- ============================================================================
-- Base de datos real: db_test  (NO db_test_7b)
-- Ejecutado el 2026-11-21 contra MySQL 8.0, puerto 40349.
--
-- EJECUCION:
--   Bloque 1 (catalogos)  -> usuario root
--   Bloque 2 (caso 1)     -> usuario app_web  (contraseÃ±a web123)
--   Bloque 3 (casos 2-5)  -> usuario root
--   Bloque 4 (vistas)     -> usuario root
--
-- IMPORTANTE: Este script ya fue aplicado a la BD. Si se vuelve a ejecutar,
-- primero elimine las ordenes 1 a 5 y sus dependencias, o cambiara los IDs.
--
-- Las 5 vistas tienen exactamente las columnas y tipos de las capturas:
--   caso varchar(N), fase varchar(11), rol varchar(19),
--   usuario_ejecutor varchar(80), conexion_bd varchar(80),
--   fecha_evento datetime, cantidad bigint unsigned / decimal(32,0),
--   operacion_tabla varchar(101), detalle_evento text, resultado varchar(20)
-- ============================================================================


-- ################################################################
-- BLOQUE: 01_setup.sql
-- ################################################################

USE db_test;

-- Catálogo de tipos de método de pago (estaba vacío)
INSERT INTO tbc_payment_methods_types (code, name, description, status) VALUES
 ('DEBIT_CARD', 'Tarjeta de debito',  'Tarjeta de debito simulada de 16 digitos', b'1'),
 ('CREDIT_CARD','Tarjeta de credito', 'Tarjeta de credito simulada de 16 digitos', b'1'),
 ('SPIN',       'Tarjeta digital Spin','Tarjeta digital Spin simulada de 16 digitos', b'1'),
 ('SPEI',       'Transferencia SPEI', 'Transferencia bancaria SPEI simulada', b'1'),
 ('COUPON',     'Cupon de regalo',    'Cupon de regalo simulado', b'1');

-- Relaciones producto/proveedor (estaba vacia; requerida por las FK de carrito y orden)
INSERT INTO tbd_products_users_providers (user_id, product_id, type_ownership, status) VALUES
 (14,1,'Owner',b'1'),(14,2,'Owner',b'1'),(14,3,'Owner',b'1'),
 (20,17,'Owner',b'1'),(20,19,'Owner',b'1'),(20,21,'Owner',b'1'),
 (20,120,'Owner',b'1'),(20,124,'Owner',b'1'),(20,422,'Owner',b'1'),
 (20,622,'Owner',b'1'),(20,822,'Owner',b'1'),(20,1022,'Owner',b'1');

SELECT 'Tipos de pago:' AS info; SELECT ID,code,name FROM tbc_payment_methods_types;
SELECT 'Relaciones proveedor-producto:' AS info; SELECT COUNT(*) c FROM tbd_products_users_providers;



-- ################################################################
-- BLOQUE: 02_caso1.sql
-- ################################################################

USE db_test;

-- ============================================================================
-- CASO 1: Compra exitosa, sin modificaciones. TODO lo ejecuta AppWeb.
-- Usuario nuevo -> registro + carrito (5 productos) + orden + domicilio
-- + metodo de pago debito + pago unico + transaccion autorizada + entrega.
-- ============================================================================

-- FASE 1: Registro de cuenta y perfil (rol user_not_registered)
INSERT INTO tb_users (email, nick, password, status)
VALUES ('valeria.mc1@utxicotepec.edu.mx', 'valeria_mc1_nueva', 'appweb_hash_valeria_240349', b'1');
SET @uid = LAST_INSERT_ID();

INSERT INTO tb_people (user_ID, given_names, family_names, gender, status)
VALUES (@uid, 'Valeria', 'Munoz Cruz', 'Mujer', b'1');
SET @pid_people = LAST_INSERT_ID();

-- FASE 2: Carrito con 5 productos y cantidades diferentes (rol common)
INSERT INTO tb_carts (user_ID, status) VALUES (@uid, b'1');
SET @cart = LAST_INSERT_ID();

INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity) VALUES
 (@cart,14,1,1),
 (@cart,14,2,2),
 (@cart,14,3,3),
 (@cart,20,19,4),
 (@cart,20,21,5);

-- FASE 3: Orden de compra (rol buyer al pagar)
SET @subtotal = (SELECT SUM(p.current_price * ci.quantity)
                 FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
                 WHERE ci.cart_ID = @cart);

INSERT INTO tb_buyer_orders (seller_ID, subtotal, shipping_cost, fulfillment_status, status)
VALUES (@uid, @subtotal, 150.00, 'Accepted', b'1');
SET @oid = LAST_INSERT_ID();

INSERT INTO tbd_order_items (seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price)
SELECT @oid, ci.product_ID, ci.provider_ID, p.name, ci.quantity, p.current_price
FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
WHERE ci.cart_ID = @cart;

-- Domicilio de envio (hogar)
INSERT INTO tb_user_addresses (user_ID, address_label, recipient_name, recipient_phone,
                               delivery_instructions, is_default, status)
VALUES (@uid, 'Hogar', 'Valeria Munoz', '5551000001', 'Entregar en domicilio particular', 1, b'1');
SET @addr = LAST_INSERT_ID();

-- Metodo de pago: tarjeta de debito simulada de 16 digitos vinculada a su tipo
INSERT INTO tbd_user_payment_methods (user_ID, payment_method_type_ID, provider,
                                      provider_method_ref, label, last_four, is_default, status)
VALUES (@uid, 1, 'VISA', '4111111111111111', 'Debito VISA terminacion 1111', '1111', 1, b'1');
SET @upm = LAST_INSERT_ID();

-- Pago unico y transaccion bancaria autorizada
INSERT INTO tb_payments (order_ID, user_payment_method_ID, amount, status, creation_date, created_by)
VALUES (@oid, @upm, @subtotal + 150.00, b'1', NOW(), 'app_web@localhost');
SET @pay = LAST_INSERT_ID();

INSERT INTO tb_payment_transaction (payment_ID, transaction_ref, amount, status, creation_date, created_by)
VALUES (@pay, 'TXN-DEBIT-C1-0001', @subtotal + 150.00, b'1', NOW(), 'app_web@localhost');
SET @txn = LAST_INSERT_ID();

-- Entrega en casa y orden marcada como atendida/entregada
INSERT INTO tb_shipments (order_ID, address_ID, carrier, tracking_number, status, creation_date, created_by)
VALUES (@oid, @addr, 'Estafeta', 'EST-C1-CASA-0001', b'1', NOW(), 'app_web@localhost');

UPDATE tb_buyer_orders SET fulfillment_status = 'Delivered' WHERE ID = @oid;

SELECT 'CASO 1 creado' AS resultado, @uid AS usuario, @cart AS carrito, @oid AS orden,
       @subtotal AS subtotal, @pay AS pago, @txn AS transaccion;



-- ################################################################
-- BLOQUE: 03_casos2a5.sql
-- ################################################################

USE db_test;

-- ============================================================================
-- CASOS 2 a 5: todo lo ejecuta el usuario root.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- CASO 2: 6 MSI, 6to pago rechazado, reclamacion y reenvio
-- ----------------------------------------------------------------------------
SET @u2 = 20;  -- paquirrin96 (usuario ya registrado)

INSERT INTO tb_carts (user_ID, status) VALUES (@u2, b'1');
SET @cart2 = LAST_INSERT_ID();

INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity) VALUES
 (@cart2,14,1,1),(@cart2,14,2,2),(@cart2,14,3,3),
 (@cart2,20,19,4),(@cart2,20,21,5),(@cart2,20,124,1),
 (@cart2,20,422,2),(@cart2,20,622,3),(@cart2,20,822,4),(@cart2,20,1022,5);

SET @sub2 = (SELECT SUM(p.current_price * ci.quantity)
             FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
             WHERE ci.cart_ID = @cart2);

INSERT INTO tb_buyer_orders (seller_ID, subtotal, shipping_cost, fulfillment_status, status)
VALUES (@u2, @sub2, 180.00, 'Accepted', b'1');
SET @o2 = LAST_INSERT_ID();

INSERT INTO tbd_order_items (seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price)
SELECT @o2, ci.product_ID, ci.provider_ID, p.name, ci.quantity, p.current_price
FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
WHERE ci.cart_ID = @cart2;

INSERT INTO tb_user_addresses (user_ID, address_label, recipient_name, recipient_phone,
                               delivery_instructions, is_default, status)
VALUES (@u2, 'Trabajo', 'Paco Paquirrin', '5552000002', 'Entregar en oficina, recepcion', 0, b'1');
SET @addr2 = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods (user_ID, payment_method_type_ID, provider,
                                      provider_method_ref, label, last_four, is_default, status)
VALUES (@u2, 2, 'MASTERCARD', '5555555555554444', 'Credito Mastercard terminacion 4444', '4444', 1, b'1');
SET @upm2 = LAST_INSERT_ID();

SET @total2 = @sub2 + 180.00;
SET @mensual2 = ROUND(@total2 / 6, 2);

-- 5 mensualidades aprobadas
INSERT INTO tb_payments (order_ID, user_payment_method_ID, amount, status, creation_date, created_by)
VALUES (@o2,@upm2,@mensual2,b'1',DATE_ADD(NOW(), INTERVAL 0 MONTH),'root@localhost');
SET @p2a = LAST_INSERT_ID();
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p2a,'TXN-MSI-C2-01',@mensual2,b'1',NOW(),'root@localhost');

INSERT INTO tb_payments (order_ID, user_payment_method_ID, amount, status, creation_date, created_by)
VALUES (@o2,@upm2,@mensual2,b'1',DATE_ADD(NOW(), INTERVAL 1 MONTH),'root@localhost');
SET @p2b = LAST_INSERT_ID();
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p2b,'TXN-MSI-C2-02',@mensual2,b'1',NOW(),'root@localhost');

INSERT INTO tb_payments (order_ID, user_payment_method_ID, amount, status, creation_date, created_by)
VALUES (@o2,@upm2,@mensual2,b'1',DATE_ADD(NOW(), INTERVAL 2 MONTH),'root@localhost');
SET @p2c = LAST_INSERT_ID();
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p2c,'TXN-MSI-C2-03',@mensual2,b'1',NOW(),'root@localhost');

INSERT INTO tb_payments (order_ID, user_payment_method_ID, amount, status, creation_date, created_by)
VALUES (@o2,@upm2,@mensual2,b'1',DATE_ADD(NOW(), INTERVAL 3 MONTH),'root@localhost');
SET @p2d = LAST_INSERT_ID();
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p2d,'TXN-MSI-C2-04',@mensual2,b'1',NOW(),'root@localhost');

INSERT INTO tb_payments (order_ID, user_payment_method_ID, amount, status, creation_date, created_by)
VALUES (@o2,@upm2,@mensual2,b'1',DATE_ADD(NOW(), INTERVAL 4 MONTH),'root@localhost');
SET @p2e = LAST_INSERT_ID();
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p2e,'TXN-MSI-C2-05',@mensual2,b'1',NOW(),'root@localhost');

-- 6to pago rechazado por limite excedido de credito
INSERT INTO tb_payments (order_ID, user_payment_method_ID, amount, status, creation_date, created_by)
VALUES (@o2,@upm2,@mensual2,b'0',DATE_ADD(NOW(), INTERVAL 5 MONTH),'root@localhost');
SET @p2f = LAST_INSERT_ID();
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p2f,'TXN-MSI-C2-06-LIMITE-EXCEDIDO',@mensual2,b'0',NOW(),'root@localhost');

-- Envio inicial a casa (aunque la direccion registrada fue de trabajo)
INSERT INTO tb_shipments (order_ID,address_ID,carrier,tracking_number,status,creation_date,created_by)
VALUES (@o2,@addr2,'DHL','DHL-C2-ENTREGA-0002',b'1',NOW(),'root@localhost');

UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=@o2;

-- Reclamacion por producto danado y reenvio
INSERT INTO tbd_return_items (return_ID, product_ID, quantity, creation_date, created_by)
VALUES (1, 3, 1, NOW(), 'root@localhost');

INSERT INTO tb_shipments (order_ID,address_ID,carrier,tracking_number,status,creation_date,created_by)
VALUES (@o2,@addr2,'DHL','DHL-REENVIO-C2-0002',b'1',NOW(),'root@localhost');

INSERT INTO tb_logs (table_name,table_operation,db_user,table_description,operation_date,operation_status)
VALUES
 ('tb_shipments','Update','root@localhost',CONCAT('Orden ',@o2,' | Reclamacion registrada: producto ID=3 llegado danado'),NOW(),b'1'),
 ('tb_shipments','Create','root@localhost',CONCAT('Orden ',@o2,' | Reenvio entregado con guia DHL-REENVIO-C2-0002'),NOW(),b'1');

SELECT 'CASO 2 creado' AS resultado, @o2 AS orden, @total2 AS total, @mensual2 AS mensualidad;


-- ----------------------------------------------------------------------------
-- CASO 3: Cancelacion parcial, ajuste y reembolso
-- ----------------------------------------------------------------------------
SET @u3 = 21;  -- SamuelV

INSERT INTO tb_carts (user_ID, status) VALUES (@u3, b'1');
SET @cart3 = LAST_INSERT_ID();

-- 3 productos de la misma categoria (categoria 2 = Smart TV)
INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity) VALUES
 (@cart3,14,2,2),(@cart3,20,17,3),(@cart3,20,124,4);

SET @sub3 = (SELECT SUM(p.current_price * ci.quantity)
             FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
             WHERE ci.cart_ID = @cart3);

INSERT INTO tb_buyer_orders (seller_ID,subtotal,shipping_cost,fulfillment_status,status)
VALUES (@u3,@sub3,200.00,'Accepted',b'1');
SET @o3 = LAST_INSERT_ID();

INSERT INTO tbd_order_items (seller_order_ID,product_ID,provider_ID,product_name,quantity,unit_price)
SELECT @o3,ci.product_ID,ci.provider_ID,p.name,ci.quantity,p.current_price
FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
WHERE ci.cart_ID = @cart3;

INSERT INTO tb_user_addresses (user_ID,address_label,recipient_name,recipient_phone,
                               delivery_instructions,is_default,status)
VALUES (@u3,'Casa Papas','Samuel Vargas','5553000003','Entregar en Casa Papas',1,b'1');
SET @addr3 = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods (user_ID,payment_method_type_ID,provider,
                                      provider_method_ref,label,last_four,is_default,status)
VALUES (@u3,3,'SPIN','3333333333333333','Tarjeta digital Spin terminacion 3333','3333',1,b'1');
SET @upm3 = LAST_INSERT_ID();

INSERT INTO tb_payments (order_ID,user_payment_method_ID,amount,status,creation_date,created_by)
VALUES (@o3,@upm3,@sub3+200.00,b'1',NOW(),'root@localhost');
SET @p3 = LAST_INSERT_ID();
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p3,'TXN-SPIN-C3-PAGO',@sub3+200.00,b'1',NOW(),'root@localhost');

-- Cancelacion de 1 partida (producto 17)
SET @monto_cancel3 = (SELECT subtotal FROM tbd_order_items
                      WHERE seller_order_ID=@o3 AND product_ID=17);
INSERT INTO tb_order_cancellations (order_ID,reason,status,creation_date,created_by)
VALUES (@o3,'Cancelacion parcial: 1 producto del pedido',b'1',NOW(),'root@localhost');
SET @can3 = LAST_INSERT_ID();
INSERT INTO tbd_cancellation_items (cancellation_ID,product_ID,quantity,creation_date,created_by)
VALUES (@can3,17,3,NOW(),'root@localhost');

DELETE FROM tbd_order_items WHERE seller_order_ID=@o3 AND product_ID=17;
UPDATE tb_buyer_orders SET subtotal = @sub3 - @monto_cancel3 WHERE ID=@o3;

-- Reembolso parcial
INSERT INTO tb_refunds (order_ID,reason,amount,status,creation_date,created_by)
VALUES (@o3,'Reembolso por producto cancelado',@monto_cancel3,b'1',NOW(),'root@localhost');

-- Transaccion reversada parcialmente (para la trazabilidad del reembolso)
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p3,'TXN-SPIN-C3-REEMBOLSO',@monto_cancel3,b'0',NOW(),'root@localhost');

-- Envio y entrega en Casa Papas
INSERT INTO tb_shipments (order_ID,address_ID,carrier,tracking_number,status,creation_date,created_by)
VALUES (@o3,@addr3,'Estafeta','EST-C3-CASAPAPAS-0003',b'1',NOW(),'root@localhost');
UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=@o3;

SELECT 'CASO 3 creado' AS resultado, @o3 AS orden, @sub3 AS subtotal_original,
       @monto_cancel3 AS monto_cancelado;


-- ----------------------------------------------------------------------------
-- CASO 4: Mismo proveedor, intento fallido y recoleccion en sucursal
-- ----------------------------------------------------------------------------
SET @u4 = 22;  -- SamuellV

INSERT INTO tb_carts (user_ID, status) VALUES (@u4, b'1');
SET @cart4 = LAST_INSERT_ID();

-- Los 3 productos son del mismo proveedor (user_ID = 14)
INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity) VALUES
 (@cart4,14,1,1),(@cart4,14,2,2),(@cart4,14,3,3);

SET @sub4 = (SELECT SUM(p.current_price * ci.quantity)
             FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
             WHERE ci.cart_ID = @cart4);

INSERT INTO tb_buyer_orders (seller_ID,subtotal,shipping_cost,fulfillment_status,status)
VALUES (@u4,@sub4,120.00,'Accepted',b'1');
SET @o4 = LAST_INSERT_ID();

INSERT INTO tbd_order_items (seller_order_ID,product_ID,provider_ID,product_name,quantity,unit_price)
SELECT @o4,ci.product_ID,ci.provider_ID,p.name,ci.quantity,p.current_price
FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
WHERE ci.cart_ID = @cart4;

INSERT INTO tb_user_addresses (user_ID,address_label,recipient_name,recipient_phone,
                               delivery_instructions,is_default,status)
VALUES (@u4,'Hogar','Samuel Vargas','5554000004','Casa particular',1,b'1');
SET @addr4 = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods (user_ID,payment_method_type_ID,provider,
                                      provider_method_ref,label,last_four,is_default,status)
VALUES (@u4,4,'SPEI','6461801234567890','Transferencia SPEI terminacion 7890','7890',1,b'1');
SET @upm4 = LAST_INSERT_ID();

INSERT INTO tb_payments (order_ID,user_payment_method_ID,amount,status,creation_date,created_by)
VALUES (@o4,@upm4,@sub4+120.00,b'1',NOW(),'root@localhost');
SET @p4 = LAST_INSERT_ID();
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p4,'TXN-SPEI-C4-0004',@sub4+120.00,b'1',NOW(),'root@localhost');

-- Envio inicial con intento fallido
INSERT INTO tb_shipments (order_ID,address_ID,carrier,tracking_number,status,creation_date,created_by)
VALUES (@o4,@addr4,'Estafeta','EST-C4-INTENTO-0004',b'0',NOW(),'root@localhost');

-- Recoleccion en sucursal
INSERT INTO tb_shipments (order_ID,address_ID,carrier,tracking_number,status,creation_date,created_by)
VALUES (@o4,@addr4,'Estafeta','REC-C4-SUCURSAL-0004',b'1',NOW(),'root@localhost');

INSERT INTO tb_logs (table_name,table_operation,db_user,table_description,operation_date,operation_status)
VALUES
 ('tb_shipments','Update','root@localhost',CONCAT('Orden ',@o4,' | Intento de entrega fallido en hogar, sin destinatario'),NOW(),b'1'),
 ('tb_shipments','Update','root@localhost',CONCAT('Orden ',@o4,' | Pedido recogido en sucursal por el cliente'),NOW(),b'1');

UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=@o4;

SELECT 'CASO 4 creado' AS resultado, @o4 AS orden, @sub4 AS subtotal;


-- ----------------------------------------------------------------------------
-- CASO 5: Compra fallida por inventario y reasignacion de cupon
-- ----------------------------------------------------------------------------
SET @u5 = 23;  -- ELLE
SET @u5b = 24; -- usuario al que se reasigna el cupon

INSERT INTO tb_carts (user_ID, status) VALUES (@u5, b'1');
SET @cart5 = LAST_INSERT_ID();

-- Producto 120 tiene solo 2 unidades en stock; se solicitan 5
INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity)
VALUES (@cart5,20,120,5);

SET @sub5 = (SELECT SUM(p.current_price * ci.quantity)
             FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
             WHERE ci.cart_ID = @cart5);

INSERT INTO tb_buyer_orders (seller_ID,subtotal,shipping_cost,fulfillment_status,status)
VALUES (@u5,@sub5,100.00,'Canceled',b'1');
SET @o5 = LAST_INSERT_ID();

INSERT INTO tbd_order_items (seller_order_ID,product_ID,provider_ID,product_name,quantity,unit_price)
SELECT @o5,ci.product_ID,ci.provider_ID,p.name,ci.quantity,p.current_price
FROM tbd_carts_items ci JOIN tb_products p ON p.ID = ci.product_ID
WHERE ci.cart_ID = @cart5;

INSERT INTO tb_user_addresses (user_ID,address_label,recipient_name,recipient_phone,
                               delivery_instructions,is_default,status)
VALUES (@u5,'Hogar','Elle Ramirez','5555000005','Casa particular',1,b'1');

-- Cupon de regalo
INSERT INTO tbd_user_payment_methods (user_ID,payment_method_type_ID,provider,
                                      provider_method_ref,label,last_four,is_default,status)
VALUES (@u5,5,'CUPON','CUPON-2026-00000005','Cupon de regalo 2026',NULL,1,b'1');
SET @upm5 = LAST_INSERT_ID();

-- Pago revertido y cupon reasignado a otro usuario
INSERT INTO tb_payments (order_ID,user_payment_method_ID,amount,status,creation_date,created_by)
VALUES (@o5,@upm5,@sub5+100.00,b'0',NOW(),'root@localhost');
SET @p5 = LAST_INSERT_ID();
INSERT INTO tb_payment_transaction (payment_ID,transaction_ref,amount,status,creation_date,created_by)
VALUES (@p5,'TXN-CUPON-C5-REASIGNADO',@sub5+100.00,b'0',NOW(),'root@localhost');

UPDATE tbd_user_payment_methods SET user_ID=@u5b, status=b'1', last_update=NOW()
WHERE ID=@upm5;

INSERT INTO tb_logs (table_name,table_operation,db_user,table_description,operation_date,operation_status)
VALUES ('tbd_user_payment_methods','Update','root@localhost',
        CONCAT('Orden ',@o5,' | Cupon CUPON-2026-00000005 reasignado al usuario ID=',@u5b),
        NOW(),b'1');

SELECT 'CASO 5 creado' AS resultado, @o5 AS orden, @sub5 AS subtotal,
       (SELECT current_stock FROM tb_products WHERE ID=120) AS stock_disponible;



-- ################################################################
-- BLOQUE: 04_vistas.sql
-- ################################################################

USE db_test;

-- ============================================================================
-- VISTA 1: Compra exitosa, sin modificaciones. Ejecutada por AppWeb.
-- columnas: caso, fase, rol, usuario_ejecutor, conexion_bd, fecha_evento,
--           cantidad, operacion_tabla, detalle_evento, resultado
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_1 AS
SELECT CAST('Caso 1 - Compra exitosa' AS CHAR(23)) AS caso,
       CAST('Registro' AS CHAR(11)) AS fase,
       CAST('user_not_registered' AS CHAR(19)) AS rol,
       CAST('AppWeb' AS CHAR(80)) AS usuario_ejecutor,
       CAST('AppWeb@localhost' AS CHAR(80)) AS conexion_bd,
       u.creation_date AS fecha_evento,
       CAST(NULL AS UNSIGNED) AS cantidad,
       CAST('INSERT en tb_users y tb_people: alta de cuenta y perfil del cliente.' AS CHAR(101)) AS operacion_tabla,
       CAST(CONCAT('Cuenta y persona registradas: ', p.given_names, ' ', COALESCE(p.family_names,''), ' (', u.nick, ')') AS CHAR(1000)) AS detalle_evento,
       CAST('Registro realizado' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
LEFT JOIN tb_people p ON p.user_ID = u.ID
WHERE o.ID = 1

UNION ALL
SELECT CAST('Caso 1 - Compra exitosa' AS CHAR(23)),
       CAST('Carrito' AS CHAR(11)),
       CAST('common' AS CHAR(19)),
       CAST('AppWeb' AS CHAR(80)),
       CAST('AppWeb@localhost' AS CHAR(80)),
       ci.creation_date,
       CAST(ci.quantity AS UNSIGNED),
       CAST('INSERT en tb_carts y tbd_carts_items: carrito con 5 partidas.' AS CHAR(101)),
       CAST(CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name, ') | proveedor_ID=', ci.provider_ID) AS CHAR(1000)),
       CAST('Agregado al carrito' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE o.ID = 1

UNION ALL
SELECT CAST('Caso 1 - Compra exitosa' AS CHAR(23)),
       CAST('Domicilio' AS CHAR(11)),
       CAST('buyer' AS CHAR(19)),
       CAST('AppWeb' AS CHAR(80)),
       CAST('AppWeb@localhost' AS CHAR(80)),
       a.creation_date,
       CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_user_addresses: domicilio de envio registrado.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | direccion_ID=', a.ID, ' | etiqueta=', a.address_label,
              ' | destinatario=', a.recipient_name) AS CHAR(1000)),
       CAST('Domicilio registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_user_addresses a ON a.user_ID = o.seller_ID
WHERE o.ID = 1

UNION ALL
SELECT CAST('Caso 1 - Compra exitosa' AS CHAR(23)),
       CAST('Metodo' AS CHAR(11)),
       CAST('buyer' AS CHAR(19)),
       CAST('AppWeb' AS CHAR(80)),
       CAST('AppWeb@localhost' AS CHAR(80)),
       upm.creation_date,
       CAST(1 AS UNSIGNED),
       CAST('INSERT en tbd_user_payment_methods: tarjeta de debito de 16 digitos.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | metodo_ID=', upm.ID, ' | tipo=', pm.code,
              ' | ', upm.provider, ' ', upm.provider_method_ref, ' | ultimos=', upm.last_four) AS CHAR(1000)),
       CAST('Metodo registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tbd_user_payment_methods upm ON upm.ID = pay.user_payment_method_ID
JOIN tbc_payment_methods_types pm ON pm.ID = upm.payment_method_type_ID
WHERE o.ID = 1

UNION ALL
SELECT CAST('Caso 1 - Compra exitosa' AS CHAR(23)),
       CAST('Compra' AS CHAR(11)),
       CAST('buyer' AS CHAR(19)),
       CAST('AppWeb' AS CHAR(80)),
       CAST('AppWeb@localhost' AS CHAR(80)),
       oi.creation_date,
       CAST(oi.quantity AS UNSIGNED),
       CAST('INSERT en tb_buyer_orders y tbd_order_items: orden, pago y entrega.' AS CHAR(101)),
       CAST(CONCAT('producto_ID=', pr.ID, ' (', pr.name, ') | Orden ', o.ID,
              '; estado: ', o.fulfillment_status, '; pago: ', pm.code,
              ' (', CASE WHEN CAST(pay.status AS UNSIGNED) = 1 THEN 'Aprobado' ELSE 'Rechazado' END, ')') AS CHAR(1000)),
       CAST('Comprado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tbd_user_payment_methods upm ON upm.ID = pay.user_payment_method_ID
JOIN tbc_payment_methods_types pm ON pm.ID = upm.payment_method_type_ID
WHERE o.ID = 1

UNION ALL
SELECT CAST('Caso 1 - Compra exitosa' AS CHAR(23)),
       CAST('Pago' AS CHAR(11)),
       CAST('buyer' AS CHAR(19)),
       CAST('AppWeb' AS CHAR(80)),
       CAST('AppWeb@localhost' AS CHAR(80)),
       tx.creation_date,
       CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_payments y tb_payment_transaction: pago unico autorizado.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | pago_ID=', pay.ID, ' | Monto=$', pay.amount,
              ' | Ref=', tx.transaction_ref, ' | Autorizada: ',
              CASE WHEN CAST(tx.status AS UNSIGNED) = 1 THEN 'Si' ELSE 'No' END) AS CHAR(1000)),
       CAST('Pago aprobado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tb_payment_transaction tx ON tx.payment_ID = pay.ID
WHERE o.ID = 1

UNION ALL
SELECT CAST('Caso 1 - Compra exitosa' AS CHAR(23)),
       CAST('Envio' AS CHAR(11)),
       CAST('buyer' AS CHAR(19)),
       CAST('AppWeb' AS CHAR(80)),
       CAST('AppWeb@localhost' AS CHAR(80)),
       sh.creation_date,
       CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_shipments: guia de entrega a domicilio.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | Guia=', sh.tracking_number, ' | Transportista=', sh.carrier) AS CHAR(1000)),
       CAST('Enviado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_shipments sh ON sh.order_ID = o.ID
WHERE o.ID = 1

UNION ALL
SELECT CAST('Caso 1 - Compra exitosa' AS CHAR(23)),
       CAST('Entrega' AS CHAR(11)),
       CAST('buyer' AS CHAR(19)),
       CAST('AppWeb' AS CHAR(80)),
       CAST('AppWeb@localhost' AS CHAR(80)),
       o.last_update,
       CAST(1 AS UNSIGNED),
       CAST('UPDATE en tb_buyer_orders: orden marcada como entregada.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | estado final=', o.fulfillment_status, ' | producto recibido en casa') AS CHAR(1000)),
       CAST('Entregado' AS CHAR(20))
FROM tb_buyer_orders o
WHERE o.ID = 1;


-- ============================================================================
-- VISTA 2: 6 MSI, 6to pago rechazado, reclamacion y reenvio. Ejecutada por root.
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_2 AS
SELECT CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)) AS caso,
       CAST('Carrito' AS CHAR(11)) AS fase,
       CAST('common' AS CHAR(19)) AS rol,
       CAST('root' AS CHAR(80)) AS usuario_ejecutor,
       CAST('root@localhost' AS CHAR(80)) AS conexion_bd,
       ci.creation_date AS fecha_evento,
       CAST(ci.quantity AS UNSIGNED) AS cantidad,
       CAST('INSERT en tb_carts y tbd_carts_items: carrito con 10 productos.' AS CHAR(101)) AS operacion_tabla,
       CAST(CONCAT('usuario_ID=', u.ID, ' (', u.nick, ') | carrito_ID=', c.ID,
              ' | producto_ID=', pr.ID, ' (', pr.name, ') | proveedor_ID=', ci.provider_ID) AS CHAR(1000)) AS detalle_evento,
       CAST('Agregado al carrito' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE o.ID = 2

UNION ALL
SELECT CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
       CAST('Compra' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       oi.creation_date, CAST(oi.quantity AS UNSIGNED),
       CAST('INSERT en tb_buyer_orders y tbd_order_items: orden con 10 productos.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | producto_ID=', pr.ID, ' (', pr.name,
              ') | cantidad=', oi.quantity, ' | estado=', o.fulfillment_status) AS CHAR(1000)),
       CAST('Orden procesada' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
WHERE o.ID = 2

UNION ALL
SELECT CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
       CAST('Domicilio' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       a.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_user_addresses: direccion de trabajo registrada.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | direccion_ID=', a.ID, ' | etiqueta=', a.address_label,
              ' | destinatario=', a.recipient_name) AS CHAR(1000)),
       CAST('Domicilio registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_user_addresses a ON a.user_ID = o.seller_ID
WHERE o.ID = 2

UNION ALL
SELECT CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
       CAST('Metodo' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       upm.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tbd_user_payment_methods: tarjeta de credito de 16 digitos.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | metodo_ID=', upm.ID, ' | tipo=', pm.code,
              ' | ', upm.provider, ' ', upm.provider_method_ref) AS CHAR(1000)),
       CAST('Metodo registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tbd_user_payment_methods upm ON upm.user_ID = o.seller_ID
JOIN tbc_payment_methods_types pm ON pm.ID = upm.payment_method_type_ID
WHERE o.ID = 2

UNION ALL
SELECT CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
       CAST('Pagos MSI' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       tx.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_payments y tb_payment_transaction: 6 MSI, 5 aprobadas.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | pago_ID=', pay.ID, ' | mensualidad=$', pay.amount,
              ' | Ref=', tx.transaction_ref, ' | estado=',
              CASE WHEN CAST(tx.status AS UNSIGNED) = 1 THEN 'Aprobada' ELSE 'Rechazada: limite excedido de credito' END) AS CHAR(1000)),
       CAST(CASE WHEN CAST(tx.status AS UNSIGNED) = 1 THEN 'Aprobado' ELSE 'Rechazado' END AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tb_payment_transaction tx ON tx.payment_ID = pay.ID
WHERE o.ID = 2

UNION ALL
SELECT CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
       CAST('Envio' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       sh.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_shipments: entrega inicial del pedido.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | Guia=', sh.tracking_number, ' | Transportista=', sh.carrier) AS CHAR(1000)),
       CAST('Enviado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_shipments sh ON sh.order_ID = o.ID AND sh.tracking_number NOT LIKE 'DHL-REENVIO%'
WHERE o.ID = 2

UNION ALL
SELECT CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
       CAST('Reclamo' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       lg.operation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tbd_return_items y tb_logs: producto danado reportado.' AS CHAR(101)),
       CAST(lg.table_description AS CHAR(1000)),
       CAST('Reclamo registrado' AS CHAR(20))
FROM tb_logs lg
WHERE lg.table_description LIKE 'Orden 2 | Reclamacion registrada%'

UNION ALL
SELECT CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
       CAST('Reenvio' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       sh.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_shipments: guia de reenvio en buenas condiciones.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | Guia=', sh.tracking_number, ' | Transportista=', sh.carrier) AS CHAR(1000)),
       CAST('Reenvio entregado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_shipments sh ON sh.order_ID = o.ID AND sh.tracking_number LIKE 'DHL-REENVIO%'
WHERE o.ID = 2;


-- ============================================================================
-- VISTA 3: Cancelacion parcial, ajuste y reembolso. Ejecutada por root.
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_3 AS
SELECT CAST('Caso 3 - Cancelación parcial, reembolso' AS CHAR(39)) AS caso,
       CAST('Carrito' AS CHAR(11)) AS fase,
       CAST('common' AS CHAR(19)) AS rol,
       CAST('root' AS CHAR(80)) AS usuario_ejecutor,
       CAST('root@localhost' AS CHAR(80)) AS conexion_bd,
       ci.creation_date AS fecha_evento,
       CAST(ci.quantity AS DECIMAL(32,0)) AS cantidad,
       CAST('INSERT en tb_carts y tbd_carts_items: 3 productos de la misma categoria.' AS CHAR(101)) AS operacion_tabla,
       CAST(CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name,
              ') | categoria=2 | proveedor_ID=', ci.provider_ID) AS CHAR(1000)) AS detalle_evento,
       CAST('Agregado al carrito' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_carts c ON c.user_ID = o.seller_ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE o.ID = 3

UNION ALL
SELECT CAST('Caso 3 - Cancelación parcial, reembolso' AS CHAR(39)),
       CAST('Domicilio' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       a.creation_date, CAST(1 AS DECIMAL(32,0)),
       CAST('INSERT en tb_user_addresses: direccion Casa Papas registrada.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | etiqueta=', a.address_label, ' | destinatario=', a.recipient_name) AS CHAR(1000)),
       CAST('Domicilio registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_user_addresses a ON a.user_ID = o.seller_ID
WHERE o.ID = 3

UNION ALL
SELECT CAST('Caso 3 - Cancelación parcial, reembolso' AS CHAR(39)),
       CAST('Metodo' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       upm.creation_date, CAST(1 AS DECIMAL(32,0)),
       CAST('INSERT en tbd_user_payment_methods: tarjeta Spin de 16 digitos.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | tipo=', pm.code, ' | ', upm.provider, ' ', upm.provider_method_ref) AS CHAR(1000)),
       CAST('Metodo registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tbd_user_payment_methods upm ON upm.user_ID = o.seller_ID
JOIN tbc_payment_methods_types pm ON pm.ID = upm.payment_method_type_ID
WHERE o.ID = 3

UNION ALL
SELECT CAST('Caso 3 - Cancelación parcial, reembolso' AS CHAR(39)),
       CAST('Orden' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       oi.creation_date, CAST(oi.quantity AS DECIMAL(32,0)),
       CAST('INSERT en tb_buyer_orders y tbd_order_items: orden con 3 productos.' AS CHAR(101)),
       CAST(CONCAT('producto_ID=', pr.ID, ' (', pr.name, ') | Orden ', o.ID,
              ' | subtotal inicial=$', o.subtotal) AS CHAR(1000)),
       CAST('Orden procesada' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
WHERE o.ID = 3

UNION ALL
SELECT CAST('Caso 3 - Cancelación parcial, reembolso' AS CHAR(39)),
       CAST('Pago' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       tx.creation_date, CAST(1 AS DECIMAL(32,0)),
       CAST('INSERT en tb_payments y tb_payment_transaction: pago unico en efectivo.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | pago_ID=', pay.ID, ' | Monto=$', pay.amount,
              ' | Ref=', tx.transaction_ref) AS CHAR(1000)),
       CAST('Pago aprobado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tb_payment_transaction tx ON tx.payment_ID = pay.ID AND tx.status = b'1'
WHERE o.ID = 3

UNION ALL
SELECT CAST('Caso 3 - Cancelación parcial, reembolso' AS CHAR(39)),
       CAST('Ajuste' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       c.creation_date, CAST(ci.quantity AS DECIMAL(32,0)),
       CAST('INSERT en tb_order_cancellations y tbd_cancellation_items: partida cancelada.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | producto_ID=', ci.product_ID,
              ' | cantidad=', ci.quantity, ' | motivo: ', c.reason) AS CHAR(1000)),
       CAST('Cancelada' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_order_cancellations c ON c.order_ID = o.ID
JOIN tbd_cancellation_items ci ON ci.cancellation_ID = c.ID
WHERE o.ID = 3

UNION ALL
SELECT CAST('Caso 3 - Cancelación parcial, reembolso' AS CHAR(39)),
       CAST('Reembolso' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       tx.creation_date, CAST(1 AS DECIMAL(32,0)),
       CAST('INSERT en tb_refunds: reembolso parcial del producto cancelado.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | Reembolso=$', r.amount, ' | Ref=', tx.transaction_ref,
              ' | motivo: ', r.reason) AS CHAR(1000)),
       CAST('Reembolsado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_refunds r ON r.order_ID = o.ID
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tb_payment_transaction tx ON tx.payment_ID = pay.ID AND tx.status = b'0'
WHERE o.ID = 3

UNION ALL
SELECT CAST('Caso 3 - Cancelación parcial, reembolso' AS CHAR(39)),
       CAST('Entrega' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       sh.creation_date, CAST(1 AS DECIMAL(32,0)),
       CAST('INSERT en tb_shipments: despacho y entrega en Casa Papas.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | Guia=', sh.tracking_number,
              ' | estado final=', o.fulfillment_status) AS CHAR(1000)),
       CAST('Entregado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_shipments sh ON sh.order_ID = o.ID
WHERE o.ID = 3;


-- ============================================================================
-- VISTA 4: Mismo proveedor y punto de recoleccion. Ejecutada por root.
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_4 AS
SELECT CAST('Caso 4 - Mismo proveedor y punto de recolección' AS CHAR(47)) AS caso,
       CAST('Carrito' AS CHAR(11)) AS fase, CAST('common' AS CHAR(19)) AS rol,
       CAST('root' AS CHAR(80)) AS usuario_ejecutor, CAST('root@localhost' AS CHAR(80)) AS conexion_bd,
       ci.creation_date AS fecha_evento, CAST(ci.quantity AS UNSIGNED) AS cantidad,
       CAST('INSERT en tb_carts y tbd_carts_items: 3 productos del mismo proveedor.' AS CHAR(101)) AS operacion_tabla,
       CAST(CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name,
              ') | proveedor_ID=', ci.provider_ID) AS CHAR(1000)) AS detalle_evento,
       CAST('Agregado al carrito' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_carts c ON c.user_ID = o.seller_ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE o.ID = 4

UNION ALL
SELECT CAST('Caso 4 - Mismo proveedor y punto de recolección' AS CHAR(47)),
       CAST('Compra' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       oi.creation_date, CAST(oi.quantity AS UNSIGNED),
       CAST('INSERT en tb_buyer_orders y tbd_order_items: orden con pago SPEI.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | producto_ID=', pr.ID, ' | proveedor_ID=', oi.provider_ID,
              ' | pago=', pm.code) AS CHAR(1000)),
       CAST('Orden pagada' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tbd_user_payment_methods upm ON upm.ID = pay.user_payment_method_ID
JOIN tbc_payment_methods_types pm ON pm.ID = upm.payment_method_type_ID
WHERE o.ID = 4

UNION ALL
SELECT CAST('Caso 4 - Mismo proveedor y punto de recolección' AS CHAR(47)),
       CAST('Domicilio' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       a.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_user_addresses: domicilio propio registrado.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | etiqueta=', a.address_label, ' | destinatario=', a.recipient_name) AS CHAR(1000)),
       CAST('Domicilio registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_user_addresses a ON a.user_ID = o.seller_ID
WHERE o.ID = 4

UNION ALL
SELECT CAST('Caso 4 - Mismo proveedor y punto de recolección' AS CHAR(47)),
       CAST('Metodo' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       upm.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tbd_user_payment_methods: transferencia SPEI.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | tipo=', pm.code, ' | ', upm.provider, ' ', upm.provider_method_ref) AS CHAR(1000)),
       CAST('Metodo registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tbd_user_payment_methods upm ON upm.user_ID = o.seller_ID
JOIN tbc_payment_methods_types pm ON pm.ID = upm.payment_method_type_ID
WHERE o.ID = 4

UNION ALL
SELECT CAST('Caso 4 - Mismo proveedor y punto de recolección' AS CHAR(47)),
       CAST('Pago' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       tx.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_payments y tb_payment_transaction: pago SPEI autorizado.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | pago_ID=', pay.ID, ' | Monto=$', pay.amount, ' | Ref=', tx.transaction_ref) AS CHAR(1000)),
       CAST('Pago aprobado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tb_payment_transaction tx ON tx.payment_ID = pay.ID
WHERE o.ID = 4

UNION ALL
SELECT CAST('Caso 4 - Mismo proveedor y punto de recolección' AS CHAR(47)),
       CAST('Envio' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       sh.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_shipments: intento de entrega fallido en hogar.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | Guia=', sh.tracking_number, ' | Transportista=', sh.carrier) AS CHAR(1000)),
       CAST('Sin destinatario' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_shipments sh ON sh.order_ID = o.ID AND sh.tracking_number LIKE 'EST-C4-INTENTO%'
WHERE o.ID = 4

UNION ALL
SELECT CAST('Caso 4 - Mismo proveedor y punto de recolección' AS CHAR(47)),
       CAST('Recoleccion' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       sh.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_shipments y tb_logs: recoleccion en sucursal.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | Guia=', sh.tracking_number, ' | recogido por el cliente') AS CHAR(1000)),
       CAST('Recogido en sucursal' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_shipments sh ON sh.order_ID = o.ID AND sh.tracking_number LIKE 'REC-C4-SUCURSAL%'
WHERE o.ID = 4;


-- ============================================================================
-- VISTA 5: Compra fallida por inventario y reasignacion de cupon. root.
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_5 AS
SELECT CAST('Caso 5 - Compra fallida por inventario y reasignación de cupón' AS CHAR(62)) AS caso,
       CAST('Carrito' AS CHAR(11)) AS fase, CAST('common' AS CHAR(19)) AS rol,
       CAST('root' AS CHAR(80)) AS usuario_ejecutor, CAST('root@localhost' AS CHAR(80)) AS conexion_bd,
       ci.creation_date AS fecha_evento, CAST(ci.quantity AS UNSIGNED) AS cantidad,
       CAST('INSERT en tb_carts y tbd_carts_items: 1 producto con 5 unidades.' AS CHAR(101)) AS operacion_tabla,
       CAST(CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name,
              ') | cantidad=', ci.quantity, ' | stock=', pr.current_stock) AS CHAR(1000)) AS detalle_evento,
       CAST('Agregado al carrito' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_carts c ON c.user_ID = o.seller_ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE o.ID = 5

UNION ALL
SELECT CAST('Caso 5 - Compra fallida por inventario y reasignación de cupón' AS CHAR(62)),
       CAST('Domicilio' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       a.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_user_addresses: domicilio propio registrado.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | etiqueta=', a.address_label, ' | destinatario=', a.recipient_name) AS CHAR(1000)),
       CAST('Domicilio registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_user_addresses a ON a.user_ID = o.seller_ID
WHERE o.ID = 5

UNION ALL
SELECT CAST('Caso 5 - Compra fallida por inventario y reasignación de cupón' AS CHAR(62)),
       CAST('Cancelacion' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       o.creation_date, CAST(oi.quantity AS UNSIGNED),
       CAST('UPDATE en tb_buyer_orders: orden no atendida por falta de inventario.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | producto_ID=', pr.ID, ' | stock=', pr.current_stock,
              ' vs solicitado=', oi.quantity, ' | estado=', o.fulfillment_status) AS CHAR(1000)),
       CAST('Cancelada' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
WHERE o.ID = 5

UNION ALL
SELECT CAST('Caso 5 - Compra fallida por inventario y reasignación de cupón' AS CHAR(62)),
       CAST('Metodo' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       upm.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tbd_user_payment_methods: cupon de regalo.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | tipo=', pm.code, ' | ', upm.provider, ' ', upm.provider_method_ref) AS CHAR(1000)),
       CAST('Metodo registrado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tbd_user_payment_methods upm ON upm.ID = pay.user_payment_method_ID
JOIN tbc_payment_methods_types pm ON pm.ID = upm.payment_method_type_ID
WHERE o.ID = 5

UNION ALL
SELECT CAST('Caso 5 - Compra fallida por inventario y reasignación de cupón' AS CHAR(62)),
       CAST('Cupon' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       tx.creation_date, CAST(1 AS UNSIGNED),
       CAST('INSERT en tb_payments y tb_payment_transaction: cupon revertido.' AS CHAR(101)),
       CAST(CONCAT('Orden ', o.ID, ' | Ref=', tx.transaction_ref, ' | Monto=$', pay.amount,
              ' | estado=', CASE WHEN CAST(tx.status AS UNSIGNED) = 0 THEN 'Reasignado' ELSE 'Aplicado' END) AS CHAR(1000)),
       CAST('Cupon reasignado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments pay ON pay.order_ID = o.ID
JOIN tb_payment_transaction tx ON tx.payment_ID = pay.ID
WHERE o.ID = 5

UNION ALL
SELECT CAST('Caso 5 - Compra fallida por inventario y reasignación de cupón' AS CHAR(62)),
       CAST('Cupon' AS CHAR(11)), CAST('buyer' AS CHAR(19)),
       CAST('root' AS CHAR(80)), CAST('root@localhost' AS CHAR(80)),
       lg.operation_date, CAST(1 AS UNSIGNED),
       CAST('UPDATE en tbd_user_payment_methods: cupon reasignado al cliente.' AS CHAR(101)),
       CAST(lg.table_description AS CHAR(1000)),
       CAST('Cupon reasignado' AS CHAR(20))
FROM tb_logs lg
WHERE lg.table_description LIKE 'Orden 5 | Cupon%';

