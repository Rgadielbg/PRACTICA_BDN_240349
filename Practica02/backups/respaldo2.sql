-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: db_test
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `consulta_verificacion`
--

DROP TABLE IF EXISTS `consulta_verificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consulta_verificacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nick` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `inserted_by` varchar(100) NOT NULL,
  `roles` varchar(50) DEFAULT NULL,
  `operation_description` text NOT NULL,
  `operation_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consulta_verificacion`
--

LOCK TABLES `consulta_verificacion` WRITE;
/*!40000 ALTER TABLE `consulta_verificacion` DISABLE KEYS */;
INSERT INTO `consulta_verificacion` VALUES (1,'marco','marco.ramirez@ubicotepec.edu.mx','root@localhost',NULL,'Usuario creado. ID=3, email=marco.ramirez@ubicotepec.edu.mx','2026-09-10 09:58:11'),(2,'vanessa','240270@ubicotepec.edu.mx','vanessa.vergara@PC-02',NULL,'Usuario creado. ID=6, email=240270@ubicotepec.edu.mx','2026-09-10 11:26:03'),(3,'samuel','samuel.vargas@DESKTOP-ACMH89I','samuel.vargas@DESKTOP-ACMH89I','support','Usuario creado. ID=10, email=samuel.vargas@DESKTOP-ACMH89I','2026-09-17 10:44:39');
/*!40000 ALTER TABLE `consulta_verificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_logs`
--

DROP TABLE IF EXISTS `tb_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(80) NOT NULL,
  `table_operation` enum('Create','Read','Update','Delete') DEFAULT NULL,
  `db_user` varchar(80) NOT NULL,
  `table_description` text NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (2,'tb_users','Create','root@localhost','Usuario creado. ID=13, email=240349@utxicotepec.edu.mx, nick=GAD, creation_date=2026-09-10 10:49:37, status=\0','2026-09-10 10:49:37',_binary '\0'),(3,'tb_users','Create','root@localhost','Usuario creado ID=13, email=240349@utxicotepec.edu.mx, nick=GAD, creation_date=2026-09-10 10:49:37, status=\0','2026-09-10 10:49:37',_binary '\0'),(4,'tb_users','Create','root@localhost','Usuario creado. ID=14, email=240556@utxicotepec.edu.mx, nick=JEN, creation_date=2026-09-10 10:50:34, status=\0','2026-09-10 10:50:34',_binary '\0'),(5,'tb_users','Create','root@localhost','Usuario creado ID=14, email=240556@utxicotepec.edu.mx, nick=JEN, creation_date=2026-09-10 10:50:34, status=\0','2026-09-10 10:50:34',_binary '\0'),(6,'tb_users','Create','root@localhost','Usuario creado. ID=15, email=240234@utxicotepec.edu.mx, nick=JEY, creation_date=2026-09-10 10:51:03, status=\0','2026-09-10 10:51:03',_binary '\0'),(7,'tb_users','Create','root@localhost','Usuario creado ID=15, email=240234@utxicotepec.edu.mx, nick=JEY, creation_date=2026-09-10 10:51:03, status=\0','2026-09-10 10:51:03',_binary '\0'),(8,'tb_users','Create','jenny.CM@PC-18','Usuario creado. ID=16, email=240080@utxicotepec.edu.mx, nick=JEIG, creation_date=2026-09-10 11:27:34, status=\0','2026-09-10 11:27:34',_binary '\0'),(9,'tb_users','Create','jenny.CM@PC-18','Usuario creado ID=16, email=240080@utxicotepec.edu.mx, nick=JEIG, creation_date=2026-09-10 11:27:34, status=\0','2026-09-10 11:27:34',_binary '\0'),(10,'tb_users','Create','jenny.CM@PC-18','Usuario creado. ID=17, email=240603@utxicotepec.edu.mx, nick=JILC, creation_date=2026-09-10 11:32:02, status=\0','2026-09-10 11:32:02',_binary '\0'),(11,'tb_users','Create','jenny.CM@PC-18','Usuario creado ID=17, email=240603@utxicotepec.edu.mx, nick=JILC, creation_date=2026-09-10 11:32:02, status=\0','2026-09-10 11:32:02',_binary '\0'),(12,'tb_users','Create','jenny.CM@PC-18','Usuario creado. ID=18, email=240765@utxicotepec.edu.mx, nick=DGS, creation_date=2026-09-10 11:32:21, status=\0','2026-09-10 11:32:21',_binary '\0'),(13,'tb_users','Create','jenny.CM@PC-18','Usuario creado ID=18, email=240765@utxicotepec.edu.mx, nick=DGS, creation_date=2026-09-10 11:32:21, status=\0','2026-09-10 11:32:21',_binary '\0'),(14,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=4, SKU=JEN-001, name=Smartwatch Garmin Forerunner, current_price=4200.00, current_stock=15, status=1','2026-09-24 11:28:11',_binary ''),(15,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=5, SKU=JEN-002, name=Micrófono Condensador Blue Yeti, current_price=2300.00, current_stock=10, status=1','2026-09-24 11:28:11',_binary ''),(16,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=6, SKU=JEN-003, name=Memoria RAM DDR4 16GB, current_price=1100.00, current_stock=30, status=1','2026-09-24 11:28:11',_binary ''),(17,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=7, SKU=JEN-004, name=Disco SSD NVMe 1TB, current_price=2150.00, current_stock=20, status=1','2026-09-24 11:28:11',_binary ''),(18,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=8, SKU=JEN-005, name=Cargador Carga Rápida 65W, current_price=550.00, current_stock=45, status=1','2026-09-24 11:28:11',_binary ''),(19,'tb_products','Update','jenny.canales@PC-16','Producto actualizado. ID=6, SKU=JEN-003, name=Memoria RAM DDR4 16GB, precio_anterior=1100.00, precio_nuevo=999.00, stock_anterior=30, stock_nuevo=35, status=1','2026-09-24 11:28:36',_binary ''),(20,'tb_products','Delete','jenny.canales@PC-16','Producto eliminado. ID=8, SKU=JEN-005, name=Cargador Carga Rápida 65W','2026-09-24 11:28:54',_binary ''),(21,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=14, SKU=JEN-011, name=Teclado Mecánico Inalámbrico, current_price=1850.00, current_stock=15, status=1','2026-09-24 11:36:51',_binary ''),(22,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=15, SKU=JEN-012, name=Monitor Gamer 27 Pulgadas, current_price=4900.00, current_stock=8, status=1','2026-09-24 11:36:51',_binary ''),(23,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=16, SKU=JEN-013, name=Soporte de Aluminio Laptop, current_price=450.00, current_stock=25, status=1','2026-09-24 11:36:51',_binary ''),(24,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=17, SKU=JEN-014, name=Cámara Web 4K Ultra HD, current_price=2100.00, current_stock=10, status=1','2026-09-24 11:36:51',_binary ''),(25,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=18, SKU=JEN-015, name=Disco Duro Externo 1TB, current_price=1150.00, current_stock=30, status=1','2026-09-24 11:36:51',_binary ''),(26,'tb_products','Create','root@localhost','Producto creado. ID=19, SKU=GAD-001, name=Mouse Pad Ergonómico, current_price=180.00, current_stock=25, status=ACTIVE','2026-09-24 11:38:20',_binary ''),(27,'tb_products','Create','root@localhost','Producto creado. ID=20, SKU=GAD-002, name=Lámpara LED de Escritorio, current_price=420.00, current_stock=15, status=ACTIVE','2026-09-24 11:38:20',_binary ''),(28,'tb_products','Create','root@localhost','Producto creado. ID=21, SKU=GAD-003, name=Soporte para Laptop Ventilado, current_price=350.00, current_stock=18, status=ACTIVE','2026-09-24 11:38:20',_binary ''),(29,'tb_products','Create','root@localhost','Producto creado. ID=22, SKU=GAD-004, name=Organizador de Cables, current_price=120.00, current_stock=40, status=ACTIVE','2026-09-24 11:38:20',_binary ''),(30,'tb_products','Create','root@localhost','Producto creado. ID=23, SKU=GAD-005, name=Cargador USB Múltiple, current_price=550.00, current_stock=12, status=ACTIVE','2026-09-24 11:38:20',_binary ''),(31,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=24, SKU=JENNY-301, name=Barra de Sonido TV, current_price=1650.00, current_stock=12, status=1','2026-09-24 12:03:56',_binary ''),(32,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=25, SKU=JENNY-302, name=Soporte Monitor Doble, current_price=1120.00, current_stock=15, status=1','2026-09-24 12:03:56',_binary ''),(33,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=26, SKU=JENNY-303, name=Mochila Antirrobo Laptop, current_price=650.00, current_stock=40, status=1','2026-09-24 12:03:56',_binary ''),(34,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=27, SKU=JENNY-304, name=Luz de Anillo LED 10\", current_price=380.00, current_stock=25, status=1','2026-09-24 12:03:56',_binary ''),(35,'tb_products','Create','jenny.canales@PC-16','Producto creado. ID=28, SKU=JENNY-305, name=Pad Mouse Extra Grande, current_price=290.00, current_stock=50, status=1','2026-09-24 12:03:56',_binary ''),(36,'tb_products','Create','root@localhost','Producto creado. ID=29, SKU=PROD-019, name=Base Refrigerante para Laptop, current_price=320.00, current_stock=22, status=ACTIVE','2026-09-24 12:15:09',_binary ''),(37,'tb_products','Create','root@localhost','Producto creado. ID=30, SKU=PROD-020, name=Kit de Limpieza para Pantallas, current_price=95.00, current_stock=50, status=ACTIVE','2026-09-24 12:15:09',_binary ''),(38,'tb_products','Create','root@localhost','Producto creado. ID=31, SKU=PROD-021, name=Adaptador Bluetooth USB 5.0, current_price=140.00, current_stock=30, status=ACTIVE','2026-09-24 12:15:09',_binary '');
/*!40000 ALTER TABLE `tb_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_products`
--

DROP TABLE IF EXISTS `tb_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_products` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `current_price` decimal(10,2) NOT NULL,
  `current_stock` int NOT NULL,
  `status` varchar(20) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` VALUES (1,'PROD-001','Smart TV 55\" 4K','Televisor LED UHD, HDR10, con funciones de Smart TV',450.00,15,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03'),(2,'PROD-002','Smart TV 32\" HD','Televisor LED HD Ready, puertos HDMI y USB',180.00,30,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03'),(3,'PROD-003','Smart TV 65\" OLED','Televisor 4K UHD, panel OLED, 120Hz para gaming',1200.00,8,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03'),(4,'JEN-001','Smartwatch Garmin Forerunner','Reloj deportivo con GPS y pulso',4200.00,15,'1','2026-09-24 11:28:11',NULL),(5,'JEN-002','Micrófono Condensador Blue Yeti','Conexión USB ideal para streaming',2300.00,10,'1','2026-09-24 11:28:11',NULL),(6,'JEN-003','Memoria RAM DDR4 16GB','Kingston Fury 3200MHz RGB',999.00,35,'1','2026-09-24 11:28:11',NULL),(7,'JEN-004','Disco SSD NVMe 1TB','Samsung 980 Pro PCIe 4.0',2150.00,20,'1','2026-09-24 11:28:11',NULL),(14,'JEN-011','Teclado Mecánico Inalámbrico','Switches Red silenciosos con Bluetooth',1850.00,15,'1','2026-09-24 11:36:51',NULL),(15,'JEN-012','Monitor Gamer 27 Pulgadas','165Hz IPS 1ms QHD',4900.00,8,'1','2026-09-24 11:36:51',NULL),(16,'JEN-013','Soporte de Aluminio Laptop','Plegable con ajuste de altura',450.00,25,'1','2026-09-24 11:36:51',NULL),(17,'JEN-014','Cámara Web 4K Ultra HD','Enfoque automático y micrófono dual',2100.00,10,'1','2026-09-24 11:36:51',NULL),(18,'JEN-015','Disco Duro Externo 1TB','USB 3.2 resistente a caídas',1150.00,30,'1','2026-09-24 11:36:51',NULL),(19,'GAD-001','Mouse Pad Ergonómico','Alfombrilla para ratón con soporte de gel para la muñeca',180.00,25,'ACTIVE','2026-09-24 11:38:20',NULL),(20,'GAD-002','Lámpara LED de Escritorio','Lámpara de mesa táctil con intensidad y temperatura de luz ajustable',420.00,15,'ACTIVE','2026-09-24 11:38:20',NULL),(21,'GAD-003','Soporte para Laptop Ventilado','Base plegable de aluminio con altura ajustable y disipación de calor',350.00,18,'ACTIVE','2026-09-24 11:38:20',NULL),(22,'GAD-004','Organizador de Cables','Kit de 50 piezas adhesivas y clips de silicón para orden en el escritorio',120.00,40,'ACTIVE','2026-09-24 11:38:20',NULL),(23,'GAD-005','Cargador USB Múltiple','Estación de carga rápida de escritorio con 4 puertos USB inteligentes',550.00,12,'ACTIVE','2026-09-24 11:38:20',NULL),(24,'JENNY-301','Barra de Sonido TV','40W Bluetooth con subwoofer integrado',1650.00,12,'1','2026-09-24 12:03:56',NULL),(25,'JENNY-302','Soporte Monitor Doble','Brazo articulado de gas para escritorio',1120.00,15,'1','2026-09-24 12:03:56',NULL),(26,'JENNY-303','Mochila Antirrobo Laptop','Impermeable con puerto de carga USB',650.00,40,'1','2026-09-24 12:03:56',NULL),(27,'JENNY-304','Luz de Anillo LED 10\"','Tripode regulable para videollamadas',380.00,25,'1','2026-09-24 12:03:56',NULL),(28,'JENNY-305','Pad Mouse Extra Grande','Superficie de tela de velocidad 90x40cm',290.00,50,'1','2026-09-24 12:03:56',NULL),(29,'PROD-019','Base Refrigerante para Laptop','Soporte con 2 ventiladores silenciosos y puertos USB integrados',320.00,22,'ACTIVE','2026-09-24 12:15:09',NULL),(30,'PROD-020','Kit de Limpieza para Pantallas','Spray limpiador antiestático y paño de microfibra de alta calidad',95.00,50,'ACTIVE','2026-09-24 12:15:09',NULL),(31,'PROD-021','Adaptador Bluetooth USB 5.0','Mini adaptador inalambrico para conectar audífonos y mandos a la PC',140.00,30,'ACTIVE','2026-09-24 12:15:09',NULL);
/*!40000 ALTER TABLE `tb_products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trq_products_after_insert` AFTER INSERT ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_user,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Create',
        USER(),
        CONCAT(
            'Producto creado. ID=', NEW.ID,
            ', SKU=', NEW.SKU,
            ', name=', NEW.name,
            ', current_price=', NEW.current_price,
            ', current_stock=', NEW.current_stock,
            ', status=', NEW.status
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trq_products_after_update` AFTER UPDATE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_user,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Update',
        USER(),
        CONCAT(
            'Producto actualizado. ID=', NEW.ID,
            ', SKU=', NEW.SKU,
            ', name=', NEW.name,
            ', precio_anterior=', OLD.current_price, ', precio_nuevo=', NEW.current_price,
            ', stock_anterior=', OLD.current_stock, ', stock_nuevo=', NEW.current_stock,
            ', status=', NEW.status
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trq_products_after_delete` AFTER DELETE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_user,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Delete',
        USER(),
        CONCAT(
            'Producto eliminado. ID=', OLD.ID,
            ', SKU=', OLD.SKU,
            ', name=', OLD.name
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_users`
--

DROP TABLE IF EXISTS `tb_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `nick` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nick` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_users`
--

LOCK TABLES `tb_users` WRITE;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` VALUES (14,'240556@utxicotepec.edu.mx','JEN','b6b8870c2b130a562fbe89fb0bb9518a','2026-09-10 10:50:34',NULL,NULL,_binary '\0'),(15,'240234@utxicotepec.edu.mx','GADY','51676091c6366bd05da30f9e0fe59aa0','2026-09-10 10:51:03',NULL,NULL,_binary '\0'),(16,'240080@utxicotepec.edu.mx','JEIG','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 11:27:34',NULL,NULL,_binary '\0'),(17,'240603@utxicotepec.edu.mx','JILC','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 11:32:02',NULL,NULL,_binary '\0'),(18,'240765@utxicotepec.edu.mx','DGS','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 11:32:21',NULL,NULL,_binary '\0');
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_trazabilidad_productos`
--

DROP TABLE IF EXISTS `vw_trazabilidad_productos`;
/*!50001 DROP VIEW IF EXISTS `vw_trazabilidad_productos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_trazabilidad_productos` AS SELECT 
 1 AS `id`,
 1 AS `name`,
 1 AS `description`,
 1 AS `inserted_by`,
 1 AS `roles`,
 1 AS `table_description`,
 1 AS `operation_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_trazabilidad_usuarios`
--

DROP TABLE IF EXISTS `vw_trazabilidad_usuarios`;
/*!50001 DROP VIEW IF EXISTS `vw_trazabilidad_usuarios`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_trazabilidad_usuarios` AS SELECT 
 1 AS `id`,
 1 AS `nick`,
 1 AS `email`,
 1 AS `inserted_by`,
 1 AS `roles`,
 1 AS `table_description`,
 1 AS `operation_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_trazabilidad_productos`
--

/*!50001 DROP VIEW IF EXISTS `vw_trazabilidad_productos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_trazabilidad_productos` AS select `p`.`ID` AS `id`,`p`.`name` AS `name`,`p`.`description` AS `description`,`b`.`db_user` AS `inserted_by`,coalesce(group_concat(distinct `re`.`FROM_USER` order by `re`.`FROM_USER` ASC separator ', '),'Sin rol') AS `roles`,`b`.`table_description` AS `table_description`,`b`.`operation_date` AS `operation_date` from ((`tb_products` `p` join `tb_logs` `b` on((`b`.`table_description` like concat('%ID=',`p`.`ID`,'%')))) left join `mysql`.`role_edges` `re` on((`re`.`TO_USER` = substring_index(`b`.`db_user`,'@',1)))) where ((`b`.`table_operation` = 'Create') and (`b`.`table_name` = 'tb_products')) group by `p`.`ID`,`p`.`name`,`p`.`description`,`b`.`db_user`,`b`.`table_description`,`b`.`operation_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_trazabilidad_usuarios`
--

/*!50001 DROP VIEW IF EXISTS `vw_trazabilidad_usuarios`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_trazabilidad_usuarios` AS select `u`.`ID` AS `id`,`u`.`nick` AS `nick`,`u`.`email` AS `email`,`b`.`db_user` AS `inserted_by`,coalesce(group_concat(distinct `re`.`FROM_USER` order by `re`.`FROM_USER` ASC separator ', '),'Sin roles asignados') AS `roles`,`b`.`table_description` AS `table_description`,`b`.`operation_date` AS `operation_date` from ((`tb_users` `u` join `tb_logs` `b` on(((`b`.`table_description` like concat('%',`u`.`nick`,'%')) and (`b`.`table_description` like concat('%',`u`.`email`,'%'))))) left join `mysql`.`role_edges` `re` on((`re`.`TO_USER` = substring_index(`b`.`db_user`,'@',1)))) where ((`b`.`table_operation` = 'Create') and (`b`.`table_name` = 'tb_users')) group by `u`.`ID`,`u`.`nick`,`u`.`email`,`b`.`db_user`,`b`.`table_description`,`b`.`operation_date` order by `b`.`operation_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-24 13:01:28
