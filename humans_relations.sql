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
-- Table structure for table `relations`
--

DROP TABLE IF EXISTS `relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relations` (
  `RelationID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Relation ID',
  `RelationName` int(11) NOT NULL COMMENT 'Type of relation',
  `RelationPerson` int(11) NOT NULL COMMENT 'Person who is having the relation',
  `RelationWithPerson` int(11) NOT NULL COMMENT 'Person the relation is with',
  PRIMARY KEY (`RelationID`),
  KEY `FK_RELATIONS_PERSONS_PersonID` (`RelationPerson`),
  KEY `FK_RELATIONS_RELATIONNAMES_RelationnameID` (`RelationName`),
  KEY `FK_RELATIONS_PERSONS_copy_PersonID` (`RelationWithPerson`),
  CONSTRAINT `FK_RELATIONS_PERSONS_PersonID` FOREIGN KEY (`RelationPerson`) REFERENCES `persons` (`PersonID`),
  CONSTRAINT `FK_RELATIONS_RELATIONNAMES_RelationnameID` FOREIGN KEY (`RelationName`) REFERENCES `relationnames` (`RelationnameID`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=latin1 COMMENT='Table to express relations between natural persons';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relations`
--

LOCK TABLES `relations` WRITE;
/*!40000 ALTER TABLE `relations` DISABLE KEYS */;
INSERT INTO `relations` VALUES (34,3,22,23),(35,3,23,22),(36,3,24,25),(37,3,25,24),(38,3,26,27),(39,3,27,26),(40,3,28,29),(41,3,29,28),(42,3,30,31),(43,3,31,30),(44,3,32,33),(45,3,33,32),(47,3,34,35),(48,3,35,34),(49,3,36,37),(50,3,37,36),(51,3,38,39),(52,3,39,38),(53,3,40,41),(54,3,41,40),(55,3,42,43),(56,3,43,42),(57,3,47,48),(58,3,48,47),(59,1,22,24),(61,1,24,26),(62,2,24,27),(63,1,25,28),(64,2,25,29),(65,1,26,30),(66,2,26,31),(67,1,27,32),(68,2,27,33),(69,1,28,34),(70,2,28,35),(71,1,29,36),(72,2,29,37),(73,1,38,22),(74,1,40,22),(75,2,40,23),(76,2,42,23),(77,1,44,38),(78,1,47,44),(79,1,46,42),(80,2,46,43);
/*!40000 ALTER TABLE `relations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-05 19:33:20
