-- ============================================================================
-- TRAZABILIDAD DE CASOS - ADAPTADO A db_test
-- ============================================================================
-- Cambios aplicados respecto al script original:
--   1. USE db_test
--   2. Vistas renombradas a vw_trazabilidad_caso_1 ... vw_trazabilidad_caso_5
--      (las imagenes muestran vw_trazabilidad_caso_1, _2 y _3).
--   3. Tablas/columnas mapeadas al esquema real de db_test:
--        tb_order_payments        -> tb_payments
--        tbd_payment_transactions -> tb_payment_transaction
--        tb_order_shipments       -> tb_shipments
--        tbd_shipment_tracking    -> NO EXISTE; se usa tb_logs (eventos de auditoria)
--      Columnas: op.buyer_order_ID -> op.order_ID, op.total_amount -> op.amount,
--      op.payment_status -> op.status, pt.order_payment_ID -> pt.payment_ID,
--      pt.gateway_reference -> pt.transaction_ref, pt.transaction_status -> pt.status,
--      os.buyer_order_ID -> os.order_ID, os.shipping_status -> os.status.
--   4. Literales ajustados a los tipos que aparecen en las capturas
--      (caso varchar(23/30/39), fase varchar(11), rol varchar(19),
--       usuario_ejecutor/conexion_bd varchar(80), cantidad bigint/decimal,
--       operacion_tabla varchar(101), resultado varchar(20)).
--   5. NOTA: en el caso 1 se conserva el nick 'valeria_mc1_nueva'. Si ese usuario
--      no existe en tu db_test, cambialo por un nick real o por o.ID = 1.
-- ============================================================================

USE db_test;

