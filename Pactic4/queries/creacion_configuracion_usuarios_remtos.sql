USE db_test;

-- ============================================================================
-- 0. CREAR EL PROCEDIMIENTO ALMACENADO NECESARIO
-- ============================================================================
DROP PROCEDURE IF EXISTS db_test.sp_register_new_user;

DELIMITER //
CREATE PROCEDURE db_test.sp_register_new_user()
BEGIN
    -- Aquí irá la lógica de registro de nuevos usuarios
    SELECT 'Procedimiento de registro inicializado';
END //
DELIMITER ;


-- ============================================================================
-- 1. CREACIÓN DE ROLES
-- ============================================================================
CREATE ROLE IF NOT EXISTS 'superadmin', 'admin', 'support', 'seller', 'buyer', 'common_user', 'user_not_registered';


-- ============================================================================
-- 2. CREACIÓN DE USUARIOS REMOTOS (con contraseña '1234')
-- ============================================================================
CREATE USER IF NOT EXISTS 'usr_superadmin'@'%' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'usr_admin'@'%' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'usr_support'@'%' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'usr_seller'@'%' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'usr_buyer'@'%' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'usr_common'@'%' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'usr_guest'@'%' IDENTIFIED BY '1234';


-- ============================================================================
-- 3. PRIVILEGIOS DE LOS ROLES (Tus sentencias originales exactas)
-- ============================================================================

/* SUPERADMIN: Control total del servidor */
GRANT ALL PRIVILEGES ON *.* TO 'superadmin' WITH GRANT OPTION;

/* ADMIN: Control total sobre la base de datos db_test */
GRANT ALL PRIVILEGES ON db_test.* TO 'admin';

/* SUPPORT: Lectura, inserción y actualización en db_test */
GRANT SELECT, INSERT, UPDATE ON db_test.* TO 'support';

/* SELLER: Lectura, inserción, actualización y eliminación en db_test */
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test.* TO 'seller';

/* BUYER: Gestión de carritos, compras y direcciones */
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test.tb_carts TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_buyer_orders TO 'buyer';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_user_addresses TO 'buyer';

/* COMMON_USER: Lectura general y actualización de perfil propio */
GRANT SELECT ON db_test.* TO 'common_user';
GRANT UPDATE ON db_test.tb_users TO 'common_user';

/* NOT REGISTERED (user_not_registered): Tus permisos originales exactos */
GRANT INSERT 
ON db_test.tb_users 
TO 'user_not_registered';

GRANT INSERT 
ON db_test.tb_people 
TO 'user_not_registered';

GRANT EXECUTE 
ON PROCEDURE db_test.sp_register_new_user 
TO 'user_not_registered';


-- ============================================================================
-- 4. ASIGNACIÓN DE ROLES Y CONFIGURACIÓN PREDETERMINADA
-- ============================================================================
GRANT 'superadmin' TO 'usr_superadmin'@'%';
GRANT 'admin' TO 'usr_admin'@'%';
GRANT 'support' TO 'usr_support'@'%';
GRANT 'seller' TO 'usr_seller'@'%';
GRANT 'buyer' TO 'usr_buyer'@'%';
GRANT 'common_user' TO 'usr_common'@'%';
GRANT 'user_not_registered' TO 'usr_guest'@'%';

SET DEFAULT ROLE 'superadmin' FOR 'usr_superadmin'@'%';
SET DEFAULT ROLE 'admin' FOR 'usr_admin'@'%';
SET DEFAULT ROLE 'support' FOR 'usr_support'@'%';
SET DEFAULT ROLE 'seller' FOR 'usr_seller'@'%';
SET DEFAULT ROLE 'buyer' FOR 'usr_buyer'@'%';
SET DEFAULT ROLE 'common_user' FOR 'usr_common'@'%';
SET DEFAULT ROLE 'user_not_registered' FOR 'usr_guest'@'%';

FLUSH PRIVILEGES;

-- ============================================================================
-- 6. SIMULACION MASIVA  DE USUARIOS MEDIANTE SQL 
-- ============================================================================
-- Test 1: Insertar 500 usuarios de género masculino (usando 'Hombre')
CALL sp_simular_usuarios_masivos(500, 'Hombre', 'US', 18, 50, 80);

-- Test 2: Insertar 2,000 usuarios de diferentes países, con edades entre 19 y 35 años
CALL sp_simular_usuarios_masivos(2000, NULL, NULL, 19, 35, 80);


-- 1. Ampliar el tiempo de espera de la sesión a 300 segundos (5 minutos) para evitar el error de conexión perdida
SET SESSION net_read_timeout = 300;
SET SESSION net_write_timeout = 300;

-- 2. Ejecutar los 5,000 usuarios del Test 3 en una sola corrida
CALL sp_simular_usuarios_masivos(5000, NULL, 'MX', 18, 45, 80);


-- Verificar el total de registros acumulados en ambas tablas
SELECT COUNT(*) AS total_usuarios FROM tb_users;
SELECT COUNT(*) AS total_personas FROM tb_people;

-- Comprobar la relación y trazabilidad de los últimos registros
SELECT u.ID, u.email, u.nick, p.given_names, p.family_names, p.gender, p.country_code 
FROM tb_users u 
JOIN tb_people p ON u.ID = p.user_ID 
ORDER BY u.ID DESC 
LIMIT 10;




-- Comprobar la relación y trazabilidad de los últimos registros
SELECT u.ID, u.email, u.nick, p.given_names, p.family_names, p.gender, p.country_code 
FROM tb_users u 
JOIN tb_people p ON u.ID = p.user_ID 
ORDER BY u.ID DESC 
LIMIT 10;
