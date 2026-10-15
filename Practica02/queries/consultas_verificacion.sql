USE db_test;

/*1. Cuanrtas tablas existen en la base de datis db_test?*/
SHOW TABLES;

/*2. Cuantos triggeers existen enla bvase de datos db_test?*/
SHOW TRIGGERS FROM db_test;

/*3. Cuantos registros existen en la tabla users?*/
SELECT COUNT(*) AS total_registros FROM tb_users;

/*4. Cuantos registros */
SELECT COUNT(*) AS  total_registros FROM  tb_logs;

/*5. Consultar todas las operaciones realizadas en la base de datos*/
SELECT * FROM  tb_logs;

/*6. Verificar que los usuarios remotos hayansido creados*/
SELECT User, Host FROM mysql.user  WHERE Host = '%' AND account_locked = 'N';

/*7. Verificar los roles que fueron creados */
SELECT User, Host FROM mysql.user WHERE Host ='%'   AND account_locked = 'Y';

/*Verificar que usarios tiene  que roles */
SELECT TO_USER AS usuario, TO_HOST AS host, FROM_USER AS rol, FROM_HOST AS rol_host
FROM mysql.role_edges ORDER BY TO_USER, FROM_USERS;



SELECT 
    u.nick,
    u.email,
    b.db_user AS inserted_by,
    b.table_description,
    b.operation_date
FROM tb_users u
JOIN tb_logs b 
    ON b.table_description LIKE CONCAT('%ID=', u.id, ',%')
WHERE b.table_operation = 'Create'
  AND b.table_name = 'tb_users'
GROUP BY 
    u.nick,
    u.email,
    b.db_user,
    b.table_description,
    b.operation_date
ORDER BY b.operation_date ASC;