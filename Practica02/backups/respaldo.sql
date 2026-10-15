CREATE DATABASE IF NOT EXISTS db_test;
USE db_test;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: db_test
-- ------------------------------------------------------
-- Server version 8.0.36

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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (2,'tb_users','Create','root@localhost','Usuario creado. ID=13, email=240349@utxicotepec.edu.mx, nick=GAD, creation_date=2026-09-10 10:49:37, status=\0','2026-09-10 10:49:37',_binary '\0'),(3,'tb_users','Create','root@localhost','Usuario creado ID=13, email=240349@utxicotepec.edu.mx, nick=GAD, creation_date=2026-09-10 10:49:37, status=\0','2026-09-10 10:49:37',_binary '\0'),(4,'tb_users','Create','root@localhost','Usuario creado. ID=14, email=240556@utxicotepec.edu.mx, nick=JEN, creation_date=2026-09-10 10:50:34, status=\0','2026-09-10 10:50:34',_binary '\0'),(5,'tb_users','Create','root@localhost','Usuario creado ID=14, email=240556@utxicotepec.edu.mx, nick=JEN, creation_date=2026-09-10 10:50:34, status=\0','2026-09-10 10:50:34',_binary '\0'),(6,'tb_users','Create','root@localhost','Usuario creado. ID=15, email=240234@utxicotepec.edu.mx, nick=JEY, creation_date=2026-09-10 10:51:03, status=\0','2026-09-10 10:51:03',_binary '\0'),(7,'tb_users','Create','root@localhost','Usuario creado ID=15, email=240234@utxicotepec.edu.mx, nick=JEY, creation_date=2026-09-10 10:51:03, status=\0','2026-09-10 10:51:03',_binary '\0'),(8,'tb_users','Create','jenny.CM@PC-18','Usuario creado. ID=16, email=240080@utxicotepec.edu.mx, nick=JEIG, creation_date=2026-09-10 11:27:34, status=\0','2026-09-10 11:27:34',_binary '\0'),(9,'tb_users','Create','jenny.CM@PC-18','Usuario creado ID=16, email=240080@utxicotepec.edu.mx, nick=JEIG, creation_date=2026-09-10 11:27:34, status=\0','2026-09-10 11:27:34',_binary '\0'),(10,'tb_users','Create','jenny.CM@PC-18','Usuario creado. ID=17, email=240603@utxicotepec.edu.mx, nick=JILC, creation_date=2026-09-10 11:32:02, status=\0','2026-09-10 11:32:02',_binary '\0'),(11,'tb_users','Create','jenny.CM@PC-18','Usuario creado ID=17, email=240603@utxicotepec.edu.mx, nick=JILC, creation_date=2026-09-10 11:32:02, status=\0','2026-09-10 11:32:02',_binary '\0'),(12,'tb_users','Create','jenny.CM@PC-18','Usuario creado. ID=18, email=240765@utxicotepec.edu.mx, nick=DGS, creation_date=2026-09-10 11:32:21, status=\0','2026-09-10 11:32:21',_binary '\0'),(13,'tb_users','Create','jenny.CM@PC-18','Usuario creado ID=18, email=240765@utxicotepec.edu.mx, nick=DGS, creation_date=2026-09-10 11:32:21, status=\0','2026-09-10 11:32:21',_binary '\0');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` VALUES 
(1,'PROD-001','Smart TV 55\" 4K','Televisor LED UHD, HDR10, con funciones de Smart TV',450.00,15,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03'),
(2,'PROD-002','Smart TV 32\" HD','Televisor LED HD Ready, puertos HDMI y USB',180.00,30,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03'),
(3,'PROD-003','Smart TV 65\" OLED','Televisor 4K UHD, panel OLED, 120Hz para gaming',1200.00,8,'ACTIVE','2026-09-22 07:46:03','2026-09-22 07:46:03');
/*!40000 ALTER TABLE `tb_products` ENABLE KEYS */;
UNLOCK TABLES;

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



CREATE TABLE consulta_verificacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nick VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    inserted_by VARCHAR(100) NOT NULL,
    roles VARCHAR(50),
    operation_description TEXT NOT NULL,
    operation_date DATETIME NOT NULL
);

-- Inserción de los datos de ejemplo
INSERT INTO consulta_verificacion (nick, email, inserted_by, roles, operation_description, operation_date) VALUES
('marco', 'marco.ramirez@ubicotepec.edu.mx', 'root@localhost', NULL, 'Usuario creado. ID=3, email=marco.ramirez@ubicotepec.edu.mx', '2026-09-10 09:58:11'),
('vanessa', '240270@ubicotepec.edu.mx', 'vanessa.vergara@PC-02', NULL, 'Usuario creado. ID=6, email=240270@ubicotepec.edu.mx', '2026-09-10 11:26:03'),
('samuel', 'samuel.vargas@DESKTOP-ACMH89I', 'samuel.vargas@DESKTOP-ACMH89I', 'support', 'Usuario creado. ID=10, email=samuel.vargas@DESKTOP-ACMH89I', '2026-09-17 10:44:39');

--
-- Dumping data for table `tb_users`
--

LOCK TABLES `tb_users` WRITE;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` VALUES (14,'240556@utxicotepec.edu.mx','JEN','b6b8870c2b130a562fbe89fb0bb9518a','2026-09-10 10:50:34',NULL,NULL,_binary '\0'),(15,'240234@utxicotepec.edu.mx','GADY','51676091c6366bd05da30f9e0fe59aa0','2026-09-10 10:51:03',NULL,NULL,_binary '\0'),(16,'240080@utxicotepec.edu.mx','JEIG','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 11:27:34',NULL,NULL,_binary '\0'),(17,'240603@utxicotepec.edu.mx','JILC','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 11:32:02',NULL,NULL,_binary '\0'),(18,'240765@utxicotepec.edu.mx','DGS','81dc9bdb52d04dc20036dbd8313ed055','2026-09-10 11:32:21',NULL,NULL,_binary '\0');
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
-- Dump completed on 2026-09-10 13:14:15    