-- ============================================================================
-- 1. VISTA DEL CASO 1: Compra exitosa
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_1 AS
-- FASE 1: Registro (user_not_registered)
SELECT 
    CAST('Caso 1 - Compra exitosa' AS CHAR(23)) AS caso,
    CAST('Registro' AS CHAR(11)) AS fase,
    CAST('user_not_registered' AS CHAR(19)) AS rol,
    CAST('AppWeb' AS CHAR(80)) AS usuario_ejecutor,
    CAST('AppWeb@localhost' AS CHAR(80)) AS conexion_bd,
    u.creation_date AS fecha_evento,
    CAST(1 AS UNSIGNED) AS cantidad,
    CAST('INSERT en tb_users y tb_people: alta de cuenta y perfil.' AS CHAR(101)) AS operacion_tabla,
    CONCAT('Cuenta y persona registradas: ', p.given_names, ' ', COALESCE(p.family_names, ''), ' (', u.nick, ')') AS detalle_evento,
    CAST('Registro realizado' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
LEFT JOIN tb_people p ON p.user_ID = u.ID
WHERE u.nick = 'valeria_mc1_nueva'

UNION ALL

-- FASE 2: Carrito (common)
SELECT 
    CAST('Caso 1 - Compra exitosa' AS CHAR(23)),
    CAST('Carrito' AS CHAR(11)),
    CAST('common_user' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    ci.creation_date,
    ci.quantity,
    CAST('INSERT en tb_carts y tbd_carts_items: carrito activo y partidas.' AS CHAR(101)),
    CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name, ') | proveedor_ID=', ci.provider_ID),
    CAST('Agregado al carrito' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE u.nick = 'valeria_mc1_nueva'

UNION ALL

-- FASE 3: Compra (buyer)
SELECT 
    CAST('Caso 1 - Compra exitosa' AS CHAR(23)),
    CAST('Compra' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    o.creation_date,
    oi.quantity,
    CAST('INSERT en tb_buyer_orders, tbd_order_items, tb_payments y tb_shipments: orden, pago y entrega.' AS CHAR(101)),
    CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name, ') | Orden ', o.ID,
           '; estado: ', o.fulfillment_status, '; pago: ', pmt.code,
           ' (', CASE WHEN CAST(op.status AS UNSIGNED) = 1 THEN 'Aprobado' ELSE 'Rechazado' END, ')'),
    CAST('Comprado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
JOIN tb_payments op ON op.order_ID = o.ID
JOIN tbd_user_payment_methods upm ON upm.ID = op.user_payment_method_ID
JOIN tbc_payment_methods_types pmt ON pmt.ID = upm.payment_method_type_ID
WHERE u.nick = 'valeria_mc1_nueva';


-- ============================================================================
-- 2. VISTA DEL CASO 2: 6 MSI, 6to pago rechazado, reclamo y reenvio
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_2 AS
-- FASE 1: Carrito (common)
SELECT 
    CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)) AS caso,
    CAST('Carrito' AS CHAR(11)) AS fase,
    CAST('common_user' AS CHAR(19)) AS rol,
    CAST('AppWeb' AS CHAR(80)) AS usuario_ejecutor,
    CAST('AppWeb@localhost' AS CHAR(80)) AS conexion_bd,
    ci.creation_date AS fecha_evento,
    ci.quantity AS cantidad,
    CAST('INSERT en tb_carts y tbd_carts_items: carrito con 10 productos.' AS CHAR(101)) AS operacion_tabla,
    CONCAT('usuario_ID=', u.ID, ' (', u.nick, ') | carrito_ID=', c.ID,
           ' | producto_ID=', pr.ID, ' (', pr.name, ') | proveedor_ID=', ci.provider_ID) AS detalle_evento,
    CAST('Agregado al carrito' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE o.ID = 2

UNION ALL

-- FASE 2A: Compra y orden (buyer)
SELECT 
    CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
    CAST('Compra' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    o.creation_date,
    oi.quantity,
    CAST('INSERT en tb_buyer_orders, tbd_order_items y tb_user_addresses: orden con envio.' AS CHAR(101)),
    CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name, ') | Orden ', o.ID,
           '; estado: ', o.fulfillment_status),
    CAST('Orden procesada' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
WHERE o.ID = 2

UNION ALL

-- FASE 2B: Pagos MSI (buyer - 5 aprobadas y 6ta rechazada)
SELECT 
    CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
    CAST('Pago MSI' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    op.creation_date,
    CAST(1 AS UNSIGNED),
    CAST('INSERT en tb_payments y tb_payment_transaction: mensualidad MSI.' AS CHAR(101)),
    CONCAT('Orden ', o.ID, ' | Pago ID=', op.ID, ' | Monto=$', op.amount,
           ' | Ref=', pt.transaction_ref, ' | Estado: ',
           CASE WHEN CAST(pt.status AS UNSIGNED) = 1 THEN 'Aprobada' ELSE 'Rechazada' END),
    CAST(CASE WHEN CAST(pt.status AS UNSIGNED) = 1 THEN 'Aprobado' ELSE 'Rechazado' END AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments op ON op.order_ID = o.ID
JOIN tb_payment_transaction pt ON pt.payment_ID = op.ID
WHERE o.ID = 2

UNION ALL

-- FASE 2C: Envio inicial, Reclamacion y Reenvio (buyer)
-- tbd_shipment_tracking NO EXISTE en db_test -> se usan los eventos de tb_logs
SELECT 
    CAST('Caso 2 - 6 MSI, pago rechazado' AS CHAR(30)),
    CAST('Envio' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    COALESCE(lg.operation_date, os.creation_date),
    CAST(1 AS UNSIGNED),
    CAST('INSERT en tb_shipments; eventos en tb_logs: entrega, reclamo y reenvio.' AS CHAR(101)),
    CONCAT('Orden ', o.ID, ' | Guia=', os.tracking_number,
           ' (', CASE WHEN CAST(os.status AS UNSIGNED) = 1 THEN 'Activo' ELSE 'Inactivo' END, ') | ',
           COALESCE(lg.table_description, 'Sin eventos de seguimiento')),
    CAST(CASE
        WHEN lg.table_description LIKE '%Reclam%' THEN 'Reclamo registrado'
        WHEN os.tracking_number LIKE 'DHL-REENVIO%' THEN 'Reenvio entregado'
        ELSE 'Envio inicial'
    END AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_shipments os ON os.order_ID = o.ID
LEFT JOIN tb_logs lg ON lg.table_name = 'tb_shipments'
                    AND lg.table_description LIKE CONCAT('%ID=', os.ID, '%')
WHERE o.ID = 2;


-- ============================================================================
-- 3. VISTA DEL CASO 3: Cancelacion parcial, ajuste y reembolso
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_3 AS
-- FASE 1: Carrito (common - 3 productos de la misma categoria)
SELECT 
    CAST('Caso 3 - Cancelacion parcial, reembolso' AS CHAR(39)) AS caso,
    CAST('Carrito' AS CHAR(11)) AS fase,
    CAST('common_user' AS CHAR(19)) AS rol,
    CAST('AppWeb' AS CHAR(80)) AS usuario_ejecutor,
    CAST('AppWeb@localhost' AS CHAR(80)) AS conexion_bd,
    ci.creation_date AS fecha_evento,
    ci.quantity AS cantidad,
    CAST('INSERT en tb_carts y tbd_carts_items: 3 productos de una categoria.' AS CHAR(101)) AS operacion_tabla,
    CONCAT('usuario_ID=', u.ID, ' (', u.nick, ') | carrito_ID=', c.ID,
           ' | producto_ID=', pr.ID, ' (', pr.name, ') | proveedor_ID=', ci.provider_ID) AS detalle_evento,
    CAST('Agregado al carrito' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE o.ID = 3

UNION ALL

-- FASE 2A: Orden ajustada con los 2 productos vigentes (buyer)
SELECT 
    CAST('Caso 3 - Cancelacion parcial, reembolso' AS CHAR(39)),
    CAST('Orden' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    o.creation_date,
    oi.quantity,
    CAST('INSERT/DELETE en tb_buyer_orders y tbd_order_items: partida cancelada y ajuste.' AS CHAR(101)),
    CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name, ') | Orden ', o.ID,
           ' (subtotal ajustado=$', o.subtotal, '); estado: ', o.fulfillment_status),
    CAST('Partida vigente' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
WHERE o.ID = 3

UNION ALL

-- FASE 2B: Pago en efectivo (Spin) y Reembolso parcial (buyer)
SELECT 
    CAST('Caso 3 - Cancelacion parcial, reembolso' AS CHAR(39)),
    CAST('Reembolso' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    pt.creation_date,
    CAST(1 AS DECIMAL(32,0)),
    CAST('INSERT en tb_payments y tb_payment_transaction: pago y reembolso parcial.' AS CHAR(101)),
    CONCAT('Orden ', o.ID, ' | Pago ID=', op.ID, ' | Monto=$', pt.amount,
           ' | Ref=', pt.transaction_ref, ' | Estado: ',
           CASE WHEN CAST(pt.status AS UNSIGNED) = 1 THEN 'Aprobado' ELSE 'Reversado' END),
    CAST(CASE WHEN CAST(pt.status AS UNSIGNED) = 0 THEN 'Reembolsado' ELSE 'Pagado' END AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments op ON op.order_ID = o.ID
JOIN tb_payment_transaction pt ON pt.payment_ID = op.ID
WHERE o.ID = 3

UNION ALL

-- FASE 2C: Envio y entrega (buyer)
SELECT 
    CAST('Caso 3 - Cancelacion parcial, reembolso' AS CHAR(39)),
    CAST('Entrega' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    COALESCE(lg.operation_date, os.creation_date),
    CAST(1 AS DECIMAL(32,0)),
    CAST('INSERT en tb_shipments; eventos en tb_logs: despacho y entrega.' AS CHAR(101)),
    CONCAT('Orden ', o.ID, ' | Guia=', os.tracking_number,
           ' (', CASE WHEN CAST(os.status AS UNSIGNED) = 1 THEN 'Activo' ELSE 'Inactivo' END, ') | ',
           COALESCE(lg.table_description, 'Sin eventos de seguimiento')),
    CAST('Entregado' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_shipments os ON os.order_ID = o.ID
LEFT JOIN tb_logs lg ON lg.table_name = 'tb_shipments'
                    AND lg.table_description LIKE CONCAT('%ID=', os.ID, '%')
WHERE o.ID = 3;


-- ============================================================================
-- 4. VISTA DEL CASO 4: Mismo proveedor y punto de recoleccion
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_4 AS
-- FASE 1: Carrito (common - 3 productos del mismo proveedor)
SELECT 
    CAST('Caso 4 - Mismo proveedor y punto de recoleccion' AS CHAR(47)) AS caso,
    CAST('Carrito' AS CHAR(11)) AS fase,
    CAST('common_user' AS CHAR(19)) AS rol,
    CAST('AppWeb' AS CHAR(80)) AS usuario_ejecutor,
    CAST('AppWeb@localhost' AS CHAR(80)) AS conexion_bd,
    ci.creation_date AS fecha_evento,
    ci.quantity AS cantidad,
    CAST('INSERT en tb_carts y tbd_carts_items: 3 productos del mismo proveedor.' AS CHAR(101)) AS operacion_tabla,
    CONCAT('usuario_ID=', u.ID, ' (', u.nick, ') | carrito_ID=', c.ID,
           ' | producto_ID=', pr.ID, ' (', pr.name, ') | proveedor_ID=', ci.provider_ID) AS detalle_evento,
    CAST('Agregado al carrito' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE o.ID = 4

UNION ALL

-- FASE 2A: Compra y orden (buyer)
SELECT 
    CAST('Caso 4 - Mismo proveedor y punto de recoleccion' AS CHAR(47)),
    CAST('Compra' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    o.creation_date,
    oi.quantity,
    CAST('INSERT en tb_buyer_orders, tbd_order_items y tb_payments: pago SPEI.' AS CHAR(101)),
    CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name, ') | Orden ', o.ID,
           ' (proveedor_ID=', oi.provider_ID, '); pago: ', pmt.code,
           ' (', CASE WHEN CAST(op.status AS UNSIGNED) = 1 THEN 'Aprobado' ELSE 'Rechazado' END, ')'),
    CAST('Orden pagada' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
JOIN tb_payments op ON op.order_ID = o.ID
JOIN tbd_user_payment_methods upm ON upm.ID = op.user_payment_method_ID
JOIN tbc_payment_methods_types pmt ON pmt.ID = upm.payment_method_type_ID
WHERE o.ID = 4

UNION ALL

-- FASE 2B: Envio, intento fallido y recoleccion (buyer)
SELECT 
    CAST('Caso 4 - Mismo proveedor y punto de recoleccion' AS CHAR(47)),
    CAST('Recoleccion' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    COALESCE(lg.operation_date, os.creation_date),
    CAST(1 AS UNSIGNED),
    CAST('INSERT en tb_shipments; eventos en tb_logs: intento fallido y recoleccion.' AS CHAR(101)),
    CONCAT('Orden ', o.ID, ' | Guia=', os.tracking_number,
           ' (', CASE WHEN CAST(os.status AS UNSIGNED) = 1 THEN 'Activo' ELSE 'Inactivo' END, ') | ',
           COALESCE(lg.table_description, 'Sin eventos de seguimiento')),
    CAST(CASE
        WHEN lg.table_description LIKE '%Intento de entrega fallido%' THEN 'Sin destinatario'
        WHEN lg.table_description LIKE '%Pedido recogido%' THEN 'Recogido en sucursal'
        ELSE 'En punto de recoleccion'
    END AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_shipments os ON os.order_ID = o.ID
LEFT JOIN tb_logs lg ON lg.table_name = 'tb_shipments'
                    AND lg.table_description LIKE CONCAT('%ID=', os.ID, '%')
WHERE o.ID = 4;


-- ============================================================================
-- 5. VISTA DEL CASO 5: Compra fallida por inventario y reasignacion de cupon
-- ============================================================================
CREATE OR REPLACE VIEW vw_trazabilidad_caso_5 AS
-- FASE 1: Carrito (common - 1 producto, 5 unidades)
SELECT 
    CAST('Caso 5 - Compra fallida por inventario y reasignacion de cupon' AS CHAR(62)) AS caso,
    CAST('Carrito' AS CHAR(11)) AS fase,
    CAST('common_user' AS CHAR(19)) AS rol,
    CAST('AppWeb' AS CHAR(80)) AS usuario_ejecutor,
    CAST('AppWeb@localhost' AS CHAR(80)) AS conexion_bd,
    ci.creation_date AS fecha_evento,
    ci.quantity AS cantidad,
    CAST('INSERT en tb_carts y tbd_carts_items: 1 producto (5 unidades).' AS CHAR(101)) AS operacion_tabla,
    CONCAT('usuario_ID=', u.ID, ' (', u.nick, ') | carrito_ID=', c.ID,
           ' | producto_ID=', pr.ID, ' (', pr.name, ') | proveedor_ID=', ci.provider_ID) AS detalle_evento,
    CAST('Agregado al carrito' AS CHAR(20)) AS resultado
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_carts_items ci ON ci.cart_ID = c.ID
JOIN tb_products pr ON pr.ID = ci.product_ID
WHERE o.ID = 5

UNION ALL

-- FASE 2A: Orden cancelada por falta de inventario (buyer)
SELECT 
    CAST('Caso 5 - Compra fallida por inventario y reasignacion de cupon' AS CHAR(62)),
    CAST('Cancelacion' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    o.creation_date,
    oi.quantity,
    CAST('UPDATE en tb_buyer_orders y tbd_order_items: orden cancelada por stock.' AS CHAR(101)),
    CONCAT('carrito_ID=', c.ID, ' | producto_ID=', pr.ID, ' (', pr.name,
           ') | stock=', pr.current_stock, ' vs solicitado=', oi.quantity,
           ' | Orden ', o.ID, ' (estado=', o.fulfillment_status, ')'),
    CAST('Cancelada' AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_users u ON u.ID = o.seller_ID
JOIN tb_carts c ON c.user_ID = u.ID
JOIN tbd_order_items oi ON oi.seller_order_ID = o.ID
JOIN tb_products pr ON pr.ID = oi.product_ID
WHERE o.ID = 5

UNION ALL

-- FASE 2B: Cupon aplicado y reasignado (buyer)
SELECT 
    CAST('Caso 5 - Compra fallida por inventario y reasignacion de cupon' AS CHAR(62)),
    CAST('Cupon' AS CHAR(11)),
    CAST('buyer' AS CHAR(19)),
    CAST('AppWeb' AS CHAR(80)),
    CAST('AppWeb@localhost' AS CHAR(80)),
    pt.creation_date,
    CAST(1 AS UNSIGNED),
    CAST('UPDATE en tbd_user_payment_methods y tb_payments: cupon reasignado.' AS CHAR(101)),
    CONCAT('Orden ', o.ID, ' | Metodo=', upm.label, ' (activo=', BIN(upm.status), ') | Monto=$',
           pt.amount, ' | Ref=', pt.transaction_ref, ' | Estado: ',
           CASE WHEN CAST(pt.status AS UNSIGNED) = 1 THEN 'Aplicado' ELSE 'Reversado' END),
    CAST(CASE WHEN CAST(pt.status AS UNSIGNED) = 0 THEN 'Cupon reasignado' ELSE 'Cupon aplicado' END AS CHAR(20))
FROM tb_buyer_orders o
JOIN tb_payments op ON op.order_ID = o.ID
JOIN tbd_user_payment_methods upm ON upm.ID = op.user_payment_method_ID
JOIN tb_payment_transaction pt ON pt.payment_ID = op.ID
WHERE o.ID = 5;


-- ============================================================================
-- CONSULTAS DE VERIFICACION EN ORDEN
-- ============================================================================
SELECT * FROM vw_trazabilidad_caso_1;
SELECT * FROM vw_trazabilidad_caso_2;
SELECT * FROM vw_trazabilidad_caso_3;
SELECT * FROM vw_trazabilidad_caso_4;
SELECT * FROM vw_trazabilidad_caso_5;

-- Opcional: comprobar los tipos de columna de las vistas
-- SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE
-- FROM information_schema.COLUMNS
-- WHERE TABLE_SCHEMA = 'db_test' AND TABLE_NAME LIKE 'vw_trazabilidad_caso_%'
-- ORDER BY TABLE_NAME, ORDINAL_POSITION;
