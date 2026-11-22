# Práctica 04: Base de datos de comercio electrónico

## Documentación interactiva

| Recurso | Descripción | Enlace |
|---|---|---|
| Diccionario de datos | Tablas, atributos, definiciones SQL, identificadores, claves, índices y restricciones. | [Abrir diccionario](diccionario.html) |
| Respaldo de referencia | Fuente SQL utilizada para esta documentación. | [Abrir respaldo10.sql](backups/respaldo10.sql) |

## Descripción

Esta práctica documenta el esquema `db_test` para un proyecto de comercio electrónico. La descripción se elaboró a partir de [`backups/respaldo10.sql`](backups/respaldo10.sql), que declara la estructura relacional, restricciones y objetos de base de datos.

El archivo indica MySQL Server **8.0.45**. La base de datos declara el juego de caracteres `utf8mb4` y la intercalación `utf8mb4_0900_ai_ci`. Las cifras corresponden a objetos declarados en el respaldo; no son una consulta a una instancia activa.

## Objetos documentados

| Objeto | Cantidad | Detalle |
|---|---:|---|
| Tablas | 24 | 193 columnas en total. |
| Claves foráneas | 19 | Relaciones declaradas entre tablas. |
| Índices secundarios | 23 | Incluye 9 índices `UNIQUE`. |
| Restricciones `CHECK` | 8 | Restricciones explícitas en el respaldo. |
| Triggers | 69 | Triggers declarados en el archivo. |
| Vistas | 22 | Vistas declaradas en el archivo. |
| Procedimientos | 1 | `sp_register_new_user`. |

## Organización de tablas

Las categorías conservan la clasificación del diccionario: tablas principales, tablas de detalle o asociación, catálogo y auditoría.

| Categoría | Tablas | Nombres |
|---|---:|---|
| Principal | 13 | `tb_buyer_orders`, `tb_carts`, `tb_categories`, `tb_order_cancellations`, `tb_payment_methods`, `tb_payment_transaction`, `tb_payments`, `tb_people`, `tb_products`, `tb_refunds`, `tb_shipments`, `tb_user_addresses`, `tb_users` |
| Detalle / asociación | 9 | `tbd_address_components`, `tbd_cancellation_items`, `tbd_carts_items`, `tbd_order_items`, `tbd_products_categories`, `tbd_products_users_providers`, `tbd_return_items`, `tbd_user_payment_methods`, `tbd_users_wishlist_products` |
| Catálogo | 1 | `tbc_payment_methods_types` |
| Auditoría | 1 | `tb_logs` |

Los prefijos ayudan a ubicar las familias: `tb_` para entidades principales, `tbd_` para detalles y asociaciones, y `tbc_` para catálogos. La bitácora `tb_logs` registra operaciones de auditoría según la estructura documentada.

## Relaciones principales

La siguiente lista refleja las claves foráneas declaradas en el SQL, con sus columnas locales y referenciadas. No se agregan relaciones inferidas.

