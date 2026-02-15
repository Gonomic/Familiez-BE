-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: humans
-- ------------------------------------------------------
-- Server version	8.0.18

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
-- Table structure for table `persons`
--

DROP TABLE IF EXISTS `persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persons` (
  `PersonID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Column with PersonID also primary key and autoincrement',
  `PersonGivvenName` varchar(25) NOT NULL COMMENT 'Givven name of a person',
  `PersonFamilyName` varchar(50) NOT NULL COMMENT 'Familyname of a person',
  `PersonDateOfBirth` date NOT NULL COMMENT 'Date of birth of a person',
  `PersonPlaceOfBirth` varchar(50) NOT NULL COMMENT 'Place of birth of a person',
  `PersonDateOfDeath` date DEFAULT NULL COMMENT 'Date of death of a person',
  `PersonPlaceOfDeath` varchar(80) DEFAULT NULL COMMENT 'Place of death of a person',
  `PersonIsMale` tinyint(1) DEFAULT NULL COMMENT 'Signifies if a person is a male or a female',
  `PersonPhoto` longblob COMMENT 'Photo of a person',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Field to determine for a pending change whether or not the record has been edited by another user ',
  PRIMARY KEY (`PersonID`),
  KEY `FamilyName` (`PersonFamilyName`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=latin1 COMMENT='Table that contains data for a natural person';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `persons`
--

LOCK TABLES `persons` WRITE;
/*!40000 ALTER TABLE `persons` DISABLE KEYS */;
INSERT INTO `persons` VALUES (22,'Gen-0','ExLin1','1801-01-01','Earth Village','1880-12-31','Heaven Village',1,NULL,'2020-01-02 11:55:06'),(23,'Gen-0','ExLin0','1802-02-02','Earth Village','1881-12-31','Heaven Village',0,NULL,'2020-01-02 11:55:06'),(24,'Gen-1','ExLin1','1770-01-01','Earth Village','1830-06-06','Heaven Village',1,NULL,'2020-01-02 11:35:48'),(25,'Gen-1','ExLin2','1771-02-02','Earth Village','1831-06-06','Heaven Village',0,NULL,'2020-01-02 11:35:48'),(26,'Gen-2','ExLin1','1740-01-01','Earth Village','1800-01-01','Heaven Village',1,NULL,'2020-01-02 11:35:48'),(27,'Gen-2','ExLin3','1741-01-01','Earth Village','1801-01-01','Heaven Village',0,NULL,'2020-01-02 11:35:48'),(28,'Gen-2','ExLin2','1810-01-01','Earth Village','1890-01-01','Heaven Village',1,NULL,'2020-01-02 11:35:48'),(29,'Gen-2','ExLin4','1811-01-01','Earth Village','1891-01-01','Heaven Village',0,NULL,'2020-01-02 11:35:48'),(30,'Gen-3','ExLin1','1660-01-01','Earth Village','1740-01-01','Heaven Village',1,NULL,'2020-01-02 11:44:57'),(31,'Gen-3','ExLin5','1661-01-01','Earth Village','1741-01-01','Heaven Village',0,NULL,'2020-01-02 11:44:57'),(32,'Gen-3','ExLin3','1660-01-01','Earth Village','1740-01-01','Heaven Village',1,NULL,'2020-01-02 11:44:57'),(33,'Gen-3','ExLin6','1661-01-01','Earth Village','1741-01-01','Heaven Village',0,NULL,'2020-01-02 11:44:57'),(34,'Gen-3','ExLin2','1660-01-01','Earth Village','1740-01-01','Heaven Village',1,NULL,'2020-01-02 11:44:57'),(35,'Gen-3','ExLin7','1661-01-01','Earth Village','1741-01-01','Heaven Village',0,NULL,'2020-01-02 11:44:57'),(36,'Gen-3','ExLin4','1660-01-01','Earth Village','1740-01-01','Heaven Village',1,NULL,'2020-01-02 11:44:57'),(37,'Gen-3','ExLin8','1661-01-01','Earth Village','1741-01-01','Heaven Village',0,NULL,'2020-01-02 11:44:57'),(38,'Gen+1#1','ExLin1','1840-01-01','Earth Village','1920-01-01','Heaven Village',1,NULL,'2020-01-02 11:55:06'),(39,'Gen+1#1','ExLinA','1841-01-01','Earth Village','1921-01-01','Heaven Village',0,NULL,'2020-01-02 11:55:06'),(40,'Gen+1#2','ExLin1','1845-01-01','Earth Village','1925-01-01','Heaven Village',1,NULL,'2020-01-02 11:55:06'),(41,'Gen+1#1','ExLinB','1841-01-01','Earth Village','1926-01-01','Heaven Village',0,NULL,'2020-01-02 11:55:06'),(42,'Gen+1#1','ExLin0','1842-01-01','Earth Village','1920-01-01','Heaven Village',1,NULL,'2020-01-02 11:55:06'),(43,'Gen+1#1','ExLinC','1843-01-01','Earth Vilage','1921-01-01','Heaven Village',0,NULL,'2020-01-02 11:55:06'),(44,'Gen+2#1','ExLin1','1880-01-01','Earth Village','1960-01-01','Heaven Village',1,NULL,'2020-01-02 12:04:39'),(45,'Gen+2#1','ExLinE','1900-01-01','Earth Village','1980-01-01','Heaven Village',0,NULL,'2020-01-02 12:04:39'),(46,'Gen+2#1','ExLin0','1890-01-01','Earth Village','1970-01-01','Heaven Village',1,NULL,'2020-01-02 12:04:39'),(47,'Gen+3#1','ExLin1','1930-01-01','Earth Village',NULL,NULL,1,NULL,'2020-01-02 12:04:39'),(48,'Gen+3#1','ExLinF','1931-01-01','Earth Village',NULL,NULL,0,NULL,'2020-01-02 12:04:39');
/*!40000 ALTER TABLE `persons` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-05 19:33:22
