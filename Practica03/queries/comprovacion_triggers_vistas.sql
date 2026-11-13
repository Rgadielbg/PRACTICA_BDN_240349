USE db_test;

-- =========================================================================
-- 1. Comprobar la cantidad total de tablas, triggers, vistas, rutinas y registros
-- =========================================================================
-- Total de tablas en la base de datos
SELECT 'Tablas' AS tipo_objeto, COUNT(*) AS total 
FROM information_schema.tables 
WHERE table_schema = 'db_test' AND table_type = 'BASE TABLE'
UNION ALL
-- Total de vistas
SELECT 'Vistas' AS tipo_objeto, COUNT(*) AS total 
FROM information_schema.views 
WHERE table_schema = 'db_test'
UNION ALL
-- Total de triggers
SELECT 'Triggers' AS tipo_objeto, COUNT(*) AS total 
FROM information_schema.triggers 
WHERE event_object_schema = 'db_test';


-- =========================================================================
-- 2 y 3. Validar distribución de usuarios y proporción de activos e inactivos
-- =========================================================================
SELECT 
    status,
    COUNT(*) AS total_usuarios,
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM tb_users), 2), '%') AS porcentaje
FROM tb_users
GROUP BY status;


-- =========================================================================
-- 4. Comprobar la existencia de los 7,000+ productos
-- =========================================================================
SELECT 
    COUNT(*) AS total_productos_registrados 
FROM tb_products;


-- =========================================================================
-- 5. Identificar categorías o subcategorías que tengan menos de 5 productos
-- =========================================================================
SELECT 
    c.ID AS category_id,
    c.name AS category_name,
    COUNT(pc.product_id) AS total_productos
FROM tb_categories c
LEFT JOIN tbd_products_categories pc ON c.ID = pc.category_id
GROUP BY c.ID, c.name
HAVING COUNT(pc.product_id) < 5;
-- (Si la consulta no devuelve filas, significa que el 100% de las categorías cumplen con tener 5 o más productos).


-- =========================================================================
-- 6. Verificar la existencia de productos descontinuados (status = b'0')
-- =========================================================================
SELECT 
    status,
    COUNT(*) AS total_productos
FROM tb_products
WHERE status = b'0' OR status = 0
GROUP BY status;


-- =========================================================================
-- 7. Consultar las vistas de trazabilidad de operaciones (roles superadmin / seller)
-- =========================================================================
SELECT 
    table_operation,
    db_user,
    operation_date,
    table_description,
    table_name
FROM tb_logs
WHERE db_user LIKE '%seller%' OR db_user LIKE '%root%' OR db_user LIKE '%superadmin%'
ORDER BY operation_date DESC
LIMIT 50;


-- =========================================================================
-- 8. Comprobar la integridad referencial y ausencia de registros huérfanos
-- =========================================================================
-- Validación de productos huérfanos en la tabla intermedia sin coincidencia en tb_products
SELECT 
    'Productos en puente sin producto real' AS tipo_verificacion,
    COUNT(*) AS total_huerfanos
FROM tbd_products_categories pc
LEFT JOIN tb_products p ON pc.product_id = p.ID
WHERE p.ID IS NULL

UNION ALL

-- Validación de categorías huérfanas en la tabla intermedia sin coincidencia en tb_categories
SELECT 
    'Categorías en puente sin categoría real' AS tipo_verificacion,
    COUNT(*) AS total_huerfanos
FROM tbd_products_categories pc
LEFT JOIN tb_categories c ON pc.category_id = c.ID
WHERE c.ID IS NULL;


-- =========================================================================
-- 9. Documentar las vistas de productos por categoría y estado (Evidencia final)
-- =========================================================================
SELECT * 
FROM db_test.vw_total_products_by_category;



-- =========================================================================
ver el desglose completo de cuántos triggers tiene cada tabla de forma individual
-- =========================================================================

SELECT 
    t.TABLE_NAME AS tabla,
    SUM(CASE WHEN tr.ACTION_TIMING = 'AFTER' AND tr.EVENT_MANIPULATION = 'INSERT' THEN 1 ELSE 0 END) AS insert_trg,
    SUM(CASE WHEN tr.ACTION_TIMING = 'AFTER' AND tr.EVENT_MANIPULATION = 'UPDATE' THEN 1 ELSE 0 END) AS update_trg,
    SUM(CASE WHEN tr.ACTION_TIMING = 'AFTER' AND tr.EVENT_MANIPULATION = 'DELETE' THEN 1 ELSE 0 END) AS delete_trg,
    COUNT(tr.TRIGGER_NAME) AS total_por_tabla
FROM 
    information_schema.TABLES t
LEFT JOIN 
    information_schema.TRIGGERS tr 
    ON t.TABLE_SCHEMA = tr.TRIGGER_SCHEMA 
    AND t.TABLE_NAME = tr.EVENT_OBJECT_TABLE
WHERE 
    t.TABLE_SCHEMA = 'db_test' 
    AND t.TABLE_TYPE = 'BASE TABLE'
GROUP BY 
    t.TABLE_NAME
ORDER BY 
    total_por_tabla DESC, t.TABLE_NAME ASC;


    -- =========================================================================
ver QUIEN TIENE TRIGGERS 
-- =========================================================================
SELECT 
    t.TABLE_NAME AS tabla,
    CASE 
        WHEN tr.EVENT_OBJECT_TABLE IS NOT NULL THEN 'CON TRIGGER'
        ELSE 'SIN TRIGGER'
    END AS estado_trigger,
    IFNULL(GROUP_CONCAT(tr.TRIGGER_NAME SEPARATOR ', '), 'Ninguno') AS nombre_triggers
FROM 
    information_schema.TABLES t
LEFT JOIN 
    information_schema.TRIGGERS tr 
    ON t.TABLE_SCHEMA = tr.TRIGGER_SCHEMA 
    AND t.TABLE_NAME = tr.EVENT_OBJECT_TABLE
WHERE 
    t.TABLE_SCHEMA = 'db_test' 
    AND t.TABLE_TYPE = 'BASE TABLE'
GROUP BY 
    t.TABLE_NAME
ORDER BY 
    estado_trigger DESC, t.TABLE_NAME ASC;