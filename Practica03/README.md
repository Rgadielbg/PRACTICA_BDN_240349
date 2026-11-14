# Práctica 03: Diseño y documentación de una base de datos E-Commerce

## Enlaces de documentación interactiva

| Recurso | Descripción | Enlace |
|---|---|---|
| 🏠 **Portada principal** | Página de entrada y navegación de la documentación. | [Abrir portada](https://rgadielbg.github.io/PRACTICA_BDN_240349/Docs/) |
| 📖 **Diccionario de datos** | Nuevo diccionario interactivo con tablas, columnas, tipos, llaves, relaciones y métricas. | [Abrir diccionario](https://rgadielbg.github.io/PRACTICA_BDN_240349/diccionario/) |
| 🧩 **Diagrama entidad-relación** | Modelo EER interactivo de la base `db_test`, con entidades, claves y relaciones. | [Abrir diagrama](https://rgadielbg.github.io/PRACTICA_BDN_240349/archify/modelo_eer_respaldo8.html) |

> **Fuentes:** el nuevo diccionario está en `Docs/index.html` y documenta `respaldo7.sql`; la portada y el diagrama EER corresponden a `respaldo8.sql`. Los conteos de filas del EER describen los datos incluidos en ese respaldo, no una consulta en vivo.

> **Si los enlaces muestran 404:** En GitHub, abre **Settings → Pages**, selecciona **GitHub Actions** en **Build and deployment → Source** y guarda. Después inicia el flujo desde **Actions → Publicar documentación en GitHub Pages → Run workflow**.

## 1. Descripción general

Esta práctica desarrolla y documenta una base de datos relacional para un sistema de comercio electrónico. El esquema `db_test` organiza información de usuarios, personas, productos, categorías, carritos, pedidos, pagos, envíos, devoluciones y auditoría.

La documentación técnica del modelo EER se generó a partir de [respaldo8.sql](./backups/respaldo8.sql), un respaldo de MySQL 8.0.36. Las cantidades indicadas a continuación describen las definiciones encontradas en ese archivo; no sustituyen la comprobación de objetos activos ni las pruebas realizadas en un servidor.

## 2. Arquitectura y objetos documentados

| Objeto | Cantidad | Descripción |
|---|---:|---|
| Tablas | 24 | 23 tablas operativas y `tb_logs` para auditoría. |
| Columnas | 193 | Campos descritos en el esquema relacional. |
| Llaves foráneas | 19 | Restricciones declaradas en el respaldo. |
| Triggers | 69 | Tres definiciones (`AFTER INSERT`, `AFTER UPDATE`, `AFTER DELETE`) por cada tabla operativa; `tb_logs` no tiene triggers propios. |
| Vistas | 17 | Nombres únicos de vistas declarados en el respaldo. |
| Filas de `tb_products` | 7,004 | Filas incluidas en `respaldo8.sql`; el ID máximo mostrado en la captura es 7,030. |
| Filas de `tb_users` | 13,049 | Filas incluidas en `respaldo8.sql`; el ID máximo mostrado en la captura es 13,065. |

Las entidades se organizan principalmente con los prefijos `tb_` (tablas principales), `tbd_` (tablas de detalle o asociación) y `tbc_` (catálogos). Las relaciones entre productos y categorías, por ejemplo, se representan en `tbd_products_categories`.

## 3. Actividades y reglas de negocio

- Diseño de entidades para administrar el catálogo, las cuentas de usuario, las compras y sus operaciones relacionadas.
- Uso de tablas de detalle y asociación para representar relaciones entre productos, categorías, carritos y pedidos.
- Declaración de claves primarias, claves foráneas y restricciones de integridad en el esquema.
- Registro de operaciones sobre las tablas funcionales mediante triggers que escriben información en `tb_logs`.
- Elaboración de consultas para revisar objetos de la base de datos y verificar su estructura.

## 4. Auditoría y alcance de la evidencia

El respaldo define 69 triggers distribuidos entre las 23 tablas operativas. La tabla `tb_logs` no tiene triggers propios; de esta manera, sus inserciones de auditoría no generan un ciclo de registros.

El archivo SQL permite verificar qué objetos están declarados en el respaldo. Por sí solo, no demuestra que los triggers estén activos en un servidor restaurado, que no existan registros huérfanos ni que todas las reglas de negocio hayan sido validadas. Para esas conclusiones se requieren resultados de ejecución y pruebas de la base de datos.

## 5. Documentación técnica

- **Portada web:** resumen y acceso a los documentos interactivos de la práctica.
- **Diccionario de datos:** nueva documentación interactiva ubicada en `Docs/index.html`, basada en `respaldo7.sql`.
- **Diagrama entidad-relación:** modelo interactivo elaborado desde `respaldo8.sql`, con las 24 tablas físicas, sus 193 columnas, claves y 19 relaciones declaradas por FK.
- **Informe técnico:** [informe del respaldo 7](./archify/informe_respaldo7.md), con el resumen de objetos y el alcance de la evidencia.

## 6. Estructura del proyecto

```text
Practica03/
├── README.md
├── Docs/
│   └── index.html                 # Nuevo diccionario de datos (respaldo 7)
├── queries/
│   ├── comprovacion_triggers_vistas.sql
│   └── index.html                 # Portada publicada
├── archify/
│   ├── informe_respaldo7.md       # Informe técnico del respaldo 7
│   ├── modelo_eer_respaldo7.html  # Versión anterior del EER
│   └── modelo_eer_respaldo8.html  # EER actualizado desde respaldo8.sql
├── backups/
│   ├── respaldo7.sql              # Respaldo anterior
│   └── respaldo8.sql              # Fuente del EER actualizado
└── seeds/                         # Archivos de datos de ejemplo
```

La publicación se configura mediante [deploy-pages.yml](../.github/workflows/deploy-pages.yml) y se ejecuta al actualizar la rama `Practica03` o manualmente desde la pestaña **Actions** del repositorio.
