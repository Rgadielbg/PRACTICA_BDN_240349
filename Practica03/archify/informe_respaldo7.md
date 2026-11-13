# Informe técnico de base de datos — Respaldo 7

**Proyecto:** Sistema de Gestión y Monitoreo de Base de Datos Multiplataforma  
**Autor:** Ricardo Gadiel Bobadilla Gabriel · Matrícula 240349  
**Institución:** Universidad Tecnológica de Xicotepec de Juárez (UTXJ)  
**Base:** `db_test`  
**Fuente única:** `backups/respaldo7.sql`  
**Versión declarada por el dump:** MySQL 8.0.36 · fecha de exportación 2026-11-12 13:07:38

## 1. Resumen ejecutivo

El respaldo define **24 tablas**: **23 operativas** y `tb_logs`, dedicada a auditoría. Contiene **193 columnas**, **19 restricciones de llave foránea**, **69 definiciones de triggers** y **17 vistas con nombres únicos**. Las tablas usan InnoDB.

Las cifras describen objetos declarados en el archivo SQL. Por sí solas no demuestran que los triggers estén activos en un servidor restaurado ni que las validaciones de datos hayan pasado.

## 2. Arquitectura relacional

El esquema agrupa entidades y transacciones (`tb_*`), detalles y relaciones (`tbd_*`), catálogos (`tbc_*`) y auditoría (`tb_logs`). Las tarjetas del [modelo EER interactivo](modelo_eer_respaldo7.html) muestran todas las tablas, columnas, tipos, PK y FK. El archivo [inventario JSON](procedimientos_respaldo7.json) conserva el detalle estructurado.

La relación entre productos y categorías se representa en `tbd_products_categories` mediante la PK compuesta (`product_id`, `category_id`), en línea con una tabla de asociación. El dump también declara claves compuestas en otras tablas de detalle. Las FKs y acciones `ON DELETE` / `ON UPDATE` se listan en la vista «Relaciones y claves» del HTML.

## 3. Bitácora y trazabilidad

`tb_logs` no tiene triggers propios. El archivo define tres triggers `AFTER` por cada tabla operativa: `INSERT`, `UPDATE` y `DELETE`, para un total de **69 definiciones**. Estos triggers insertan en la bitácora el tipo de operación, `USER()`, `NOW()`, una descripción, el estado de operación y la tabla afectada.

El dump contiene **17 nombres de vistas únicos**. Varias vistas leen `mysql.role_edges` para resolver roles. Por ello, el respaldo no acredita por sí solo una segmentación exclusiva de todas las vistas para `superadmin` y `seller`; su disponibilidad depende del catálogo de roles de MySQL y de la instancia.

## 4. Integridad referencial y reglas de negocio

El DDL declara restricciones de llave foránea y CHECK. Esto acredita que las reglas están definidas en el esquema, pero **no acredita que el conteo de registros huérfanos sea cero**. El respaldo desactiva `FOREIGN_KEY_CHECKS` durante la carga de datos, y no incluye resultados de consultas que documenten el conteo solicitado.

Tampoco se encontró en el respaldo evidencia de una actualización masiva del 10 % de los productos a estado descontinuado, ni resultados de vistas o consultas que validen esa operación. Por tanto, esos resultados no se reportan como cumplidos sin evidencia adicional.

## 5. Matriz de evidencia

| Requisito o afirmación | Evidencia en `respaldo7.sql` | Estado verificable |
|---|---|---|
| 23 tablas operativas y bitácora | 24 sentencias `CREATE TABLE`, incluida `tb_logs` | Confirmado |
| Tres triggers por tabla operativa | 69 definiciones `AFTER INSERT/UPDATE/DELETE` | Definiciones confirmadas; activación no verificada |
| Vistas de trazabilidad | 17 nombres de vista únicos | Confirmado |
| Integridad referencial | Restricciones FK declaradas | Estructura confirmada; huérfanos = 0 no demostrado |
| Descontinuar el 10 % del inventario | No hay evidencia suficiente de ejecución y resultado | No demostrable desde el dump |
| Cumplimiento del 100 % del proyecto | El archivo no incluye matriz de requisitos ni pruebas | No demostrable |

## 6. Conclusión

La documentación describe el esquema, sus relaciones y mecanismos de auditoría tal como están definidos en el respaldo. No es técnicamente válido concluir un conteo de huérfanos igual a cero ni un cumplimiento del 100 % basándose únicamente en este SQL. Esas conclusiones requieren resultados de consultas y pruebas de la instancia, que quedan fuera de la fuente disponible.