| Columna(s) local(es) | Referencia | Restricción y acciones |
|---|---|---|
| `tb_buyer_orders.seller_ID` | `tb_users.ID` | `tb_buyer_orders_ibfk_1` (ON DELETE CASCADE ON UPDATE CASCADE) |
| `tb_carts.user_ID` | `tb_users.ID` | `tb_carts_ibfk_1` (ON DELETE CASCADE ON UPDATE CASCADE) |
| `tb_categories.sup_id_category` | `tb_categories.ID` | `fk_superior_category` |
| `tb_people.user_ID` | `tb_users.ID` | `fk_people_users` |
| `tb_user_addresses.user_ID` | `tb_users.ID` | `fk_addresses_users` (ON DELETE CASCADE ON UPDATE CASCADE) |
| `tbd_address_components.address_ID` | `tb_user_addresses.ID` | `fk_component_address` (ON DELETE RESTRICT) |
| `tbd_address_components.address_ID, address_sup_ID` | `tbd_address_components.address_ID, ID` | `fk_component_parent` (ON DELETE RESTRICT) |
| `tbd_carts_items.cart_ID` | `tb_carts.ID` | `tbd_carts_items_ibfk_1` |
| `tbd_carts_items.provider_ID` | `tbd_products_users_providers.user_id` | `tbd_carts_items_ibfk_2` |
| `tbd_carts_items.product_ID` | `tbd_products_users_providers.product_id` | `tbd_carts_items_ibfk_3` |
| `tbd_order_items.seller_order_ID` | `tb_buyer_orders.ID` | `tbd_order_items_ibfk_1` |
| `tbd_order_items.product_ID` | `tbd_products_users_providers.product_id` | `tbd_order_items_ibfk_2` |
| `tbd_order_items.provider_ID` | `tbd_products_users_providers.user_id` | `tbd_order_items_ibfk_3` |
| `tbd_products_categories.category_id` | `tb_categories.ID` | `fk_category_rel` (ON DELETE CASCADE ON UPDATE CASCADE) |
| `tbd_products_categories.product_id` | `tb_products.ID` | `fk_product_rel` (ON DELETE CASCADE ON UPDATE CASCADE) |
| `tbd_user_payment_methods.user_ID` | `tb_users.ID` | `tbd_user_payment_methods_ibfk_1` (ON DELETE CASCADE ON UPDATE CASCADE) |
| `tbd_user_payment_methods.payment_method_type_ID` | `tbc_payment_methods_types.ID` | `tbd_user_payment_methods_ibfk_2` (ON DELETE CASCADE ON UPDATE CASCADE) |
| `tbd_users_wishlist_products.product_ID` | `tb_products.ID` | `fk_products3` (ON DELETE CASCADE ON UPDATE CASCADE) |
| `tbd_users_wishlist_products.user_ID` | `tb_users.ID` | `fk_user2` (ON DELETE CASCADE ON UPDATE CASCADE) |

Las claves primarias simples y compuestas, los tipos exactos de columna, `NULL`/`NOT NULL`, valores `DEFAULT`, `AUTO_INCREMENT`, `ENUM`, `BIT`, índices `UNIQUE`, demás índices y `CHECK` se detallan en el diccionario interactivo.

## Diccionario de datos

Abre [diccionario.html](diccionario.html) en un navegador. Cada tabla contiene:

- **ID:** identificador consecutivo `DD-###` asignado a la entrada del diccionario; no es un campo de la base de datos.
- **Qué significa:** descripción funcional conservada en la documentación de las tablas.
- **Cómo se compone:** columnas y definiciones SQL, además de la forma simple o compuesta de la clave primaria.
- **Restricciones:** PK, FK con tabla y columnas referenciadas, índices, `UNIQUE`, `CHECK` y definiciones de columnas, donde constan tipo, nulabilidad, valor predeterminado y propiedades como `AUTO_INCREMENT`.

El filtro permite buscar nombres de tablas y campos o ver las tablas por categoría. La página incluye también los nombres de vistas, triggers y procedimientos tomados del respaldo.

## Comparación con la documentación disponible

Se comparó el inventario versionado del diccionario con `respaldo10.sql`: coinciden las **24 tablas**, las **193 columnas** y sus definiciones, así como las **19 claves foráneas** y los **8 `CHECK`**. No se detectaron tablas o campos nuevos, modificados o ausentes en esa comparación. Esta conclusión describe la diferencia entre el SQL indicado y la documentación versionada disponible; no afirma cambios respecto de un respaldo anterior.

En `origin/Practica03`, el `README.md` disponible es el README general de la asignatura. Se tomó como referencia su organización mediante títulos y tablas, adaptándola al contenido técnico de Práctica 04.

## Archivos de Práctica 04

```text
Pactic4/
├── README.md
├── diccionario.html
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

El diccionario y este README se basan en `respaldo10.sql`. Actualízalos cuando cambie esa fuente para mantener sus cifras y definiciones sincronizadas.
