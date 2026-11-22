# Práctica 04: Base de datos de comercio electrónico

## Documentación interactiva

| Recurso | Descripción | Enlace |
|---|---|---|
| Diccionario de datos | Búsqueda de tablas y campos, tipos SQL, claves y relaciones. | <a href="diccionario.html" target="_blank" rel="noopener noreferrer">Abrir diccionario</a> |
| Modelo EER web | Vista por dominios de las tablas y las claves foráneas declaradas. | <a href="modelo_eer.html" target="_blank" rel="noopener noreferrer">Abrir modelo EER</a> |

## Descripción

Esta práctica documenta el esquema `db_test` a partir del respaldo más reciente, [`backups/respaldo10.sql`](backups/respaldo10.sql). El modelo organiza usuarios y personas, catálogo de productos y categorías, carritos, órdenes, pagos, direcciones, envíos y registros de auditoría.

El respaldo fue generado con MySQL Server 8.0.45 y contiene definiciones de tablas, relaciones, restricciones, disparadores, vistas y un procedimiento almacenado. Las cifras de esta documentación describen los objetos declarados en ese archivo; no representan una consulta en vivo ni certifican que los objetos estén activos en un servidor.

## Diccionario de datos interactivo

Abre el <a href="diccionario.html" target="_blank" rel="noopener noreferrer">diccionario de datos navideño</a> en un navegador. La página es independiente y responsiva, incluye búsqueda por tabla o campo, filtros por tipo de tabla y muestra las columnas, tipos, nulabilidad, valores predeterminados, claves, relaciones y objetos documentados en el respaldo.

## Objetos documentados

| Objeto | Cantidad | Descripción |
|---|---:|---|
| Tablas | 24 | 23 tablas operativas y `tb_logs`, usada para auditoría. |
| Columnas | 193 | Campos declarados en las tablas del respaldo. |
| Claves foráneas | 19 | Relaciones declaradas entre las tablas. |
| Triggers | 69 | Tres por cada una de las 23 tablas operativas (`AFTER INSERT`, `AFTER UPDATE` y `AFTER DELETE`). `tb_logs` no tiene triggers propios. |
| Vistas | 22 | Vistas de trazabilidad y resumen declaradas en el respaldo. |
| Procedimientos | 1 | `sp_register_new_user`. |

Las entidades siguen principalmente los prefijos `tb_` (tablas principales), `tbd_` (tablas de detalle o asociación) y `tbc_` (catálogos). Por ejemplo, `tbd_products_categories` relaciona productos con categorías.

## Actividades documentadas

- Diseño y organización de entidades para las operaciones de comercio electrónico.
- Definición de claves primarias, claves foráneas, índices y restricciones `CHECK`.
- Uso de tablas de detalle y asociación para representar relaciones entre productos, categorías, carritos, órdenes y usuarios.
- Registro de operaciones mediante triggers que escriben en `tb_logs`.
- Creación de vistas de resumen y trazabilidad.
- Preparación de consultas de verificación para los casos de la práctica.

## Archivos de la práctica

```text
Pactic4/
├── README.md
├── diccionario.html
├── modelo_eer.html
├── backups/
│   ├── respaldo09.sql
│   └── respaldo10.sql
├── queries/
│   ├── casos_practica04_db_test.sql
│   ├── creacion_configuracion_usuarios_remtos.sql
│   └── vw_trazabilidad_casos_adaptado.sql
└── scripts/
    └── remote_users_privileges_creation.sql
```

El diccionario refleja la estructura de `respaldo10.sql`. Si ese respaldo cambia, vuelve a generar o actualizar el diccionario para que sus definiciones permanezcan sincronizadas.

## Modelo EER web

Abre el <a href="modelo_eer.html" target="_blank" rel="noopener noreferrer">modelo EER interactivo</a> en un navegador de escritorio. Presenta las 24 tablas y sus 193 columnas organizadas por dominio, con filtros de vista y las 19 claves foráneas declaradas en `respaldo10.sql`.

El respaldo incluye dos claves foráneas autorreferentes. Se documentan en las notas del modelo y en sus campos, pero no se dibujan como líneas porque el visor EER requiere que cada relación conecte dos tablas distintas. Las relaciones no declaradas en el respaldo no se infieren.
