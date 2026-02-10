-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: 10.10.1.3    Database: humans
-- ------------------------------------------------------
-- Server version	8.0.12

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
-- Table structure for table `APItoDB`
--

DROP TABLE IF EXISTS `APItoDB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `APItoDB` (
  `APItoDB_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `APItoDBRoute` varchar(80) NOT NULL,
  `APItoDBSpoName` varchar(80) DEFAULT NULL,
  `SpoFieldNamesAndTypes` text,
  PRIMARY KEY (`APItoDB_id`),
  UNIQUE KEY `APItoDB-id_UNIQUE` (`APItoDB_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COMMENT='Database which registers the various api path and connects them to Sprocs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `APItoDB`
--

LOCK TABLES `APItoDB` WRITE;
/*!40000 ALTER TABLE `APItoDB` DISABLE KEYS */;
/*!40000 ALTER TABLE `APItoDB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adresses`
--

DROP TABLE IF EXISTS `adresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adresses` (
  `AdressID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of adress',
  `Person` int(11) NOT NULL COMMENT 'Person living on this adress or person that has lived on this adress',
  `AdressStreet` varchar(80) NOT NULL COMMENT 'Street',
  `AdressCity` varchar(80) NOT NULL COMMENT 'City',
  `AdressZipcode` varchar(6) DEFAULT NULL COMMENT 'Zipcode',
  `AdressProvince` varchar(80) DEFAULT NULL COMMENT 'Province',
  `AdressCountry` varchar(80) NOT NULL COMMENT 'Country',
  `AdressIsCurrent` tinyint(1) NOT NULL COMMENT 'Signifies if this is the current adress ',
  `AdressMovedIn` date DEFAULT NULL COMMENT 'Date the person moved in to this adress',
  `AdressMovedOut` date DEFAULT NULL COMMENT 'Date the person moved out of this adress',
  PRIMARY KEY (`AdressID`),
  KEY `FK_ADRESSES_PERSONS_PersonID` (`Person`),
  CONSTRAINT `FK_ADRESSES_PERSONS_PersonID` FOREIGN KEY (`Person`) REFERENCES `persons` (`personid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Table to contain all adresses of a person through time';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adresses`
--

LOCK TABLES `adresses` WRITE;
/*!40000 ALTER TABLE `adresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `adresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `allpersons`
--

DROP TABLE IF EXISTS `allpersons`;
/*!50001 DROP VIEW IF EXISTS `allpersons`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `allpersons` AS SELECT 
 1 AS `PersonID`,
 1 AS `PersonGivvenName`,
 1 AS `PersonFamilyName`,
 1 AS `PersonDateOfBirth`,
 1 AS `PersonPlaceOfBirth`,
 1 AS `PersonDateOfDeath`,
 1 AS `PersonPlaceOfDeath`,
 1 AS `PersonIsMale`,
 1 AS `PersonPhoto`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `archive`
--

DROP TABLE IF EXISTS `archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archive` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdAt` bigint(20) DEFAULT NULL,
  `fromModel` varchar(255) DEFAULT NULL,
  `originalRecord` longtext,
  `originalRecordId` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archive`
--

LOCK TABLES `archive` WRITE;
/*!40000 ALTER TABLE `archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `DocumentId` int(11) NOT NULL,
  `PersonId` int(11) NOT NULL,
  `Type` varchar(45) NOT NULL,
  `Store` varchar(45) DEFAULT NULL,
  `IdOnStore` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`DocumentId`),
  UNIQUE KEY `DocumentId_UNIQUE` (`DocumentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Metadata for documents stored on disc and connected to persons via this metadata';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `humans`
--

DROP TABLE IF EXISTS `humans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `humans` (
  `createdAt` bigint(20) DEFAULT NULL,
  `updatedAt` bigint(20) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `humans`
--

LOCK TABLES `humans` WRITE;
/*!40000 ALTER TABLE `humans` DISABLE KEYS */;
/*!40000 ALTER TABLE `humans` ENABLE KEYS */;
UNLOCK TABLES;

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
  `PersonIsMale` tinyint(1) NOT NULL COMMENT 'Signifies if a person is a male or a female',
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

--
-- Table structure for table `relationnames`
--

DROP TABLE IF EXISTS `relationnames`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relationnames` (
  `RelationnameID` int(11) NOT NULL AUTO_INCREMENT,
  `RelationnameName` varchar(50) NOT NULL,
  `Relationtype` int(11) NOT NULL,
  PRIMARY KEY (`RelationnameID`),
  UNIQUE KEY `RelationnameName_UNIQUE` (`RelationnameName`),
  KEY `FK_RELATIONNAMES_RELATIONTYPES_RelationtypeID` (`Relationtype`),
  CONSTRAINT `FK_RELATIONNAMES_RELATIONTYPES_RelationtypeID` FOREIGN KEY (`Relationtype`) REFERENCES `relationtypes` (`relationtypeid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COMMENT='Table to contain the relation names which fit within relation types';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relationnames`
--

LOCK TABLES `relationnames` WRITE;
/*!40000 ALTER TABLE `relationnames` DISABLE KEYS */;
INSERT INTO `relationnames` VALUES (1,'Vader',1),(2,'Moeder',2),(3,'Partner',3);
/*!40000 ALTER TABLE `relationnames` ENABLE KEYS */;
UNLOCK TABLES;

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
  CONSTRAINT `FK_RELATIONS_PERSONS_PersonID` FOREIGN KEY (`RelationPerson`) REFERENCES `persons` (`personid`),
  CONSTRAINT `FK_RELATIONS_RELATIONNAMES_RelationnameID` FOREIGN KEY (`RelationName`) REFERENCES `relationnames` (`relationnameid`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=latin1 COMMENT='Table to express relations between natural persons';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relations`
--

LOCK TABLES `relations` WRITE;
/*!40000 ALTER TABLE `relations` DISABLE KEYS */;
INSERT INTO `relations` VALUES (34,3,22,23),(35,3,23,22),(36,3,24,25),(37,3,25,24),(38,3,26,27),(39,3,27,26),(40,3,28,29),(41,3,29,28),(42,3,30,31),(43,3,31,30),(44,3,32,33),(45,3,33,32),(47,3,34,35),(48,3,35,34),(49,3,36,37),(50,3,37,36),(51,3,38,39),(52,3,39,38),(53,3,40,41),(54,3,41,40),(55,3,42,43),(56,3,43,42),(57,3,47,48),(58,3,48,47),(59,1,22,24),(60,2,22,24),(61,1,24,26),(62,2,24,27),(63,1,25,28),(64,2,25,29),(65,1,26,30),(66,2,26,31),(67,1,27,32),(68,2,27,33),(69,1,28,34),(70,2,28,35),(71,1,29,36),(72,2,29,37),(73,1,38,22),(74,1,40,22),(75,2,40,23),(76,2,42,23),(77,1,44,38),(78,1,47,44),(79,1,46,42),(80,2,46,43);
/*!40000 ALTER TABLE `relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relationtypes`
--

DROP TABLE IF EXISTS `relationtypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relationtypes` (
  `RelationtypeID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id of the relationtype',
  `RelationTypeName` varchar(50) DEFAULT NULL COMMENT 'Name of the relation type',
  PRIMARY KEY (`RelationtypeID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COMMENT='Table to contain the type of relations a relationname belongs to';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relationtypes`
--

LOCK TABLES `relationtypes` WRITE;
/*!40000 ALTER TABLE `relationtypes` DISABLE KEYS */;
INSERT INTO `relationtypes` VALUES (1,'Vader'),(2,'Moeder'),(3,'Partner');
/*!40000 ALTER TABLE `relationtypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test` (
  `createdAt` bigint(20) DEFAULT NULL,
  `updatedAt` bigint(20) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test`
--

LOCK TABLES `test` WRITE;
/*!40000 ALTER TABLE `test` DISABLE KEYS */;
/*!40000 ALTER TABLE `test` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testlog`
--

DROP TABLE IF EXISTS `testlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `testlog` (
  `TestLog` varchar(1024) DEFAULT NULL,
  `TestlogID` int(11) NOT NULL AUTO_INCREMENT,
  `TestLogDateTime` datetime NOT NULL,
  PRIMARY KEY (`TestlogID`)
) ENGINE=MyISAM AUTO_INCREMENT=27026 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testlog`
--

LOCK TABLES `testlog` WRITE;
/*!40000 ALTER TABLE `testlog` DISABLE KEYS */;
INSERT INTO `testlog` VALUES ('Transaction-9562. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',27025,'2020-01-28 21:06:59'),('Transaction-9562. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',27024,'2020-01-28 21:06:59'),('TransAction-9561. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',27023,'2020-01-28 21:06:53'),('TransAction-9561. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',27022,'2020-01-28 21:06:53'),('Transaction-9560. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',27021,'2020-01-28 21:06:33'),('Transaction-9560. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',27020,'2020-01-28 21:06:33'),('Transaction-9559. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',27019,'2020-01-28 21:06:24'),('Transaction-9559. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',27018,'2020-01-28 21:06:24'),('Transaction-9558. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',27017,'2020-01-28 21:04:30'),('Transaction-9558. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',27016,'2020-01-28 21:04:30'),('TransAction-9557. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: Exl%',27015,'2020-01-28 21:04:24'),('TransAction-9557. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:Exl%',27014,'2020-01-28 21:04:24'),('TransAction-9556. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: FRans%',27013,'2020-01-28 21:00:42'),('TransAction-9556. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:FRans%',27012,'2020-01-28 21:00:42'),('Transaction-9555. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',27011,'2020-01-28 21:00:06'),('Transaction-9555. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',27010,'2020-01-28 21:00:06'),('TransAction-9554. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',27009,'2020-01-28 21:00:05'),('TransAction-9554. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',27008,'2020-01-28 21:00:05'),('TransAction-9553. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: e%',27007,'2020-01-28 21:00:04'),('TransAction-9553. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:e%',27006,'2020-01-28 21:00:04'),('Transaction-9552. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',27005,'2020-01-28 20:54:57'),('Transaction-9552. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',27004,'2020-01-28 20:54:57'),('TransAction-9551. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',27003,'2020-01-28 20:54:56'),('TransAction-9551. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',27002,'2020-01-28 20:54:56'),('Transaction-9550. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',27001,'2020-01-28 20:51:02'),('Transaction-9550. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',27000,'2020-01-28 20:51:02'),('TransAction-9549. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26999,'2020-01-28 20:51:01'),('TransAction-9549. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26998,'2020-01-28 20:51:01'),('Transaction-9548. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26997,'2020-01-28 20:37:43'),('Transaction-9548. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26996,'2020-01-28 20:37:43'),('TransAction-9547. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26995,'2020-01-28 20:37:42'),('TransAction-9547. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26994,'2020-01-28 20:37:42'),('Transaction-9546. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26993,'2020-01-28 20:37:02'),('Transaction-9546. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26992,'2020-01-28 20:37:02'),('TransAction-9545. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26991,'2020-01-28 20:37:00'),('TransAction-9545. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26990,'2020-01-28 20:37:00'),('Transaction-9544. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26989,'2020-01-28 20:34:36'),('Transaction-9544. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26988,'2020-01-28 20:34:36'),('TransAction-9543. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: e%',26987,'2020-01-28 20:34:34'),('TransAction-9543. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:e%',26986,'2020-01-28 20:34:34'),('Transaction-9542. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26985,'2020-01-28 20:32:15'),('Transaction-9542. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26984,'2020-01-28 20:32:15'),('TransAction-9541. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26983,'2020-01-28 20:32:14'),('TransAction-9541. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26982,'2020-01-28 20:32:14'),('Transaction-9540. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26981,'2020-01-28 20:31:19'),('Transaction-9540. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26980,'2020-01-28 20:31:19'),('TransAction-9539. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26979,'2020-01-28 20:31:17'),('TransAction-9539. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26978,'2020-01-28 20:31:17'),('Transaction-9538. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26977,'2020-01-28 20:21:18'),('Transaction-9538. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26976,'2020-01-28 20:21:18'),('TransAction-9537. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26975,'2020-01-28 20:21:17'),('TransAction-9537. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26974,'2020-01-28 20:21:17'),('Transaction-9536. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26973,'2020-01-28 20:19:05'),('Transaction-9536. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26972,'2020-01-28 20:19:05'),('TransAction-9535. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26971,'2020-01-28 20:19:04'),('TransAction-9535. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26970,'2020-01-28 20:19:04'),('Transaction-9534. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26969,'2020-01-28 20:16:55'),('Transaction-9534. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26968,'2020-01-28 20:16:55'),('Transaction-9533. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26967,'2020-01-28 20:15:14'),('Transaction-9533. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26966,'2020-01-28 20:15:14'),('TransAction-9532. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26965,'2020-01-28 20:15:12'),('TransAction-9532. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26964,'2020-01-28 20:15:12'),('Transaction-9531. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26963,'2020-01-28 20:14:35'),('Transaction-9531. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26962,'2020-01-28 20:14:35'),('TransAction-9530. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: e%',26961,'2020-01-28 20:14:33'),('TransAction-9530. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:e%',26960,'2020-01-28 20:14:33'),('Transaction-9529. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 22',26958,'2020-01-28 20:12:08'),('Transaction-9529. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 22',26959,'2020-01-28 20:12:08'),('TransAction-9528. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: e%',26957,'2020-01-28 20:12:06'),('TransAction-9528. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:e%',26956,'2020-01-28 20:12:06'),('TransAction-9527. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26955,'2020-01-28 20:08:50'),('TransAction-9527. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26954,'2020-01-28 20:08:50'),('TransAction-9526. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: e%',26953,'2020-01-28 20:08:50'),('TransAction-9526. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:e%',26952,'2020-01-28 20:08:50'),('TransAction-9525. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ex%',26951,'2020-01-28 20:04:03'),('TransAction-9525. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:ex%',26950,'2020-01-28 20:04:03'),('TransAction-9524. TransResult= 0. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: Ex%',26949,'2020-01-28 19:53:19'),('TransAction-9524. TransResult= 0. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:Ex%',26948,'2020-01-28 19:53:19'),('Transaction-9523. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 24',26947,'2020-01-28 19:50:56'),('Transaction-9523. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 24',26946,'2020-01-28 19:50:56'),('Transaction-9522. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 100',26945,'2020-01-28 19:47:29'),('Transaction-9522. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 100',26944,'2020-01-28 19:47:29'),('Transaction-9521. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 24',26943,'2020-01-28 19:47:18'),('Transaction-9521. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 24',26942,'2020-01-28 19:47:18'),('Transaction-9520. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 24',26941,'2020-01-28 19:46:15'),('Transaction-9520. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 24',26940,'2020-01-28 19:46:15'),('Transaction-9519. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 24',26939,'2020-01-28 19:44:51'),('Transaction-9517. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 24',26934,'2020-01-28 19:41:44'),('Transaction-9518. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 24',26936,'2020-01-28 19:42:29'),('Transaction-9517. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 24',26935,'2020-01-28 19:41:45'),('Transaction-9518. End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: 24',26937,'2020-01-28 19:42:29'),('Transaction-9519. Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: 24',26938,'2020-01-28 19:44:51');
/*!40000 ALTER TABLE `testlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transnos`
--

DROP TABLE IF EXISTS `transnos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transnos` (
  `TransNoID` int(11) NOT NULL AUTO_INCREMENT,
  `SystemName` varchar(45) DEFAULT NULL,
  `TransNoDateTime` datetime NOT NULL,
  PRIMARY KEY (`TransNoID`),
  UNIQUE KEY `idtransnos_UNIQUE` (`TransNoID`)
) ENGINE=MyISAM AUTO_INCREMENT=9563 DEFAULT CHARSET=latin1 COMMENT='Table to register transaction numbers and the systems these are used by and provide seed for next transactionnumber';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transnos`
--

LOCK TABLES `transnos` WRITE;
/*!40000 ALTER TABLE `transnos` DISABLE KEYS */;
INSERT INTO `transnos` VALUES (9451,'GetFather','2020-01-27 20:34:10'),(9452,'GetFamilyTree','2020-01-27 20:35:16'),(9453,'fGetMother','2020-01-27 20:35:16'),(9454,'fGetFather','2020-01-27 20:35:17'),(9455,'fGetPartner','2020-01-27 20:35:17'),(9456,'fGetMother','2020-01-27 20:35:17'),(9457,'fGetFather','2020-01-27 20:35:17'),(9458,'fGetPartner','2020-01-27 20:35:17'),(9459,'fGetMother','2020-01-27 20:35:17'),(9460,'fGetFather','2020-01-27 20:35:17'),(9461,'fGetPartner','2020-01-27 20:35:17'),(9462,'fGetMother','2020-01-27 20:35:17'),(9463,'fGetFather','2020-01-27 20:35:17'),(9464,'fGetPartner','2020-01-27 20:35:17'),(9465,'fGetMother','2020-01-27 20:35:17'),(9466,'fGetFather','2020-01-27 20:35:17'),(9467,'fGetPartner','2020-01-27 20:35:17'),(9468,'fGetMother','2020-01-27 20:35:18'),(9469,'fGetFather','2020-01-27 20:35:18'),(9470,'fGetPartner','2020-01-27 20:35:18'),(9471,'fGetMother','2020-01-27 20:35:18'),(9472,'fGetFather','2020-01-27 20:35:18'),(9473,'fGetPartner','2020-01-27 20:35:18'),(9474,'fGetMother','2020-01-27 20:35:18'),(9475,'fGetFather','2020-01-27 20:35:18'),(9476,'fGetPartner','2020-01-27 20:35:18'),(9477,'fGetMother','2020-01-27 20:35:18'),(9478,'fGetFather','2020-01-27 20:35:18'),(9479,'fGetPartner','2020-01-27 20:35:18'),(9480,'fGetMother','2020-01-27 20:35:19'),(9481,'fGetFather','2020-01-27 20:35:19'),(9482,'fGetPartner','2020-01-27 20:35:19'),(9483,'fGetMother','2020-01-27 20:35:19'),(9484,'fGetFather','2020-01-27 20:35:19'),(9485,'fGetPartner','2020-01-27 20:35:19'),(9486,'fGetMother','2020-01-27 20:35:19'),(9487,'fGetFather','2020-01-27 20:35:19'),(9488,'fGetPartner','2020-01-27 20:35:19'),(9489,'fGetFather','2020-01-27 20:35:19'),(9490,'fGetMother','2020-01-27 20:35:19'),(9491,'fGetPartner','2020-01-27 20:35:19'),(9492,'fGetFather','2020-01-27 20:35:19'),(9493,'fGetMother','2020-01-27 20:35:19'),(9494,'GetFamilyTree','2020-01-27 20:35:51'),(9495,'fGetMother','2020-01-27 20:35:51'),(9496,'fGetFather','2020-01-27 20:35:51'),(9497,'fGetPartner','2020-01-27 20:35:51'),(9498,'fGetFather','2020-01-27 20:35:51'),(9499,'fGetMother','2020-01-27 20:35:51'),(9500,'fGetPartner','2020-01-27 20:35:51'),(9501,'GetPlainListOfPersons','2020-01-27 20:36:38'),(9502,'GetPlainListOfPersons','2020-01-27 20:44:38'),(9503,'GetPlainListOfPersons','2020-01-27 20:45:46'),(9504,'GetPlainListOfPersons','2020-01-27 22:01:08'),(9505,'GetPlainListOfPersons','2020-01-27 22:01:08'),(9506,'GetPlainListOfPersons','2020-01-27 22:07:21'),(9507,'GetPlainListOfPersons','2020-01-27 22:15:14'),(9508,'GetPlainListOfPersons','2020-01-27 22:21:48'),(9509,'GetAllChildrenFromOneParentWithPartner','2020-01-28 18:37:03'),(9510,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:12:17'),(9511,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:13:48'),(9512,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:14:11'),(9513,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:20:26'),(9514,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:32:01'),(9515,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:34:14'),(9516,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:39:53'),(9517,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:41:44'),(9518,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:42:29'),(9519,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:44:51'),(9520,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:46:15'),(9521,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:47:18'),(9522,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:47:29'),(9523,'GetAllChildrenFromOneParentWithPartner','2020-01-28 19:50:56'),(9524,'GetPlainListOfPersons','2020-01-28 19:53:19'),(9525,'GetPlainListOfPersons','2020-01-28 20:04:03'),(9526,'GetPlainListOfPersons','2020-01-28 20:08:50'),(9527,'GetPlainListOfPersons','2020-01-28 20:08:50'),(9528,'GetPlainListOfPersons','2020-01-28 20:12:06'),(9529,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:12:08'),(9530,'GetPlainListOfPersons','2020-01-28 20:14:33'),(9531,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:14:35'),(9532,'GetPlainListOfPersons','2020-01-28 20:15:12'),(9533,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:15:14'),(9534,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:16:55'),(9535,'GetPlainListOfPersons','2020-01-28 20:19:04'),(9536,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:19:05'),(9537,'GetPlainListOfPersons','2020-01-28 20:21:17'),(9538,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:21:18'),(9539,'GetPlainListOfPersons','2020-01-28 20:31:17'),(9540,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:31:19'),(9541,'GetPlainListOfPersons','2020-01-28 20:32:13'),(9542,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:32:15'),(9543,'GetPlainListOfPersons','2020-01-28 20:34:34'),(9544,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:34:36'),(9545,'GetPlainListOfPersons','2020-01-28 20:37:00'),(9546,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:37:01'),(9547,'GetPlainListOfPersons','2020-01-28 20:37:42'),(9548,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:37:43'),(9549,'GetPlainListOfPersons','2020-01-28 20:51:01'),(9550,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:51:02'),(9551,'GetPlainListOfPersons','2020-01-28 20:54:56'),(9552,'GetAllChildrenFromOneParentWithPartner','2020-01-28 20:54:57'),(9553,'GetPlainListOfPersons','2020-01-28 21:00:04'),(9554,'GetPlainListOfPersons','2020-01-28 21:00:05'),(9555,'GetAllChildrenFromOneParentWithPartner','2020-01-28 21:00:06'),(9556,'GetPlainListOfPersons','2020-01-28 21:00:42'),(9557,'GetPlainListOfPersons','2020-01-28 21:04:24'),(9558,'GetAllChildrenFromOneParentWithPartner','2020-01-28 21:04:30'),(9559,'GetAllChildrenFromOneParentWithPartner','2020-01-28 21:06:24'),(9560,'GetAllChildrenFromOneParentWithPartner','2020-01-28 21:06:33'),(9561,'GetPlainListOfPersons','2020-01-28 21:06:53'),(9562,'GetAllChildrenFromOneParentWithPartner','2020-01-28 21:06:59');
/*!40000 ALTER TABLE `transnos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'humans'
--
/*!50003 DROP FUNCTION IF EXISTS `fGetFather` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `fGetFather`(PersonIdIn INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to get the PersonId of the Father of a person with PersonIdIn.'
BEGIN

    DECLARE RetVal INT;
    DECLARE NewTranNo INT;
    
    SET NewTranNo = GetTranNo("fGetFather");

	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: fGetFather() voor persoon: ', IFNULL(PersonIdIn, '')),
		TestLogDateTime = NOW();
        
    select RelationWithPerson INTO RetVal from relations where RelationPerson= PersonIdIn and RelationName = "1"; 
    
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: fGetFather() voor persoon: ', IFNULL(PersonIdIn, ''), '. Father found= ',IFNULL(RetVal, '')),
		TestLogDateTime = NOW();    
   
	RETURN RetVal; 
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fGetMother` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `fGetMother`(PersonIdIn INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to get the PersonId of the Mother of a person with PersonIdIn.'
BEGIN

    DECLARE RetVal INT;
    DECLARE NewTranNo INT;
    
    SET NewTranNo = GetTranNo("fGetMother");

	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: fGetMother() voor persoon: ', IFNULL(PersonIdIn, '')),
		TestLogDateTime = NOW();
        
    select RelationWithPerson INTO RetVal from relations where RelationPerson= PersonIdIn and RelationName = "2"; 
    
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: fGetMother() voor persoon: ', IFNULL(PersonIdIn, ''), '. Mother found= ',IFNULL(RetVal, '')),
		TestLogDateTime = NOW();    
   
	RETURN RetVal; 
   
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fGetParmNamesAndTypes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `fGetParmNamesAndTypes`(`SpecificNameIn` CHAR(60), `TransNoIn` INT) RETURNS text CHARSET utf8
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Function to return parameter names and type of a specific SPROC'
BEGIN
	DECLARE done INT default FALSE;
	DECLARE ReturnValue text;
    DECLARE ParmName, ParmType CHAR(20);
   
    DECLARE Cursor1 CURSOR for select PARAMETER_NAME,  DATA_TYPE from information_schema.parameters where SPECIFIC_NAME =  SpecificNameIn;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    INSERT INTO humans.testlog 
    SET TestLog = CONCAT('TransAction-', IFNULL(TransNoIn, 'null'), 'In GetParmNamesAndTypes(). SpecificNameIn= ', SpecificNameIn), TestLogDateTime = NOW();

	OPEN Cursor1;

	SET ReturnValue="{'parms':";

	read_loop: LOOP
		FETCH cursor1 INTO ParmName, ParmType;
		IF done THEN
		  LEAVE read_loop;
		END IF;
		SET ReturnValue = concat(ReturnValue, '{"Name":"', ParmName, '" , "type":"', ParmType, '"},');
        SET ParmName= "";
        SET ParmType= "";
	  END LOOP;
      
      SET ReturnValue = SUBSTR(ReturnValue, 1, LENGTH(ReturnValue)-1);
      SET ReturnValue = concat(ReturnValue, '}');

	RETURN ReturnValue; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fGetPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `fGetPartner`(PersonIdIn INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to get the PersonId of the parner of a person with PersonIdIn.'
BEGIN

    DECLARE Partner INT;
    DECLARE NewTranNo INT;
    
    SET NewTranNo = GetTranNo("fGetPartner");

	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: fGetPartner() voor persoon: ', IFNULL(PersonIdIn, '')),
		TestLogDateTime = NOW();
        
    select RelationWithPerson INTO Partner from relations where RelationPerson= PersonIdIn and RelationName = "3"; 
    
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: fGetPartner() voor persoon: ', IFNULL(PersonIdIn, ''), '. Partner found= ',IFNULL(Partner, '')),
		TestLogDateTime = NOW();    
    
	RETURN Partner; 
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fPersonsArePartners` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `fPersonsArePartners`(PersonIn1 INT, PersonIn2 INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function returns true if two persons are eachothers partner'
BEGIN

    DECLARE NewTranNo INT;
    DECLARE RecCount INT;
    DECLARE ArePartners BOOL;
    
    SET NewTranNo = GetTranNo("PersonsArePartners");

	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: PersonsArePartners() voor persoon: ', IFNULL(PersonIn1, 'null'), ' en voor persoon: ', IFNULL(PersonIn2, 'null')),
		TestLogDateTime = NOW();
        
    select count(*) from relations where RelationPerson= PersonIn1 and RelationWithPerson = PersonIn2 and RelationName = "3" into RecCount;
    
    IF RecCount > 0 THEN
		SET ArePartners = true;
	ELSE
		SET ArePartners = false;
	END IF;
       
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: PersonsArePartners(). Persoon ', IFNULL(PersonIn1, ''), ' en persoon ',IFNULL(PersonIn2, ''), ' zijn partners= ', IFNULL(ArePartners, 'null')),
		TestLogDateTime = NOW();    
    
	RETURN ArePartners; 
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetTranNo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `GetTranNo`(`SystemNameIn` VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Function to get a transactionnumber while at the same time storing the last number and the system it was used for.'
BEGIN



	DECLARE LastTranNo INT;



INSERT INTO humans.transnos

	SET SystemName = SystemNameIn,

		 TransNoDateTime = NOW();



SET LastTranNo = LAST_INSERT_ID();



RETURN LastTranNo;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `RecordHasBeenChangedBySomebodyElse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `RecordHasBeenChangedBySomebodyElse`(`PersonIdIn` INT, `DateTimeIn` DATETIME) RETURNS tinyint(1)
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Function to check, based om a timestamp, whether or not a record has been changed by somebody else.'
BEGIN



	DECLARE ReturnValue tinyint(1);

	DECLARE StoredDateTime timestamp;



SELECT persons.Timestamp FROM persons WHERE PersonID = PersonIdIn INTO StoredDateTime;



IF  StoredDateTime <> DateTimeIn THEN

	SET ReturnValue = TRUE;

ELSE

	SET ReturnValue = FALSE;

END IF;



RETURN ReturnValue; 



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `RowCountForFamilyTree` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `RowCountForFamilyTree`() RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to count the number of rows in the FamilyTree table'
BEGIN
	DECLARE RowCountToBeReturned INT(11);
	SELECT count(*) FROM FamilyTree INTO RowCountToBeReturned; 
	RETURN RowCountToBeReturned;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AbstractDBtoAPInfo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `AbstractDBtoAPInfo`()
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
	-- CompletedOk defines the result of a database transaction, like this:
    -- 0 = Transaction finished without problems.
    -- 1 = 
    -- 2 = Transaction aborted due to problems during update and rollback performed
    -- ...
    DECLARE CompletedOk int;

    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table
	DECLARE NewTransNo int;

    -- TransResult is used to count the number of seperate database operations and rissen with each step
	DECLARE TransResult int;

    -- RecCount is used to count the number of related records in depended tables.
	DECLARE RecCount int;
    
    -- Number of records in the result set
    DECLARE n INT;
    
    -- Counter to go from first record to last record
    DECLARE i INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET CompletedOk = 2;
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: AbstractDBtoAPInfo(). Rollback executed. CompletedOk= ", CompletedOk),
				TestLogDateTime = NOW();
		SELECT CompletedOk;
	END;

main_proc:
BEGIN
    SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("AbstractDBtoAPInfo");
    
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). TransResult= ', TransResult, '. Start SPROC: AbstractDBtoAPInfo().'),
		TestLogDateTime = NOW();

	select count(*) from mysql.proc where Db="humans" and type="PROCEDURE" into n;
    
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Opslaan aantal sprocs in n, n= ', n),
		TestLogDateTime = NOW();

    set i=0;
    
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Startwaarde van teller i= ', i),
		TestLogDateTime = NOW();


    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Start deletion of all records in the APItoDB table.'),
		TestLogDateTime = NOW();
        
	truncate table humans.APItoDB;
    
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Start get names of all SPROCs in the humans DB.'),
		TestLogDateTime = NOW();
    
    insert into humans.APItoDB (APItoDBRoute) select name as APItoDBRoute from mysql.proc where Db="humans" and type="PROCEDURE";
    
    WHILE i<n do
    
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Looping, i= ', i, ', n= ', n),
			TestLogDateTime = NOW();
		 
		select APItoDBRoute, APItoDB_id into @NameOfRecordToUpdate, @IDofRecordToUpdate  from humans.APItoDB limit i,1; 
		 
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). In loop. Name of record to update= ', @NameOfRecordToUpdate, ', IDofRecordToUpdate= ', @IDofRecordToUpdate),
			TestLogDateTime = NOW();
            
            update humans.APItoDB set SpoFieldNamesAndTypes = GetParmNamesandTypes(@NameOfRecordToUpdate, NewTransNo) where humans.APItoDB.APItoDB_id = @IDofRecordToUpdate;

			set i=i+1;
    end while;
    
    
    
  SET TransResult = TransResult + 1;
    
  SET RecCount = n;

  SELECT CompletedOk, RecCount AS APItoDBRecsGevonden;

  INSERT INTO humans.testlog 
  SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC: AbstractDBtoAPInfo(). CompletedOk= ', CompletedOk, '. APItoDB records aangemaakt=', RecCount),
	  TestLogDateTime = NOW();

END;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddPersonDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `AddPersonDetails`(IN `PersonGivvenNameIn` VARCHAR(25), IN `PersonFamilyNameIn` VARCHAR(50), IN `PersonDateOfBirthIn` DATETIME, IN `PersonPlaceOfBirthIn` VARCHAR(50), IN `PersonDateOfDeathIn` DATETIME, IN `PersonPlaceOfDeathIn` VARCHAR(50), IN `PersonIsMaleIn` TINYINT(1), IN `PersonPhotoIn` LONGBLOB, IN `TimestampIn` TIMESTAMP, IN `PersonPartnerIdIn` INT(11), IN `PersonPartnerIn` VARCHAR(50), IN `PersonFatherIdIn` INT(11), IN `PersonFatherIn` VARCHAR(50), IN `PersonMotherIdIn` INT(11), IN `PersonMotherIn` VARCHAR(50))
    SQL SECURITY INVOKER
    COMMENT 'To add a specific person'
BEGIN

	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = Transaction aborted due to intermediate changes (possibly from other users) in the mean time

    -- 2 = Transaction aborted due to problems during update and rollback performed

    DECLARE CompletedOk INT;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo INT;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult INT;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



    -- LastRecInserted is the autonumber ID value for each addition

	DECLARE LastRecIdInserted INT(11);



	DECLARE FullNamePerson varchar(100);

-- 	DECLARE MessageText text;

-- 	DECLARE ReturnedSqlState int;

-- 	DECLARE MySqlErrNo int;

	

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		-- SET MessageText = MESSAGE_TEXT;

		-- SET ReturnedSqlState = RETURNED_SQLSTATE;

		-- SET MySQLErrNo = MYSQL_ERRNO;

		-- GET CURRENT DIAGNOSTICS CONDITION 1 MessageText : MESSAGE_TEXT, ReturnedSqlState : RETURNED_SQLSTATE, MySqlErrNo : MYSQL_ERRNO;

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured. Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN



START TRANSACTION;



SET CompletedOk = 0;



SET TransResult = 0;



SET NewTransNo = GetTranNo("NewPersonDetails");



INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start insert for person.'),
    TestLogDateTime = NOW();
        

/*
FDE03111963
Commented out because this SPO is copied and paste from the update sproc where you take into account other can have 
edited the record in the mean time. Which is not the case for completely new records
IF RecordHasBeenChangedBySomebodyElse(PersonIdIn, TimeStampIn) THEN

	SET CompletedOk = 1;

	INSERT INTO humans.testLog 

		SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Records has been changed in mean time. Update aborted."),

			TestLogDateTime = NOW();

	SELECT CompletedOk;

	CALL GetPersonDetails(PersonIdIn);

	LEAVE main_proc;

END IF;
*/


INSERT INTO humans.persons  (
    PersonGivvenName,
    PersonFamilyName,
    PersonDateOfBirth,
    PersonPlaceOfBirth,
    PersonDateOfDeath,
    PersonPlaceOfDeath,
    PersonIsMale)
VALUES
    (PersonGivvenNameIn,
     PersonFamilyNameIn,
     PersonDateOfBirthIn,
     PersonPlaceOfBirthIn,
     PersonDateOfDeathIn,
     PersonPlaceOfDeathIn,
     PersonIsMaleIn);
 
SET LastRecIdInserted = LAST_INSERT_ID();

COMMIT;

SET TransResult = 1;

INSERT INTO humans.testlog 
	SET TestLog = concat("TransAction-", IFNULL(NewTransNo, "null"), ". ",
		"Adding new person=> ", 
        "PersonIdIn= ", LastRecIdInserted, ", ",
		"PersonGivvenNameIn= ", IFNULL(PersonGivvenNameIn, "null"), ", ",
		"PersonFamilyNameIn= ", IFNULL(PersonFamilyNameIn, "null"), ", ",
		"PersonDateOfBirthIn= ", IFNULL(PersonDateOfBirthIn, "null"), ", ",
		"PersonPlaceOfBirthIn= ", IFNULL(PersonPlaceOfBirthIn, "null"), ", ",
		"PersonDateOfDeathIn= ", IFNULL(PersonDateOfDeathIn, "null"), ", ",
		"PersonPlaceOfDeathIn= ",  IFNULL(PersonPlaceOfDeathIn, "null"), ", ",
		"PersonIsMaleIn= ", IFNULL(PersonIsMaleIn, "null"), ", ",
		"PersonPhotoIn= ", IFNULL(PersonPhotoIn, "null"), ", ",
		"PersonPartnerIdIn= ", IFNULL(PersonPartnerIdIn, "null"), ", ",
		"PersonPartnerIn= ",  IFNULL(PersonPartnerIn, "null"), ", ",
		"PersonFatherIdIn= ",  IFNULL(PersonFatherIdIn, "null"), ", ",
		"PersonFatherIn= ",  IFNULL(PersonFatherIn, "null"), ", ",
		"PersonMotherIdIn= ",  IFNULL(PersonMotherIdIn, "null"), ", ",
		"PersonMotherIn= ", IFNULL(PersonMotherIn, "null"), "."),
		TestLogDateTime = NOW();


SET RecCount = 0;

INSERT INTO humans.testlog 

	SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, 'null'), ". TransResult= ", TransResult, ". Gegevens zijn toegevoegd van Persoon ID= ", LastRecIdInserted),
		TestLogDateTime = NOW();

SELECT CompletedOk, LastRecIdInserted;

CALL GetPersonDetails(LastRecIdINserted);

END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `API_GetAPItoDBDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `API_GetAPItoDBDetails`()
    SQL SECURITY INVOKER
    COMMENT 'To get the details of SPROCs which can be reached through API'
BEGIN
	-- CompletedOk defines the result of a database transaction, like this:
    -- 0 = Transaction finished without problems.
    -- 1 = 
    -- 2 = Transaction aborted due to problems during update and rollback performed
    -- ...
    DECLARE CompletedOk int;

    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table
	DECLARE NewTransNo int;

    -- TransResult is used to count the number of seperate database operations and rissen with each step
	DECLARE TransResult int;

    -- RecCount is used to count the number of related records in depended tables.
	DECLARE RecCount int;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET CompletedOk = 2;
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: API_GetAPItoDBDetails(). Rollback executed. CompletedOk= ", CompletedOk),
				TestLogDateTime = NOW();
		SELECT CompletedOk;
	END;

main_proc:
BEGIN
    SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("API_GetAPItoDBDetails");

    -- Schrijf start van deze SQL transactie naar log
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('===> Start Transaction= TransAction-', IFNULL(NewTransNo, 'null')), TestLogDateTime = NOW();

	-- SELECT CompletedOk, APItoDBRoute, SpoFieldNamesAndTypes from APItoDB where APItoDBRoute like 'API_%';
   	SELECT CompletedOk, APItoDBRoute, SpoFieldNamesAndTypes from APItoDB;
    
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('<=== End Transaction= TransAction-', IFNULL(NewTransNo, 'null'), 'Select all from APItoDB succesful'), TestLogDateTime = NOW();

END ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Clean_temptable_and_testlog` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Clean_temptable_and_testlog`()
BEGIN
	-- ----------------------------------------------------------------------------------------------------------------------------------------------
    -- Author: 	Frans Dekkers (GoNomics)
    -- Date:	05-01-2020
    -- -----------------------------------
    -- Prurpose of this Sproc:
    -- Clean temporary table "FamilyTree" (this temporary table is used by SPROC GetFamilyTree as a "scratch" table to build a family tree based on an API request
    -- Clean non-temporary table "testlog"(this table is used to log SQL actions as executed by the various Sprocs's and Sfunc's 
    --		
    -- TODO's:
    -- => Nothing yet
    
	drop temporary table IF EXISTS FamilyTree;
	delete from testlog where TestlogID > 0;
	SHOW TABLEs LIKE 'FamilyTree';
	select * from testlog;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deletePerson` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `deletePerson`(IN `PersonIdIn` INT, IN `TimestampIn` DATETIME)
    SQL SECURITY INVOKER
    COMMENT 'To delete a Person from the database, incl. links from Family to this Person.'
BEGIN

	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = Transaction aborted due to Person's details changed in the mean time

    -- 2 = Transaction aborted due to problems during update and rollback performed

    -- ...

    DECLARE CompletedOk int;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo int;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult int;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testLog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". TransResult= ", TransResult, ". Error occured in SPROC: deletePerson(). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN

    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("deletePerson");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: deletePerson() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    IF RecordHasBeenChangedBySomebodyElse(PersonIdIn, TimeStampIn) THEN

	    SET CompletedOk = 1;

	    INSERT INTO humans.testLog 

		    SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". TransResult= ", TransResult, ". Records has been changed in mean time. Update aborted."),

			    TestLogDateTime = NOW();

	    SELECT CompletedOk;

	    LEAVE main_proc;

    END IF;



    -- Delete all refferences from family relative to this person

    DELETE FROM relations 

    WHERE RelationPerson = PersonIdIn;

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Alle familie referenties verwijderd vanaf persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();





    -- Delete all references from this person to family relatives

    DELETE FROM relations

    WHERE RelationWithPerson= PersonIdIn;

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Alle familie referenties verwijderd naar persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();





    -- Delete all adresses from this person to family relatives

    DELETE FROM adresses

    WHERE Person = PersonIdIn;

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Alle adressen verwijderen van persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();





    -- Delete Person record itself.

    DELETE FROM persons

    WHERE PersonID = PersonIdIn;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Persoon verwijderd met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    SELECT CompletedOk;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. SPROC DeletePerson afgerond. CompletedOk= ', CompletedOk),

		TestLogDateTime = NOW();



END ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllChildrenFromFatherAndOrMotherWithoutPartners` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllChildrenFromFatherAndOrMotherWithoutPartners`(IN `Father` int(11), IN `Mother` int(11))
    COMMENT 'To get all children from a specific parent and without the partn'
BEGIN

  SELECT DISTINCT

    CONCAT(Children.PersonGivvenName, ' ', Children.PersonFamilyName) AS 'Naam kind'

  FROM relations AllRelations

    #   Get all records from relations from specific persons who are either father or mother

    INNER JOIN relationnames IsChild

      ON AllRelations.RelationName = IsChild.RelationNameID

      AND (IsChild.RelationnameName = 'Vader'

      OR IsChild.RelationnameName = 'Moeder')

      AND (AllRelations.RelationWithPerson = Father

      OR AllRelations.RelationWithPerson = Mother)

    #   Get all the children from these specific persons who are either father or mother

    INNER JOIN persons Children

      ON AllRelations.RelationPerson = Children.PersonID

  #Get all partners of the above found children

  ORDER BY Children.PersonDateOfBirth;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllChildrenFromFatherAndOrMotherWithPartners` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllChildrenFromFatherAndOrMotherWithPartners`(IN `Father` int(11), IN `Mother` int(11))
    SQL SECURITY INVOKER
    COMMENT 'Gets all children from a specific father and/or mother and show'
BEGIN

  SELECT DISTINCT

    CONCAT(Children.PersonGivvenName, ' ', Children.PersonFamilyName) AS 'Naam kind',

    Partner.PartNaam AS 'Naam partner van kind'

  FROM relations AllRelations

    #   Get all records from relations from specific persons who are either father or mother

    INNER JOIN relationnames IsChild

      ON AllRelations.RelationName = IsChild.RelationNameID

      AND (IsChild.RelationnameName = 'Vader'

      OR IsChild.RelationnameName = 'Moeder')

      AND (AllRelations.RelationWithPerson = Father

      OR AllRelations.RelationWithPerson = Mother)

    #   Get all the children from these specific persons who are either father or mother

    INNER JOIN persons Children

      ON AllRelations.RelationPerson = Children.PersonID

    #Get all partners of the above found children

    LEFT JOIN (SELECT

        AllPartners.RelationPerson AS LinkToPartner,

        CONCAT(Partner.PersonGivvenName, ' ', Partner.PersonFamilyName) AS PartNaam

      FROM relations AllPartners

        INNER JOIN relationnames IsPartner

          ON AllPartners.RelationName = IsPartner.RelationnameID

          AND IsPartner.RelationnameName = 'Partner'

        INNER JOIN persons Partner

          ON AllPartners.RelationWithPerson = Partner.PersonID) AS Partner

      ON Children.PersonID = Partner.LinkToPartner

  ORDER BY Children.PersonDateOfBirth;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllChildrenWithoutPartnerFromBothParents` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllChildrenWithoutPartnerFromBothParents`(IN `Father` int(11), IN `Mother` int(11))
    SQL SECURITY INVOKER
    COMMENT 'To get all children from a two specific parents and without the partner'
BEGIN

SELECT DISTINCT * FROM persons 
	WHERE PersonID IN 
	(SELECT RelationPerson FROM relations
		WHERE (RelationWithPerson = Father OR RelationWithPerson = Mother)
        AND (RelationName = 1 OR RelationName = 2));
  
#  SELECT DISTINCT
#
#    CONCAT(Children.PersonGivvenName, ' ', Children.PersonFamilyName) AS 'Naam kind'
#
 # FROM relations AllRelations

    #   Get all records from RELATIONS from specific persons who are either father or mother

 #   INNER JOIN relationnames IsChild

 #     ON AllRelations.RelationName = IsChild.RelationNameID

 #     AND (IsChild.RelationnameName = 'Vader' AND AllRelations.RelationWithPerson = Father)

 #     OR (IsChild.RelationnameName = 'Moeder' AND AllRelations.RelationWithPerson = Mother)

    #   Get all the children from these specific persons who are either father or mother

 #   INNER JOIN persons Children

 #     ON AllRelations.RelationPerson = Children.PersonID

  # Get all partners of the above found children

 # ORDER BY Children.PersonDateOfBirth;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllChildrenWithoutPartnerFromBothPartners` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllChildrenWithoutPartnerFromBothPartners`(IN `Father` int(11), IN `Mother` int(11))
    SQL SECURITY INVOKER
    COMMENT 'To get all children from a specific parent and without the partn'
BEGIN

  SELECT DISTINCT

    CONCAT(Children.PersonGivvenName, ' ', Children.PersonFamilyName) AS 'Naam kind'

  FROM relations AllRelations

    #   Get all records from RELATIONS from specific persons who are either father or mother

    INNER JOIN relationnames IsChild

      ON AllRelations.RelationName = IsChild.RelationNameID

      AND (IsChild.RelationnameName = 'Vader'

      OR IsChild.RelationnameName = 'Moeder')

      AND (AllRelations.RelationWithPerson = Father

      OR AllRelations.RelationWithPerson = Mother)

    #   Get all the children from these specific persons who are either father or mother

    INNER JOIN persons Children

      ON AllRelations.RelationPerson = Children.PersonID

  #Get all partners of the above found children

  ORDER BY Children.PersonDateOfBirth;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllChildrenWithoutPartnerFromOneParent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllChildrenWithoutPartnerFromOneParent`(IN `ParentIn` int(11))
    SQL SECURITY INVOKER
    COMMENT 'To get all children from a specific parent and without the partner'
BEGIN

	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = 

    -- 2 = Transaction aborted due to problems during update and rollback performed

    -- ...

    DECLARE CompletedOk int;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo int;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult int;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetAllChildrenWithoutPartnerFromOneParent(). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN

    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("GetAllChildrenWithoutPartnerFromOneParent");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: GetAllChildrenWithoutPartnerFromOneParent() voor persoon met ID= ', IFNULL(ParentIn, 'null')),

		TestLogDateTime = NOW();

IF ParentIn IS null THEN
	
    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Error SPROC: GetAllChildrenWithoutPartnerFromOneParent(), ParentIn should NOT be null but IS null.'),

		TestLogDateTime = NOW();

ELSE

	SELECT DISTINCT * FROM persons 
	WHERE PersonID IN 
	(SELECT RelationPerson FROM relations
		WHERE RelationWithPerson = ParentIn
        AND (RelationName = 1 OR RelationName = 2));

  SET TransResult = TransResult + 1;

  SET RecCount = FOUND_ROWS();

  INSERT INTO humans.testlog 

  SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC: GetAllChildrenWithoutPartnerFromOneParent() voor persoon met ID= ', ParentIn, '. CompletedOk= ', CompletedOk, '. Children found=', RecCount),

		TestLogDateTime = NOW();
        
END IF;

END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllChildrenWithPartnerFromBothPartners` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllChildrenWithPartnerFromBothPartners`(IN `Father` int(11), IN `Mother` int(11))
    SQL SECURITY INVOKER
    COMMENT 'Gets all children from a specific father and/or mother and show'
BEGIN

  SELECT DISTINCT

    CONCAT(Children.PersonGivvenName, ' ', Children.PersonFamilyName) AS 'Naam kind',

    Partner.PartNaam AS 'Naam partner van kind'

  FROM relations AllRelations

    #   Get all records from RELATIONS from specific persons who are either father or mother

    INNER JOIN relationnames IsChild

      ON AllRelations.RelationName = IsChild.RelationNameID

      AND (IsChild.RelationnameName = 'Vader'

      OR IsChild.RelationnameName = 'Moeder')

      AND (AllRelations.RelationWithPerson = Father

      OR AllRelations.RelationWithPerson = Mother)

    #   Get all the children from these specific persons who are either father or mother

    INNER JOIN persons Children

      ON AllRelations.RelationPerson = Children.PersonID

    #Get all partners of the above found children

    LEFT JOIN (SELECT

        AllPartners.RelationPerson AS LinkToPartner,

        CONCAT(Partner.PersonGivvenName, ' ', Partner.PersonFamilyName) AS PartNaam

      FROM relations AllPartners

        INNER JOIN relationnames IsPartner

          ON AllPartners.RelationName = IsPartner.RelationnameID

          AND IsPartner.RelationnameName = 'Partner'

        INNER JOIN persons Partner

          ON AllPartners.RelationWithPerson = Partner.PersonID) AS Partner

      ON Children.PersonID = Partner.LinkToPartner

  ORDER BY Children.PersonDateOfBirth;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllChildrenWithPartnerFromOneParent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllChildrenWithPartnerFromOneParent`(IN `TheParent` int(11))
    SQL SECURITY INVOKER
    COMMENT 'Gets all children (with their partners) from a specific parent a'
BEGIN
-- CompletedOk defines the result of a database transaction, like this:
    -- 0 = Transaction finished without problems.
    -- 1 = 
    -- 2 = Transaction aborted due to problems during update and rollback performed
    -- ...

    DECLARE CompletedOk int;

    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table
	DECLARE NewTransNo int;

    -- TransResult is used to count the number of seperate database operations and rissen with each step
	DECLARE TransResult int;

    -- RecCount is used to count the number of related records in depended tables.
	DECLARE RecCount int;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET CompletedOk = 2;
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetAllChildrenWithPartnerFromOneParent(). Rollback executed. CompletedOk= ", CompletedOk),
				TestLogDateTime = NOW();
		-- SELECT CompletedOk;
	END;

main_proc:

BEGIN
               
	SET CompletedOk = 0;

    SET TransResult = 0;



    SET NewTransNo = GetTranNo("GetAllChildrenFromOneParentWithPartner");
    
    	INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Start SPROC GetAllChildrenWithPartnerFromOneParent() with Partent is: ", IFNULL(TheParent, 'null')),
				TestLogDateTime = NOW();

    
  SELECT DISTINCT

    CONCAT(Children.PersonGivvenName, ' ', Children.PersonFamilyName) AS 'Kind',

    Children.PersonID AS 'KindId',
    
    Children.PersonDateOfBirth as 'KindDateOfBirth',

    Partner.PartNaam AS 'Partner'

  FROM relations AllRelations

    #   Get all records from relations from specific persons who are either father or mother
    

    INNER JOIN relationnames IsChild

      ON AllRelations.RelationName = IsChild.RelationNameID

      AND (IsChild.RelationnameName = 'Vader'

      OR IsChild.RelationnameName = 'Moeder')

      AND AllRelations.RelationWithPerson = TheParent

    #   Get all the children from these specific persons who are either father or mother

    INNER JOIN persons Children

      ON AllRelations.RelationPerson = Children.PersonID

    #Get all partners of the above found children

    LEFT JOIN (SELECT

        AllPartners.RelationPerson AS LinkToPartner,

        CONCAT(Partner.PersonGivvenName, ' ', Partner.PersonFamilyName) AS PartNaam

      FROM relations AllPartners

        INNER JOIN relationnames IsPartner

          ON AllPartners.RelationName = IsPartner.RelationnameID

          AND IsPartner.RelationnameName = 'Partner'

        INNER JOIN persons Partner

          ON AllPartners.RelationWithPerson = Partner.PersonID) AS Partner

      ON Children.PersonID = Partner.LinkToPartner

  ORDER BY KindDateOfBirth;
    SET TransResult = TransResult + 1 ;

    SET RecCount = FOUND_ROWS();

    -- SELECT CompletedOk, RecCount AS Kinderengevonden;
 
	INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "End SPROC GetAllChildrenWithPartnerFromOneParent() with Parent is: ", IFNULL(TheParent, 'null')),
				TestLogDateTime = NOW();

 END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllFamilyCouples` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllFamilyCouples`(IN `YearFrom` INT(4), IN `FamilyName` VARCHAR(50))
    SQL SECURITY INVOKER
    COMMENT 'To get all couples or couples with a specific familyname'
BEGIN

SELECT DISTINCT

    CONCAT(Person.PersonGivvenName, ' ', Person.PersonFamilyName) AS 'Person',

    Person.PersonID AS 'PersonID',

    CONCAT(Partner.PersonGivvenName, ' ', Partner.PersonFamilyName) AS 'Partner',

    Partner.PersonID AS 'PartnerID'

  FROM relations AllRelations

    #   Get all records from relations which define partnership

    INNER JOIN relationnames IsPartner

      ON AllRelations.RelationName = IsPartner.RelationNameID

      AND IsPartner.RelationnameName = 'Partner'

    #   Get the first partner 

    INNER JOIN persons Person

      ON AllRelations.RelationPerson = Person.PersonID

  # Get the second partner

    INNER JOIN persons Partner

      ON AllRelations.RelationWithPerson = Partner.PersonID  

  WHERE Person.PersonFamilyName LIKE CONCAT(FamilyName, '%')

  AND YEAR(Person.PersonDateOfBirth) >= YearFrom

  ORDER BY Person.PersonFamilyName, Person.PersonDateOfBirth;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllParentCouples` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllParentCouples`(IN `FamilyName` varchar(50))
    SQL SECURITY INVOKER
    COMMENT 'To get all parents'
BEGIN

  SELECT DISTINCT

    CONCAT(Parent1.PersonGivvenName, ' ', Parent1.PersonFamilyName) AS 'Parent 1',

    CONCAT(Parent2.PersonGivvenName, ' ', Parent2.PersonFamilyName) AS 'Parent 2'

  FROM relations AllRelations

    #   Get all records from relations which define partnership

    INNER JOIN relationnames IsParent

      ON AllRelations.RelationName = IsParent.RelationNameID

      AND (IsParent.RelationnameName = 'Vader' OR IsParent.RelationnameName='Moeder')

    #   Get the first parent 

    INNER JOIN persons Parent1

      ON AllRelations.RelationPerson = Parent1.PersonID

    # Get the second parent

    INNER JOIN persons Parent2

      ON AllRelations.RelationWithPerson = Parent2.PersonID;

#  WHERE Parent1.PersonFamilyName LIKE CONCAT(FamilyName, '%')

#    OR Parent2.PersonFamilyName LIKE CONCAT (FamilyName, '%')

#  ORDER BY Parent1.PersonFamilyName, Parent1.PersonDateOfBirth;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetAllPersonsWithPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetAllPersonsWithPartner`(IN `YearFrom` INT(4), IN `FamilyName` VARCHAR(50))
    SQL SECURITY INVOKER
    COMMENT 'To get all persons with a specific familyname and their partner'
BEGIN

-- CompletedOk defines the result of a database transaction, like this:
    -- 0 = Transaction finished without problems.
    -- 1 = 
    -- 2 = Transaction aborted due to problems during update and rollback performed
    -- ...
    DECLARE CompletedOk int;

    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table
	DECLARE NewTransNo int;

    -- TransResult is used to count the number of seperate database operations and rissen with each step
	DECLARE TransResult int;

    -- RecCount is used to count the number of related records in depended tables.
	DECLARE RecCount int;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET CompletedOk = 2;
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetAllPersonsWithPartner(). Rollback executed. CompletedOk= ", CompletedOk),
				TestLogDateTime = NOW();
		SELECT CompletedOk;
	END;

main_proc:
	BEGIN
		SET CompletedOk = 0;

		SET TransResult = 0;

		SET NewTransNo = GetTranNo("GetAllPersonsWithPartner");

		-- Schrijf start van deze SQL transactie naar log
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: GetAllPersonsWithPartner() voor personen geboren ná: ', YearFrom, ' en met familienaam: ', IFNULL(FamilyName, 'alle')),
			TestLogDateTime = NOW();

		
        SELECT DISTINCT

		CONCAT(P.PersonGivvenName, ' ', P.PersonFamilyName) AS 'Person', 

		P.PersonID as 'PersonID',

		T.Partner as 'Partner',

		T.PartnerID as 'PartnerID'

		

		FROM persons P

		LEFT JOIN (

			SELECT 

				CONCAT(PA.PersonGivvenName, " ", PA.PersonFamilyName) as Partner, 

						PA.PersonID as PartnerID,

						R.RelationPerson, 

						RN.RelationnameName from relations R

						JOIN relationnames RN ON R.RelationName = RN.RelationnameID

						JOIN persons PA on R.RelationWithPerson = PA.PersonID

						WHERE RN.RelationnameName = "Partner") AS T on P.PersonID = T.RelationPerson

				WHERE P.PersonFamilyName LIKE CONCAT(FamilyName, '%')

				AND YEAR(P.PersonDateOfBirth) >= YearFrom

				ORDER BY P.PersonFamilyName, P.PersonDateOfBirth;
         
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC: GetAllPersonsWithPartner()'),
			TestLogDateTime = NOW();       
                

		END;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetFamilieDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetFamilieDetails`(IN `PersonIdIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'To get the family details (Father, Mother, Partner & Children) of a person based on the person''s PersonID.'
BEGIN

	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = 

    -- 2 = Transaction aborted due to problems during update and rollback performed

    -- ...

    DECLARE CompletedOk int;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo int;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult int;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetFamilyDetails(). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN

    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("GetFamilyDetails");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: GetFamilyDetails() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    CALL GetFather(PersonIdIn);

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. SPROC: GetFamilyDetails(), Vader opgehaald via GetFather() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();

    

    CALL GetMother(PersonIdIn);

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. SPROC: GetFamilyDetails(), Moeder opgehaald via GetMother() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    CALL GetPartner(PersonIdIn);

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. SPROC: GetFamilyDetails(), Partner opgehaald via GetPartner() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    CALL GetAllChildrenWithoutPartnerFromOneParent(PersonIdIn);

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. SPROC: GetFamilyDetails(), Kinderen opgehaald via GettAllChildrenWithoutPartnerFromOneParent() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    SELECT CompletedOk;

END ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetFamilyTree` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetFamilyTree`(PersonToStartWith int, NumberOfGenerationsToGoUp int, NumberOfGenerationsToGoDown int, InclusivePartners bool)
BEGIN
	-- ----------------------------------------------------------------------------------------------------------------------------------------------
    -- Author: 	Frans Dekkers (GoNomics)
    -- Date:	25-12-2019
    -- -----------------------------------
    -- Prurpose of this Sproc:
    -- Build a temporary table to contain the family tree of a specific person (= 'PersonToStartWith')
    -- Return this family tree to frond-end programs and apps in order to be able to manage the family tree of the requested person
    -- Intends to (initialy) feed the Genealogy app written by Frans Dekkers
    -- 
    -- Parameters of this Sproc:
    -- 'PersonToStartWith'= Person to build the family tree for
    -- 'NumberOfGenerationsToGoUp'= determines to which level ancestors of 'PersonToStartWith'will be included in the family tree
    -- 'NumberOfGenerationsToGoDown'= determines to which level (grand) childen of 'PersonToStartWith' will be included in the family tree
    -- 'InclusivePartners'= determines whether or not partners of (grand) childern of 'PersonToStartWith' will be included in the family tree
    --						this parameters also determines if partner of 'PersonToStartWith'(and partner's children) will be included
    -- 
    -- High level flow of this Sproc:
    -- => Create a temporary table "FamilyTree" to hold the family tree build based on the passed parameters
    -- => In this temporary table first store basic details for 'PersonToStartWith'
    -- => Then create a cursor to first traverse through this temporary table to get (from humans tabels) and store (in temporary FamilyTree table) the
    -- 	  basic details for the ancestors of 'PersonToStartWith'
    -- => Then use the cursor to traverse through this temporary table to get (from humans tables) and store (in temporary FamilyTree table) the
    --	  basic details for (grand) children of 'PerSonToStartWith'
    -- => Last but not least return the temporary table to the requesting Front-end app / program- or middleware API
    
    -- Notes:	The 'humans' database will include "all" humans, this Sproc will just deliver a subset of this based on the parameters as filled 
    -- 			in by the requesting frond-end or API middleware.
    --
    --			Adapted a "trick" to prevent persons form geeting added to the FamilyTree more then once as follows:
    --				Added "UNIQUE" to PersonId in creating temporary table FamilyTree and added "IGNORE" when inserting records into table FamilyTree.
    --				This in effect results in a warning when (trying) to add duplicate PersonId's and at the same time these record not being added.
    --		
    -- TODO's:
    -- => 25/12/19 Check if not much more efficient to use table 'relations'with some filters applied depended on input param's of this Sproc.
    -- => 27/12/19 GenerationCounter does not work as desired (counting of ancestor levels goes wrong). Repair.
    -- => 21/12/10 Replace where possible functions, fGetMother(), fGetFather() and fGetPartner() with proper SELECT FROM <relations table> and <relationname table>
    -- => 01/01/20 Change current quick & dirty solution which is now used to make ceratin all RecordId's are found, even if nbr of RecordId's <> nbr or records in FamilyTree
    --             The current quick & dirty solution is to just go throught the loop a couple of more times then that there are records
    -- => 01/01/20 Procedure aanpassen om de partners te vinden van kinderen tijdens de inleiding naar de loop. Nu werkt het alleen in geval er maar een kind is
    --             en gaat het (waarschijnlijk) mis als er meerdere kinderen zijn. 
    -- ----------------------------------------------------------------------------------------------------------------------------------------------
    
    
	DECLARE GenerationStartingLevel INT DEFAULT 0;
    DECLARE GenerationCounter INT;
    DECLARE pMother INT;
    DECLARE MotherAsNExtPerson INT;
    DECLARE FatherAsNextPerson INT;
    DECLARE PartnerAsNextPerson INT;
    DECLARE pFather INT;
    DECLARE pPartner INT;
    DECLARE pPersonsParentsPartners INT;
    DECLARE FatherFoundAsPerson BOOL;
    DECLARE MotherFoundAsPerson BOOL;
    DECLARE NextPerson INT;
    DECLARE NextPersonToGetChildrenFor INT;
    DECLARE PersonToFindBack INT;
    DECLARE PartnerToFindBack INT;
    DECLARE CompletedOk INT;
    DECLARE NewTransNo INT;
    DECLARE TransResult INT;
    DECLARE PersonAlreadyInFamilyTree INT;
    DECLARE RecordIndex INT;
	
    
    SET CompletedOk = true;
    SET TransResult = 0;
    SET NewTransNo = GetTranNo("GetFamilyTree");
    
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
        '. TransResult= ', IFNULL(TransResult, ''),
        '. Start SPROC: GetFamilyTree() voor persoon met ID= ', IFNULL(PersonToStartWith, 'null'),
        '. Number of generations to go up= ', IFNULL(NumberOfGenerationsToGoUp, 'null'),
        '. Number of generations to go down= ', IFNULL(NumberOfGenerationsToGoDown, 'null'),
        '. Include partner= ', IFNULL(InclusivePartners, 'null')),
		TestLogDateTime = NOW();

     -- Get/set details from the givven person him/herself in the temporary table
     INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
			'. TransResult= ', IFNULL(TransResult, ''),
			'. Opslaan data voor persoon met ID= ', IFNULL(PersonToStartWith, 'null')),
			TestLogDateTime = NOW();
    CREATE TEMPORARY TABLE IF NOT EXISTS FamilyTree(
		RecordId  INT NOT NULL AUTO_INCREMENT,
        PersonId INT NOT NULL UNIQUE,
        PersonName CHAR(50),
        PersonIsMale BOOL,
        PersonBirth DATE,
        PersonDeath DATE,
        PersonsFather INT,
        FatherFetched BOOL,
        PersonsMother INT,
        MotherFetched BOOL,
        PersonsParentsArePartners BOOL,
        PersonsPartner INT,
        PartnerFetched BOOL,
        PRIMARY KEY (RecordId, PersonId))
	AS       
      select PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, PersonIsMale FROM persons where persons.PersonId = PersonToStartWith;
     
    SET pMother = fGetMother(PersonToStartWith);
	SET pFather = fGetFather(PersonToStartWith);
	SET pPartner = fGetPartner(PersonToStartWith);  
	UPDATE FamilyTree SET PersonsFather = pFather, FatherFetched = false, PersonsMother = pMother, MotherFetched=false, PersonsPartner = pPartner, PartnerFetched=false, PersonsParentsArePartners = pPersonsParentsPartners WHERE (PersonId = PersonToStartWith AND RecordId <> 0);
    
	-- Loop to get the familytree about the givven person, going up the familytree
    SET GenerationCounter = GenerationStartingLevel + 1;
    SET RecordIndex = 1;
    
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. =====>> Going up! Getting all ancestors (up until requested ancestor level)'),
						TestLogDateTime = NOW();
    
    going_up: LOOP
    
		-- FDE 27-12-2019 Note (!):
        -- Apparently a "SELECT <somefields> INTO <somevars> does not combine with EXIST, hence split it into two seperate lines / commands
        IF EXISTS (SELECT RecordId FROM FamilyTree WHERE RecordId = RecordIndex) THEN 
			SELECT PersonsFather, PersonsMother, PersonsPartner INTO @FatherAsNextPerson, @MotherAsNextPerson, @PartnerAsNextPerson FROM FamilyTree WHERE RecordId = RecordIndex;
    
			-- Find details of the Mother of previous person
            IF ! ISNULL(@MotherAsNextPerson) THEN
				SELECT COUNT(*) FROM FamilyTree WHERE PersonId = @MotherAsNextPerson LIMIT 1 INTO PersonAlreadyInFamilyTree;
				IF PersonAlreadyInFamilyTree = 0 THEN
					INSERT INTO humans.testlog 
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. Begin opslaan data voor persoon met ID= ', IFNULL(@MotherAsNextPerson, 'null')),
						TestLogDateTime = NOW();
					INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonIsMale)
						SELECT PersonId, CONCAT(PersonGivvenName, " ", PersonFamilyName), PersonDateOfBirth, PersonDateOfDeath, PersonIsMale FROM persons WHERE persons.PersonId = @MotherAsNextPerson;
					SET pMother = fGetMother(@MotherAsNextPerson);
					SET pFather = fGetFather(@MotherAsNextPerson);
					SET pPartner = fGetPartner(@MotherAsNextPerson);  
					UPDATE FamilyTree SET PersonsFather = pFather, FatherFetched = false, PersonsMother = pMother, MotherFetched=false, PersonsPartner = pPartner, PartnerFetched=false, PersonsParentsArePartners = pPersonsParentsPartners WHERE (PersonId = @MotherAsNextPerson AND RecordId <> 0);
					INSERT INTO humans.testlog
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. Gegevens opgeslagen voor persoon met ID= ', IFNULL(@MotherAsNextPerson, 'null')),
						TestLogDateTime = NOW();
				END IF;
			END IF; 
        
			-- Find details of the Father of previous person
			IF ! ISNULL(@FatherAsNextPerson) THEN
				SELECT COUNT(*) FROM FamilyTree WHERE PersonId = @FatherAsNextPerson LIMIT 1 INTO PersonAlreadyInFamilyTree;
				IF PersonAlreadyInFamilyTree = 0 THEN
					INSERT INTO humans.testlog
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. Begin opslaan data voor persoon met ID= ', IFNULL(@FatherAsNextPerson, 'null')),
						TestLogDateTime = NOW();
					INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonIsMale)
						SELECT PersonId, CONCAT(PersonGivvenName, " ", PersonFamilyName), PersonDateOfBirth, PersonDateOfDeath, PersonIsMale FROM persons WHERE persons.PersonId = @FatherAsNextPerson;
					SET pMother = fGetMother(@FatherAsNextPerson);
					SET pFather = fGetFather(@FatherAsNextPerson);
					SET pPartner = fGetPartner(@FatherAsNextPerson);  
					UPDATE FamilyTree SET PersonsFather = pFather, FatherFetched = false, PersonsMother = pMother, MotherFetched=false, PersonsPartner = pPartner, PartnerFetched=false, PersonsParentsArePartners = pPersonsParentsPartners WHERE (PersonId = @FatherAsNextPerson AND RecordId <> 0);
					INSERT INTO humans.testlog
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. Gegevens opgeslagen voor persoon met ID= ', IFNULL(@FatherAsNextPerson, 'null')),
						TestLogDateTime = NOW();
				END IF;
			END IF;
        
			-- Find details of the Partner of previous person (if SPROC parameter 'InclusivePartners' set to yes
			IF InclusivePartners = 1 THEN
				IF ! ISNULL(@PartnerAsNextPerson) THEN
					SELECT COUNT(*) FROM FamilyTree WHERE PersonId = @PartnerAsNextPerson LIMIT 1 INTO PersonAlreadyInFamilyTree;
					IF PersonAlreadyInFamilyTree = 0 THEN
						INSERT INTO humans.testlog
							SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
							'. TransResult= ', IFNULL(TransResult, ''),
							'. Begin opslaan data voor persoon met ID= ', IFNULL(@PartnerAsNextPerson, 'null')),
							TestLogDateTime = NOW();
						INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonIsMale)
							SELECT PersonId, CONCAT(PersonGivvenName, " ", PersonFamilyName), PersonDateOfBirth, PersonDateOfDeath, PersonIsMale FROM persons WHERE persons.PersonId = @PartnerAsNextPerson;
						SET pMother = fGetMother(@PartnerAsNextPerson);
						SET pFather = fGetFather(@PartnerAsNextPerson);
						SET pPartner = fGetPartner(@PartnerAsNextPerson);  
						UPDATE FamilyTree SET PersonsFather = pFather, FatherFetched = false, PersonsMother = pMother, MotherFetched=false, PersonsPartner = pPartner, PartnerFetched=false, PersonsParentsArePartners = pPersonsParentsPartners WHERE (PersonId = @PartnerAsNextPerson AND RecordId <> 0);
						INSERT INTO humans.testlog
							SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
							'. TransResult= ', IFNULL(TransResult, ''),
							'. Gegevens opgeslagen voor persoon met ID= ', IFNULL(@PartnerAsNextPerson, 'null')),
							TestLogDateTime = NOW();
					END IF;
				END IF;
			END IF;
			-- SET GenerationCounter = GenerationCounter + 1; 
		ELSE
			LEAVE going_up;
		END IF;
        
        SET GenerationCounter = GenerationCounter + 1;
        SET RecordIndex = RecordIndex + 1;
     
        IF GenerationCounter >= NumberOfGenerationsToGoUp THEN
			LEAVE going_up;
		END IF;
    END LOOP going_up;
    
    -- SET REcordIndex = RecordIndex + 1;
    
	INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
			'. TransResult= ', IFNULL(TransResult, ''),
			'. =====>> Going down! Getting all (grand) children (down to the requested level) for person= ', IFNULL(PersonToStartWith, 'null')),
			TestLogDateTime = NOW();
   

	INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonsFather, PersonsMother, PersonsPartner, PersonIsMale)
		SELECT DISTINCT PersonID as PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, fGetFather(PersonID) AS PersonsFather, fGetMother(PersonID) AS PersonsMother, fGetPartner(PersonID) as PersonsPartner, PersonIsMale FROM persons 
			WHERE PersonID IN 
				(SELECT RelationPerson FROM relations
				WHERE RelationWithPerson = PersonToStartWith 
				AND (RelationName = 1 OR RelationName = 2));
                  
	IF InclusivePartners = 1 THEN
		
        INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ----->> Before inclusive partner. RecordIndex= ', IFNULL(RecordIndex, 'null')),
					TestLogDateTime = NOW();
                    
		IF EXISTS (SELECT RecordId FROM FamilyTree WHERE RecordId = RecordIndex) THEN
			SELECT PersonId, PersonsPartner INTO @PersonToFindBack, @PartnerToFindBack FROM FamilyTree WHERE RecordId = RecordIndex;
            
			INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ----->> Before inclusive partner. Finding partner= ', IFNULL(@PartnerToFindBack, 'null'), ' for person= ', IFNULL(@PersonToFindBack, 'null')),
					TestLogDateTime = NOW();
    

			INSERT INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonsFather, PersonsMother, PersonIsMale)
			SELECT DISTINCT PersonID as PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, fGetFather(PersonID) AS PersonsFather, fGetMother(PersonID) AS PersonsMother, PersonIsMale 
				FROM persons JOIN relations ON persons.PersonID = relations.RelationWithPerson 
					WHERE RelationPerson =  @PersonToFindBack
						AND RelationWithPerson = @PartnerToFindBack 
						AND RelationName = 3;
               
			INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ----->> After inclusive partner'),
					TestLogDateTime = NOW();
                   
		END IF;
	END IF;
   
   SET GenerationCounter = GenerationStartingLevel + 1;
                    
	-- Loop to get the familitree about the givven person, going down the familytree
    going_down: LOOP
    
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
				'. TransResult= ', IFNULL(TransResult, ''),
				'. ++++++++++++++++=> Looping. Top of loop. RecordIndex= ', IFNULL(RecordIndex, 'null'), '. RowCount=',  RowCountForFamilyTree()),
				TestLogDateTime = NOW();
    
		-- FDE 2020: This is the DIRTY solution
        IF RecordIndex <= (RowCountForFamilyTree() + 5) THEN 
        
			INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ++++++++++++++++=> Looping. First step of loop. RecordIndex= ', IFNULL(RecordIndex, 'null'), '. RowCount=',  RowCountForFamilyTree()),
					TestLogDateTime = NOW();
        
 			SELECT DISTINCT PersonId from FamilyTree WHERE RecordId = RecordIndex LIMIT 1 INTO NextPersonToGetChildrenFor; 
            
            IF NextPersonToGetChildrenFor = 0 THEN
				INSERT INTO humans.testlog 
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. ++++++++++++++++=> Looping. NextPersonToGetChildrenFor IS NULL'),
						TestLogDateTime = NOW();
				
            ELSE
            
				INSERT INTO humans.testlog 
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
					'. TransResult= ', IFNULL(TransResult, ''),
					'. ++++++++++++++++=> Looping. Second step. Finding the (grand)children for grandfather/mother= ', IFNULL(PersonToStartWith, 'null'), ' and father/mother (NextPersonTogetChildrenFor)=', IFNULL(NextPersonToGetChildrenFor, 'null'), ' WITHOUT the partners of the (grand)children.'),
					TestLogDateTime = NOW();
				
				INSERT IGNORE INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonsFather, PersonsMother, PersonsPartner, PersonIsMale)
				SELECT DISTINCT PersonID as PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, fGetFather(PersonID) AS PersonsFather, fGetMother(PersonID) AS PersonsMother, fGetPartner(PersonID) as PersonsPartner, PersonIsMale FROM persons 
					WHERE PersonID IN 
						(SELECT RelationPerson FROM relations
						 WHERE RelationWithPerson = NextPersonToGetChildrenFor 
						 AND (RelationName = 1 OR RelationName = 2));
                         
                         
				IF InclusivePartners = 1 THEN
					INSERT INTO humans.testlog 
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
						'. TransResult= ', IFNULL(TransResult, ''),
						'. ++++++++++++++++=> Looping. Second step. Finding the partners for the (grand)children of grandfather/mother= ', IFNULL(PersonToStartWith, 'null'), ' and father/mother (NextPersonTogetChildrenFor)=', IFNULL(NextPersonToGetChildrenFor, 'null')),
						TestLogDateTime = NOW();
                        
                        
					
                    INSERT IGNORE INTO FamilyTree (PersonId, PersonName, PersonBirth, PersonDeath, PersonsFather, PersonsMother, PersonsPartner, PersonIsMale)
					SELECT DISTINCT PersonID as PersonId,  CONCAT(PersonGivvenName, " ", PersonFamilyName) as PersonName,  PersonDateOfBirth as PersonBirth, PersonDateOfDeath as PersonDeath, fGetFather(PersonID) AS PersonsFather, fGetMother(PersonID) AS PersonsMother, fGetPartner(PersonID) as PersonsPartner, PersonIsMale FROM persons 
					WHERE PersonID IN   
						(SELECT DISTINCT RelationPerson FROM relations WHERE RelationName = 3 AND RelationWithPerson IN
							(SELECT RelationPerson FROM relations
							WHERE RelationWithPerson = NextPersonToGetChildrenFor 
							AND (RelationName = 1 OR RelationName = 2)));
					
                        
				END IF;
				SET NextPersonToGetChildrenFor = 0;
 			END IF;
			SET RecordIndex = RecordIndex  + 1;      
		ELSE 
			LEAVE going_down;
        END IF;
        -- SET RecordIndex = RecordIndex  + 1;
		SET GenerationCounter = GenerationCounter + 1;
        IF GenerationCounter = NumberOfGenerationsToGoDown THEN
				LEAVE going_down;
		END IF;
    END LOOP going_down;
    
    SELECT * FROM FamilyTree;
    
    DROP TEMPORARY TABLE FamilyTree;
    
    INSERT INTO humans.testlog 
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
				'. TransResult= ', IFNULL(TransResult, ''),
				'. Einde SPROC: GetFamilyTRee() voor persoon met ID= ', IFNULL(PersonToStartWith, 'null')),
				TestLogDateTime = NOW();
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetFather` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetFather`(IN `PersonIdIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'To get the father of a person based on the persons ID'
BEGIN
	-- CompletedOk defines the result of a database transaction, like this:
    -- 0 = Transaction finished without problems.
    -- 1 = 
    -- 2 = Transaction aborted due to problems during update and rollback performed
    -- ...


    DECLARE CompletedOk int;

    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table
	DECLARE NewTransNo int;

    -- TransResult is used to count the number of seperate database operations and rissen with each step
	DECLARE TransResult int;

    -- RecCount is used to count the number of related records in depended tables.
	DECLARE RecCount int;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET CompletedOk = 2;
		INSERT INTO humans.testLog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetFather(). Rollback executed. CompletedOk= ", CompletedOk),
				TestLogDateTime = NOW();
		SELECT CompletedOk;
	END;

main_proc:

BEGIN

    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("GetFather");
    
    
    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC GetFather() voor persoon met ID= ', IFNULL(PersonIdIn, 'null')),

		TestLogDateTime = NOW();

IF PersonIdIn IS null THEN
	
    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Error end SPROC GetFather(), PersonIdIn should NOT be null but IS null.'),

		TestLogDateTime = NOW();

ELSE

	SELECT DISTINCT
 
    P.PersonID as FatherId, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as Father

    FROM persons P 

    WHERE P.PersonID = 

		(SELECT DISTINCT 

         RelationWithPerson

		 FROM relations R

		 JOIN (relationnames RN, persons P)

		 ON (R.RelationName = RN.RelationnameID AND 

			 P.PersonID = R.RelationPerson AND 

			 RN.RelationnameName = "Vader")

		 WHERE P.PersonID = PersonIdIn);

    SET TransResult = TransResult + 1 ;

    SET RecCount = FOUND_ROWS();

# 	Commented out on 24-11-2019 in order to only return result set (empty or not) and no accompanying seperate metadata anymore
#   This in order to simplify handlig of the result in API middlware and/or end user apps (as far as the later consumes the result directly
#   SELECT CompletedOk, RecCount AS VaderGevonden;
 
    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC GetFather() voor persoon met ID= ', PersonIdIn, '. CompletedOk= ', CompletedOk, '. Vader gevonden=', RecCount),

		TestLogDateTime = NOW();
        
END IF;

 END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetMother` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetMother`(IN `PersonIdIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'To get the mother of a person based on the persons ID'
BEGIN



	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = 

    -- 2 = Transaction aborted due to problems during update and rollback performed

    -- ...

    DECLARE CompletedOk int;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo int;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult int;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testLog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetMother(). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN

    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("GetMother");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: GetMother() voor persoon met ID= ', IFNULL(PersonIdIn, 'null')),

		TestLogDateTime = NOW();


IF PersonIdIn IS null THEN

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Error end SPROC GetMother(), PersonIdIn should NOT be null but IS null.'),

		TestLogDateTime = NOW();

ELSE
	SELECT DISTINCT

    P.PersonID as MotherId, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as Mother
    
    FROM persons P 

    WHERE P.PersonID = 

		(SELECT DISTINCT 

         RelationWithPerson

		 FROM relations R

		 JOIN (relationnames RN, persons P)

		 ON (R.RelationName = RN.RelationnameID AND 

			 P.PersonID = R.RelationPerson AND 

			 RN.RelationnameName = "Moeder")

		 WHERE P.PersonID = PersonIdIn);

    SET TransResult = TransResult + 1 ;

    SET RecCount = FOUND_ROWS();

# 	Commented out on 24-11-2019 in order to only return result set (empty or not) and no accompanying seperate metadata anymore
#   This in order to simplify handlig of the result in API middlware and/or end user apps (as far as the later consumes the result directly
#    SELECT CompletedOk, RecCount as MoederGevonden;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC: GetMother() voor persoon met ID= ', PersonIdIn, '. CompletedOk= ', CompletedOk, '. Moeder gevonden=', RecCount),

		TestLogDateTime = NOW();
END IF;

 END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetPartner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetPartner`(IN `PersonIdIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'To get the partner of a person based on the persons ID'
BEGIN



	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = 

    -- 2 = Transaction aborted due to problems during update and rollback performed

    -- ...

    DECLARE CompletedOk int;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo int;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult int;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testLog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetPartner(). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN

    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("GetPartner");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: GetPartner() voor persoon met ID= ', IFNULL(PersonIdIn, 'null')),

		TestLogDateTime = NOW();

IF PersonIdIn IS null THEN
	
    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Error end SPROC GetPartner(), PersonIdIn should NOT be null but IS null.'),

		TestLogDateTime = NOW();

ELSE

	SELECT DISTINCT

    P.PersonID as PartnerId, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as Partner

    FROM persons P 

    WHERE P.PersonID = 

		(SELECT DISTINCT 

         RelationWithPerson

		 FROM relations R

		 JOIN (relationnames RN, persons P)

		 ON (R.RelationName = RN.RelationnameID AND 

			 P.PersonID = R.RelationPerson AND 

			 RN.RelationnameName = "Partner")

		 WHERE P.PersonID = PersonIdIn);
	
    SET TransResult = TransResult + 1 ;

    SET RecCount = FOUND_ROWS();

# 	Commented out on 24-11-2019 in order to only return result set (empty or not) and no accompanying seperate metadata anymore
#   This in order to simplify handlig of the result in API middlware and/or end user apps (as far as the later consumes the result directly
#   SELECT CompletedOk, RecCount AS VaderGevonden;
 
    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC GetPartner() voor persoon met ID= ', PersonIdIn, '. CompletedOk= ', CompletedOk, '. Partner gevonden=', RecCount),

		TestLogDateTime = NOW();
        
END IF;


 END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetPersonDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetPersonDetails`(IN `PersonIDin` INT(11))
    SQL SECURITY INVOKER
    COMMENT 'To get the details of a specific person'
BEGIN

SELECT DISTINCT

    

    P.PersonID, 

    P.PersonGivvenName,

    P.PersonFamilyName,

    P.PersonDateOfBirth,

    P.PersonPlaceOfBirth,

    P.PersonDateOfDeath,

    P.PersonPlaceOfDeath,

    P.PersonIsMale,

    P.Timestamp,

	M.MotherID,

    M.MotherName,

    F.FatherID,

    F.FatherName,

    PA.PartnerID,

    PA.PartnerName



	FROM relations R



	RIGHT JOIN (SELECT DISTINCT

		  *

          FROM persons P

          WHERE P.PersonID = PersonIDin) as P

          ON R.RelationPerson = P.PersonID    

   

	LEFT JOIN (SELECT DISTINCT

		  M.PersonID as MotherID,

          concat(M.PersonGivvenName, ' ', M.PersonFamilyName) as MotherName,

          RM.RelationPerson as RelationToChild 

		  FROM relations RM

          JOIN relationnames RNM ON RM.RelationName = RNM.RelationnameID AND RNM.RelationnameName = "Moeder"

          JOIN persons M ON RM.RelationWithPerson = M.PersonID

		  WHERE RM.RelationPerson = PersonIDin) as M

		  ON R.RelationPerson = M.RelationToChild

    

	LEFT JOIN (SELECT DISTINCT

		  F.PersonID as FatherID,

          concat(F.PersonGivvenName, ' ', F.PersonFamilyName) as FatherName,

          RF.RelationPerson as RelationToChild 

		  FROM relations RF

          JOIN relationnames RNF ON RF.RelationName = RNF.RelationnameID AND RNF.RelationnameName = "Vader"

          JOIN persons F ON RF.RelationWithPerson = F.PersonID

		  WHERE RF.RelationPerson = PersonIDin) as F

		  ON R.RelationPerson = F.RelationToChild   

    

	LEFT JOIN (SELECT DISTINCT

		  PA.PersonID as PartnerID,

          concat(PA.PersonGivvenName, ' ', PA.PersonFamilyName) as PartnerName,

          RP.RelationPerson as RelationToPartner 

		  FROM relations RP

          JOIN relationnames RNP ON RP.RelationName = RNP.RelationnameID AND RNP.RelationnameName = "Partner"

          JOIN persons PA ON RP.RelationWithPerson = PA.PersonID

		  WHERE RP.RelationPerson = PersonIDin) as PA

		  ON R.RelationPerson = PA.RelationToPartner   

          

    WHERE PersonID = PersonIDin;

 END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetPlainListOfPersons` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `GetPlainListOfPersons`(NameInLike char(30))
BEGIN
	-- ----------------------------------------------------------------------------------------------------------------------------------------------
    -- Author: 	Frans Dekkers (GoNomics)
    -- Date:	10-01-2019
    -- -----------------------------------
    -- Prurpose of this Sproc:
    -- Return a list with names of Persons in order to let user see if a person already exist before adding persons or to change or delete a person's data
    -- 
    -- Parameters of this Sproc:
    -- 'NameInLike'= String in used to find people who's name is like the givven string
    -- 
    -- High level flow of this Sproc:
    -- => Simply find all persons with a familyname that is like the gvven string and send back some basic data of the found persons
    --   
    -- Note:	None
    --		
    -- TODO's:
    -- => --/--/-- None
    -- ----------------------------------------------------------------------------------------------------------------------------------------------
    
    DECLARE CompletedOk INT;
    DECLARE NewTransNo INT;
    DECLARE TransResult INT;
	
    SET CompletedOk = true;
    SET TransResult = 0;
    SET NewTransNo = GetTranNo("GetPlainListOfPersons");
    
    SET NameInLike = CONCAT(NameInLike, '%');
    
    SELECT NameInLike;
    
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, ''),
							 '. Start SPROC: GetPlainListOfPersons(). Get all persons who s name is like:', IFNULL(NameInLike, 'null')),
			TestLogDateTime = NOW();
    
	SELECT PersonID, CONCAT(PersonFamilyName, ", ", PersonGivvenName) as Name, PersonDateOfBirth as Birth, PersonIsMale as Gender
	FROM persons
	WHERE PersonFamilyName LIKE NameInLike;
        
       
	INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), 
			'. TransResult= ', IFNULL(TransResult, ''),
			'. End SPROC: GetPlainListOfPersons(). Got all persons who s name is like: ', IFNULL(NameInLike, 'null')),
			TestLogDateTime = NOW();
   

	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getPossibleFathers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `getPossibleFathers`(IN `PersonIDin` INT(11))
    SQL SECURITY INVOKER
    COMMENT 'To get the possible fathers of a person based on the persons birthdate'
BEGIN

	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = Transaction aborted due to intermediate changes (possibly from other users) in the mean time

    -- 2 = Transaction aborted due to problems during update and rollback performed

    DECLARE CompletedOk int;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo int;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult int;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



	DECLARE FullNamePerson varchar(100);

	

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		-- SET MessageText = MESSAGE_TEXT;

		-- SET ReturnedSqlState = RETURNED_SQLSTATE;

		-- SET MySQLErrNo = MYSQL_ERRNO;

		-- GET CURRENT DIAGNOSTICS CONDITION 1 MessageText : MESSAGE_TEXT, ReturnedSqlState : RETURNED_SQLSTATE, MySqlErrNo : MYSQL_ERRNO;

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured. Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN



    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("getPossibleFathers");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start opbouwen tabel met mogelijke vaders voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



	SELECT DISTINCT

    

    -- Mogelijke vader:

    P.PersonID as PossibleFatherID, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossibleFather

    

    FROM persons P 



    -- Mogelijke vader moet man zijn

    WHERE P.PersonIsMale = true



    -- Minimale leeftijd waarop de mogelijke vader, vader is geworden is 15 (geboortedatum vaqder = geboordedatum kind - 15 jaar)

    AND YEAR(P.PersonDateOfBirth) 

		<  

		(SELECT YEAR(PersonDateOfBirth) - 15

        FROM persons 

        WHERE PersonID = PersonIDin)



    -- Maximale leeftijd waarop de mogelijke vader, vader is geworden is 50 jaar (geboortedatum vader = geboortedatum kind - 50 jaar)

	AND YEAR(P.PersonDateOfBirth) 

		>  

		(SELECT YEAR(PersonDateOfBirth) - 50

        FROM persons 

        WHERE PersonID = PersonIDin) 

        

	-- Mogelijke vader mag niet de partner zijn

    AND P.PersonID NOT IN 

		(SELECT RelationWithPerson

		 FROM relations R

		 JOIN (relationnames RN, persons P)

		 ON (R.RelationName = RN.RelationnameID AND 

			 P.PersonID = R.RelationPerson AND 

			 RN.RelationnameName = "Partner")

		 WHERE P.PersonID = PersonIDin)

           

    ORDER BY P.PersonDateOfBirth;

    

    INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Lijst met mogelijke vader afgerond.'),

				TestLogDateTime = NOW();

 END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getPossibleFathersBasedOnAge` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `getPossibleFathersBasedOnAge`(IN `PersonAgeIn` DATE)
    SQL SECURITY INVOKER
    COMMENT 'To get the possible fathers of a person based on the persons bir'
BEGIN

	SELECT DISTINCT

    

    P.PersonID as PossibleFatherID, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossibleFather

    

    FROM persons P 



    WHERE P.PersonIsMale = true

    AND YEAR(P.PersonDateOfBirth) < (YEAR(PersonAgeIn) - 15)

		

	AND YEAR(P.PersonDateOfBirth) > (YEAR(PersonAgeIn) - 50)

        

    ORDER BY P.PersonDateOfBirth;

 END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getPossibleMothers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `getPossibleMothers`(IN `PersonIDin` INT(11))
    SQL SECURITY INVOKER
    COMMENT 'To get the possible mothers of a person based on the persons id'
BEGIN

	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = Transaction aborted due to intermediate changes (possibly from other users) in the mean time

    -- 2 = Transaction aborted due to problems during update and rollback performed

    DECLARE CompletedOk int;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo int;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult int;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



	DECLARE FullNamePerson varchar(100);

	

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		-- SET MessageText = MESSAGE_TEXT;

		-- SET ReturnedSqlState = RETURNED_SQLSTATE;

		-- SET MySQLErrNo = MYSQL_ERRNO;

		-- GET CURRENT DIAGNOSTICS CONDITION 1 MessageText : MESSAGE_TEXT, ReturnedSqlState : RETURNED_SQLSTATE, MySqlErrNo : MYSQL_ERRNO;

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in GetPOssibleMothers. Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN



    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("getPossibleMothers");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start opbouwen tabel met mogelijke moeders voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    -- Mogelijke moeders

	SELECT DISTINCT

    

    P.PersonID as PossibleMotherID, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossibleMother

    

    FROM persons P 



    -- Mogelijke moeder moet vrouw zijn

    WHERE P.PersonIsMale = FALSE



    -- Minimale leeftijd waarop de mogelijke moeder, moeder is geworden is 15 (geboortedatum moeder = geboordedatum kind - 15 jaar)

    AND YEAR(P.PersonDateOfBirth) 

		<  

		(SELECT YEAR(PersonDateOfBirth) - 15

        FROM persons 

        WHERE PersonID = PersonIDin)



    -- Maximale leeftijd waarop de mogelijke moeder, moeder is geworden is 50 jaar (geboortedatum moeder = geboortedatum kind - 50 jaar)

	AND YEAR(P.PersonDateOfBirth) 

		>  

		(SELECT YEAR(PersonDateOfBirth) - 50

        FROM persons 

        WHERE PersonID = PersonIDin)

     

	-- Mogelijke moeder mag niet de partner zijn   

	AND P.PersonID NOT IN 

		(SELECT RelationWithPerson

		 FROM relations R

		 JOIN (relationnames RN, persons P)

		 ON (R.RelationName = RN.RelationnameID AND 

			 P.PersonID = R.RelationPerson AND 

			 RN.RelationnameName = "Partner")

		 WHERE P.PersonID = PersonIDin)

        

       ORDER BY P.PersonDateOfBirth;   



    INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Lijst met mogelijke moeders afgerond.'),

				TestLogDateTime = NOW();

 END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getPossibleMothersBasedOnAge` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `getPossibleMothersBasedOnAge`(IN `PersonAgeIn` DATE)
    SQL SECURITY INVOKER
    COMMENT 'To get the possible mothers of a person based on the persons birth'
BEGIN

	SELECT DISTINCT

    

    P.PersonID as PossibleMotherID, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossibleMother

    

    FROM persons P 



    WHERE P.PersonIsMale = false

    AND YEAR(P.PersonDateOfBirth) < (YEAR(PersonAgeIn) - 15)

		

	AND YEAR(P.PersonDateOfBirth) > (YEAR(PersonAgeIn) - 50)

        

    ORDER BY P.PersonDateOfBirth;

 END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getPossiblePartners` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `getPossiblePartners`(IN `PersonIDin` INT(11))
    SQL SECURITY INVOKER
    COMMENT 'To get the possible partners of a person based on the persons birth'
BEGIN

	/* This procedure takes into account that Fathers and Mothers as well as Sisters and Brothers */

    /* may not be returned as (possible) partners */

    SELECT DISTINCT

    

    P.PersonID as PossiblePartnerID, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossiblePartner,

    P.PersonDateOfBirth

    

    FROM persons P 

    

    WHERE P.PersonID <> PersonIDin

    

    AND YEAR(P.PersonDateOfBirth) 

		>  

		(SELECT YEAR(PersonDateOfBirth) - 15

        FROM persons 

        WHERE PersonID = PersonIDin)

	

    AND YEAR(P.PersonDateOfBirth) 

		<  

		(SELECT YEAR(PersonDateOfBirth) + 15

        FROM persons 

        WHERE PersonID = PersonIDin) 

        

	AND P.PersonID NOT IN 

    /* A Partner may not be the Father or Mother, so do not select a person who is the father or mother */

		(SELECT RelationWithPerson

		 FROM relations R

		 JOIN (relationnames RN, persons P)

		 ON (R.RelationName = RN.RelationnameID AND 

			 P.PersonID = R.RelationPerson AND 

				(RN.RelationnameName = "Vader" OR

				 RN.RelationnameName = "Moeder"))

		 WHERE P.PersonID = PersonIDin)

   

   AND P.PersonID NOT IN 

    /* A Partner may not be a Sister or a Brother, so do not select a person with same father or mother */

		(SELECT RelationPerson as Persons 

		FROM relations R

		JOIN (relationnames RN, persons P)

		ON R.RelationName = RN.RelationnameID AND 

		P.PersonID = R.RelationPerson AND 

		(RN.RelationnameName = "Vader" OR RN.RelationnameName = "Moeder") AND

		RelationWithPerson NOT IN 

			(SELECT RelationWithPerson as Parents

			FROM relations R

			JOIN (relationnames RN, persons P)

			ON R.RelationName = RN.RelationnameID AND 

			P.PersonID = R.RelationPerson AND 

			R.RelationPerson = PersonIDin AND

			(RN.RelationnameName = "Vader" OR RN.RelationnameName = "Moeder")))

             

        

    ORDER BY P.PersonDateOfBirth;    

 END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getPossiblePartnersBasedOnAge` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `getPossiblePartnersBasedOnAge`(IN `PersonAgeIn` DATE)
    SQL SECURITY INVOKER
    COMMENT 'To get the possible partners of a person based on the persons birth'
BEGIN

	SELECT DISTINCT

    

    P.PersonID as PossiblePartnerID, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossiblePartner

    

    FROM persons P 



    WHERE YEAR(P.PersonDateOfBirth) > (YEAR(PersonAgeIn) - 15)

		

		  AND YEAR(P.PersonDateOfBirth) < (YEAR(PersonAgeIn) + 15)

        

    ORDER BY P.PersonDateOfBirth;

 END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertPersonDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `InsertPersonDetails`(IN `PersonGivvenNameIn` VARCHAR(25), IN `PersonFamilyNameIn` VARCHAR(50), IN `PersonDateOfBirthIn` DATETIME, IN `PersonPlaceOfBirthIn` VARCHAR(50), IN `PersonDateOfDeathIn` DATETIME, IN `PersonPlaceOfDeathIn` VARCHAR(50), IN `PersonIsMaleIn` TINYINT(1), IN `PersonPhotoIn` LONGBLOB, IN `PersonPartnerIdIn` INT(11), IN `PersonPartnerIn` VARCHAR(50), IN `PersonFatherIdIn` INT(11), IN `PersonFatherIn` VARCHAR(50), IN `PersonMotherIdIn` INT(11), IN `PersonMotherIn` VARCHAR(50))
    SQL SECURITY INVOKER
    COMMENT 'To update the details of a specific person'
BEGIN

		DECLARE CompletedOk INT;

		DECLARE NewTransNo INT;

		DECLARE TransResult INT;

		DECLARE RecCount INT;

		DECLARE RelationName INT;

		DECLARE RelNameId INT;

		DECLARE FullNamePerson VarChar(100);

		

		DECLARE EXIT HANDLER FOR SQLEXCEPTION

		BEGIN

		-- SET MessageText = MESSAGE_TEXT;

		-- SET ReturnedSqlState = RETURNED_SQLSTATE;

		-- SET MySQLErrNo = MYSQL_ERRNO;

		-- GET CURRENT DIAGNOSTICS CONDITION 1 MessageText : MESSAGE_TEXT, ReturnedSqlState : RETURNED_SQLSTATE, MySqlErrNo : MYSQL_ERRNO;

			ROLLBACK;

			SET CompletedOk = 2;

		-- INSERT INTO TestLog SELECT concat('SQLException occurred. Rollback performed. Errorinfo: Message= ', MessageText, '. State= ', ReturnedSqlState, '. ErrNo= ', MySqlErrNo);

			INSERT INTO humans.testlog 

			SET TestLog = CONCAT('Transaction-', IFNULL(NewTransNo, 'null'), ". Error occured. Rollback executed."),

				 TestLogDateTime = NOW();

			SELECT CompletedOk, FullNamePerson;	 

		END;

		

		START TRANSACTION;

		

			 SET CompletedOk = 0;

		

			 SET NewTransNo = GetTranNo("InsertPersonDetails");

			 

 			 INSERT INTO humans.testlog 

 			 SET TestLog = concat('TransAction-', IFNULL(NewTransNo, 'null'), '. ',

			  							  'Nieuwe persoon wordt toegevoegd=> ', 

			  							  'PersonGivvenNameIn= ', IFNULL(PersonGivvenNameIn, 'null'), ', ',

 										  'PersonFamilyNameIn= ', IFNULL(PersonFamilyNameIn, 'null'), ', ',

 										  'PersonDateOfBirthIn= ', IFNULL(PersonDateOfBirthIn, 'null'), ', ',

 										  'PersonPlaceOfBirthIn= ', IFNULL(PersonPlaceOfBirthIn, 'null'), ', ',

 										  'PersonDateOfDeathIn= ', IFNULL(PersonDateOfDeathIn, 'null'), ', ',

 										  'PersonPlaceOfDeathIn= ',  IFNULL(PersonPlaceOfDeathIn, 'null'), ', ',

 										  'PersonIsMaleIn= ', IFNULL(PersonIsMaleIn, 'null'), ', ',

 										  'PersonPhotoIn= ', IFNULL(PersonPhotoIn, 'null'), ', ',

 										  'PersonPartnerIdIn= ', IFNULL(PersonPartnerIdIn, 'null'), ', ',

 										  'PersonPartnerIn= ',  IFNULL(PersonPartnerIn, 'null'), ', ',

 										  'PersonFatherIdIn= ',  IFNULL(PersonFatherIdIn, 'null'), ', ',

 										  'PersonFatherIn= ',  IFNULL(PersonFatherIn, 'null'), ', ',

 										  'PersonMotherIdIn= ',  IFNULL(PersonMotherIdIn, 'null'), ', ',

 										  'PersonMotherIn= ', IFNULL(PersonMotherIn, 'null'), '.'),

 					 TestLogDateTime = NOW();

			

			INSERT INTO humans.persons

			SET PersonGivvenName=PersonGivvenNameIn,

				PersonFamilyName=PersonFamilyNameIn,

				PersonDateOfBirth=PersonDateOfBirthIn,

				PersonPlaceOfBirth=PersonPlaceOfBirthIn,

				PersonDateOfDeath=PersonDateOfDeathIn,

				PersonPlaceOfDeath=PersonPlaceOfDeathIn,

				PersonIsMale=PersonIsMaleIn,

				PersonPhoto = null;

			SET RelNameID = LAST_INSERT_ID();

			SET FullNamePerson = CONCAT(PersonGivvenNameIn, " ", PersonFamilyNameIn);	

	  

			SET TransResult = 1;

			SET RecCount = 0;

	      

	

			INSERT INTO humans.testlog 

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Persoon is toegevoegd, ID= ', RelNameID),

				 TestLogDateTime = NOW();

			

			-- Based on if Mother params are filled do either nothing or insert Mother

			-- -------------------------------------------------

			-- If Mother params are filled

			-- INSERT Mother 

			IF PersonMotherIn <> '' OR PersonMotherIn <> null THEN

				-- First search for RelationName (= content of field RelationnameID in table RELATIONNAMES where RelationnaneName = "Moeder")

				SELECT RelationnameID INTO RelationName FROM humans.relationnames WHERE RelationnameName = "Moeder";

				INSERT INTO relations

				SET RelationName = RelationName,

					RelationPerson = RelNameID,

					RelationWithPerson = PersonMotherIdIn;

				SET TransResult = TransResult + 1;	

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, ', Moeder met ID= ', PersonMotherIdIn, ' is toegevoegd aan Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();

			ELSE

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Geen ingave voor Moeder dus geen Moeder toegevoegd voor Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();		 

			END IF;

			

			

			-- Based on if Father params are filled do either nothing or insert Father

			-- --------------------------------------------------

			-- If Father param is filled

			-- INSERT Father 

			IF PersonFatherIn <> '' OR PersonFatherIn <> null THEN

				-- First search for RelationName (= content of field RelationnameID in table RELATIONNAMES where RelationnaneName = "Vader")

				SELECT RelationnameID INTO RelationName FROM humans.relationnames WHERE RelationnameName = "Vader";

				INSERT INTO relations

				SET RelationName = RelationName,

					RelationPerson = RelNameID,

					RelationWithPerson = PersonFatherIdIn;

				SET TransResult = TransResult + 1;	

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, ', Vader met ID= ', PersonFatherIdIn, ' is toegevoegd aan Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();

			ELSE

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Geen ingave voor Vader dus geen Vader toegevoegd voor Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();		 

			END IF;

			

			

			-- Based on if Partner params are filled do either nothing or insert Partner

			-- ----------------------------------------------------

			-- If Partner param is filled

			-- INSERT Partner, if Person does not yet have Partner

			IF PersonPartnerIn <> '' OR PersonPartnerIn <> null THEN

			-- First search for RelationName (= content of field RelationnameID in table RELATIONNAMES where RelationnaneName = "Partner")

				SELECT RelationnameID INTO RelationName FROM humans.relationnames WHERE RelationnameName = "Partner";

				INSERT INTO relations

				SET RelationName = Relationname,

					RelationPerson = RelNameID,

					RelationWithPerson = PersonPartnerIdIn;

				SET TransResult = TransResult + 1;

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, ', Partner met ID= ', PersonPartnerIdIn, ' is toegevoegd aan Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();

				-- -> Insert as well Partner field for the other Person (the partner) but now for this Person as partner

				INSERT INTO relations

				SET RelationName = Relationname,

					RelationPerson = PersonPartnerIdIn,

					RelationWithPerson = RelNameID;

				SET TransResult = TransResult + 1;

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, ', Persoon met ID= ', RelNameID, ' is ook als Partner toegevoegd aan ID: ', PersonPartnerIdIn),

					 TestLogDateTime = NOW();

			ELSE

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Geen ingave voor Partner dus geen Partner toegevoegd voor Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();		 

			END IF;

		

		COMMIT;

		SET CompletedOk = 1;

		

		

	    INSERT INTO humans.testlog

		 SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. SPROC insertPersonDetails succesvol afgesloten. CompletedOk= ', CompletedOk),

				 TestLogDateTime = NOW();

	

		 SELECT CompletedOk, FullNamePerson, RelNameID as PersonID; 

 END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdatePersonDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `UpdatePersonDetails`(IN `PersonIdIn` INT(11), IN `PersonGivvenNameIn` VARCHAR(25), IN `PersonFamilyNameIn` VARCHAR(50), IN `PersonDateOfBirthIn` DATETIME, IN `PersonPlaceOfBirthIn` VARCHAR(50), IN `PersonDateOfDeathIn` DATETIME, IN `PersonPlaceOfDeathIn` VARCHAR(50), IN `PersonIsMaleIn` TINYINT(1), IN `PersonPhotoIn` LONGBLOB, IN `TimestampIn` TIMESTAMP, IN `PersonPartnerIdIn` INT(11), IN `PersonPartnerIn` VARCHAR(50), IN `PersonFatherIdIn` INT(11), IN `PersonFatherIn` VARCHAR(50), IN `PersonMotherIdIn` INT(11), IN `PersonMotherIn` VARCHAR(50))
    SQL SECURITY INVOKER
    COMMENT 'To update the details of a specific person'
BEGIN

	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = Transaction aborted due to intermediate changes (possibly from other users) in the mean time

    -- 2 = Transaction aborted due to problems during update and rollback performed

    DECLARE CompletedOk int;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo int;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult int;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



    -- LastRecInserted is the autonumber ID value for each addition

	DECLARE LastRecIdInserted INT(11);



	DECLARE FullNamePerson varchar(100);

-- 	DECLARE MessageText text;

-- 	DECLARE ReturnedSqlState int;

-- 	DECLARE MySqlErrNo int;

	

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		-- SET MessageText = MESSAGE_TEXT;

		-- SET ReturnedSqlState = RETURNED_SQLSTATE;

		-- SET MySQLErrNo = MYSQL_ERRNO;

		-- GET CURRENT DIAGNOSTICS CONDITION 1 MessageText : MESSAGE_TEXT, ReturnedSqlState : RETURNED_SQLSTATE, MySqlErrNo : MYSQL_ERRNO;

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured. Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

		CALL GetPersonDetails(PersonIdIn);

	END;



main_proc:

BEGIN



START TRANSACTION;



SET CompletedOk = 0;



SET TransResult = 0;



SET NewTransNo = GetTranNo("UpdatePersonDetails");



INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start update for person with ID= ', PersonIdIn),

		TestLogDateTime = NOW();
        
 INSERT INTO humans.testlog 
 SET TestLog = concat('TransAction-', IFNULL(NewTransNo, 'null'), '. ',
							  'Update bestaande persoon=> ', 
                              'PersonIdIn= ', IFNULL(PersonIdIn, 'null'), ', ',
							  'PersonGivvenNameIn= ', IFNULL(PersonGivvenNameIn, 'null'), ', ',
							  'PersonFamilyNameIn= ', IFNULL(PersonFamilyNameIn, 'null'), ', ',
							  'PersonDateOfBirthIn= ', IFNULL(PersonDateOfBirthIn, 'null'), ', ',
							  'PersonPlaceOfBirthIn= ', IFNULL(PersonPlaceOfBirthIn, 'null'), ', ',
							  'PersonDateOfDeathIn= ', IFNULL(PersonDateOfDeathIn, 'null'), ', ',
							  'PersonPlaceOfDeathIn= ',  IFNULL(PersonPlaceOfDeathIn, 'null'), ', ',
							  'PersonIsMaleIn= ', IFNULL(PersonIsMaleIn, 'null'), ', ',
							  'PersonPhotoIn= ', IFNULL(PersonPhotoIn, 'null'), ', ',
							  'PersonPartnerIdIn= ', IFNULL(PersonPartnerIdIn, 'null'), ', ',
							  'PersonPartnerIn= ',  IFNULL(PersonPartnerIn, 'null'), ', ',
							  'PersonFatherIdIn= ',  IFNULL(PersonFatherIdIn, 'null'), ', ',
							  'PersonFatherIn= ',  IFNULL(PersonFatherIn, 'null'), ', ',
							  'PersonMotherIdIn= ',  IFNULL(PersonMotherIdIn, 'null'), ', ',
							  'PersonMotherIn= ', IFNULL(PersonMotherIn, 'null'), '.'),
		 TestLogDateTime = NOW();

IF RecordHasBeenChangedBySomebodyElse(PersonIdIn, TimeStampIn) THEN

	SET CompletedOk = 1;

	INSERT INTO humans.testLog 

		SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Records has been changed in mean time. Update aborted."),

			TestLogDateTime = NOW();

	SELECT CompletedOk;

	CALL GetPersonDetails(PersonIdIn);

	LEAVE main_proc;

END IF;



UPDATE humans.persons

		SET PersonID= PersonIdIn, 

			PersonGivvenName=PersonGivvenNameIn,

			PersonFamilyName=PersonFamilyNameIn,

			PersonDateOfBirth=PersonDateOfBirthIn,

			PersonPlaceOfBirth=PersonPlaceOfBirthIn,

			PersonDateOfDeath=PersonDateOfDeathIn,

			PersonPlaceOfDeath=PersonPlaceOfDeathIn,

			PersonIsMale=PersonIsMaleIn

		WHERE PersonID= PersonIDIn;

SET TransResult = 1;

SET RecCount = 0;

INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Gegevens zijn gewijzigd van Persoon ID= ', PersonIdIn),

		TestLogDateTime = NOW();



		

-- Based on if Mother params are filled do either nothing or update or insert Mother

-- -------------------------------------------------

-- If Mother params are filled

-- Determine if Person has Mother

-- UPDATE Mother if Person already has Mother

-- INSERT Mother if Person does not yet have Mother

IF PersonMotherIn <> '' OR PersonMotherIn <> null THEN

	INSERT INTO humans.testlog

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Moeder in transactie aanwezig. Moeder ID= ', IFNULL(PersonMotherIdIn, 'null')),

		TestLogDateTime = NOW();

		SET RecCount = 

				(SELECT COUNT(*)

					FROM relations R

					JOIN relationnames RN

						ON R.RelationName = RN.RelationnameID

					WHERE R.RelationPerson = PersonIDIn AND

						RN.RelationnameName = "Moeder");

		INSERT INTO humans.testlog

		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In database aantal gevonden moeders= ', IFNULL(RecCount, '0')),

		TestLogDateTime = NOW();

		IF RecCount > 0 THEN

			-- Als moeder wel bestaat;

			UPDATE relations R, relationnames RN

			SET R.RelationWithPerson=PersonMotherIdIn

			WHERE R.RelationName = RN.RelationnameID AND

					R.RelationPerson = PersonIdIn AND 

					RN.RelationnameName = "Moeder";

			SET TransResult = TransResult + 1;

			INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Moeder gevonden in database en updated.'),

			TestLogDateTime = NOW();

		ELSEIF RecCount <= 0 THEN

				-- Als moeder NIET bestaat;

				SET @RelNameID = (SELECT RelationnameID FROM relationnames WHERE RelationnameName = "Moeder");

				INSERT INTO relations

				SET RelationName = @RelNameId,

					RelationPerson = PersonIDIn,

					RelationWithPerson = PersonMotherIdIn;

				SET TransResult = TransResult + 1;

				INSERT INTO humans.testlog

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Toegevoegd in database moeder met ID= ', IFNULL(PersonMotherIdIn, 'null')),

				TestLogDateTime = NOW();

			END IF;

		END IF;

		

		

-- Based on if Father params are filled do either nothing or update or insert Father

-- --------------------------------------------------

-- If Father param is filled

-- Determine if Person has Father

-- UPDATE Father if Person already has Father

-- INSERT Father if Person does not yet have Father

IF PersonFatherIn <> '' OR PersonFatherIn <> null THEN

	INSERT INTO humans.testlog

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Vader in transactie aanwezig. Vader ID= ', IFNULL(PersonFatherIdIn, 'null')),

		TestLogDateTime = NOW();

	SET RecCount = 

			(SELECT COUNT(*)

				FROM relations R

				JOIN relationnames RN

					ON R.RelationName = RN.RelationnameID

				WHERE R.RelationPerson = PersonIDIn AND

					RN.RelationnameName = "Vader");

	INSERT INTO humans.testlog

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In database aantal gevonden vaders= ', IFNULL(RecCount, '0')),

		TestLogDateTime = NOW();

	IF RecCount > 0 THEN

		-- Als vader wel bestaat;

		UPDATE relations R, relationnames RN

		SET R.RelationWithPerson=PersonFatherIdIn

		WHERE R.RelationName = RN.RelationnameID AND

				R.RelationPerson = PersonIDIn AND 

				RN.RelationnameName = "Vader";

		SET TransResult = TransResult + 1;

		INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Vader gevonden in database en updated.'),

				TestLogDateTime = NOW();

	ELSEIF RecCount <= 0 THEN

		-- Als vader NIET bestaat;

		SET @RelNameID = (SELECT RelationnameID FROM relationnames WHERE RelationnameName = "Vader");

		INSERT INTO relations

			SET RelationName = @RelNameID,

				RelationPerson = PersonIDIn,

				RelationWithPerson = PersonFatherIdIn;

		SET TransResult = TransResult + 1;

		INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Toegevoegd in database vader met ID= ', IFNULL(PersonFatherIdIn, 'null')),

				TestLogDateTime = NOW();

	END IF;

END IF;

		

		

-- Based on if Partner params are filled do either nothing or update or insert Partner

-- ----------------------------------------------------

-- If Partner param is filled

-- Determine if Person has Partner

-- UPDATE Partner if Person already has Partner

-- INSERT Partner if Person does not yet have Partner

IF PersonPartnerIn <> '' OR PersonPartnerIn <> null THEN

	INSERT INTO humans.testlog

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partner in transactie aanwezig. Partner ID= ', IFNULL(PersonPartnerIdIn, 'null')),

		TestLogDateTime = NOW();

	SET RecCount = 

		(SELECT COUNT(*)

			FROM relations R

			JOIN relationnames RN

				ON R.RelationName = RN.RelationnameID

			WHERE R.RelationPerson = PersonIDIn AND

				RN.RelationnameName = "Partner");

	INSERT INTO humans.testlog

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In database aantal gevonden partners= ', IFNULL(RecCount, '0')),

		TestLogDateTime = NOW();

	IF RecCount > 0 THEN

		-- Als partner wel bestaat;

		-- -> Update Partner for this Person

		UPDATE relations R, relationnames RN

		SET R.RelationWithPerson=PersonPartnerIdIn

		WHERE R.RelationName = RN.RelationnameID AND

				R.RelationPerson = PersonIDIn AND 

				RN.RelationnameName = "Partner";

		SET TransResult = TransResult + 1;

		INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Partner in database en updated.'),

				TestLogDateTime = NOW();

		-- -> Update as well Partner field for the other person (the partner)

		UPDATE relations R, relationnames RN

		SET R.RelationPerson=PersonPartnerIdIn,

			R.RelationWithPerson=PersonIDIn

		WHERE R.RelationName = RN.RelationnameID AND

				R.RelationPerson = PersonPartnerIdIn AND

				R.RelationWithPerson=PersonIdIn AND

				RN.RelationnameName = "Partner";

		SET TransResult = TransResult + 1;

		INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Reverse partner gevonden in database en updated.'),

				TestLogDateTime = NOW();

	ELSEIF RecCount <= 0 THEN

		-- Als partner NIET bestaat;

		-- -> Insert Partner for tis Person

		SET @RelNameID = (SELECT RelationnameID FROM relationnames WHERE RelationnameName = 'Partner');

		INSERT INTO relations

		SET RelationName = @RelNameID,

			RelationPerson = PersonIDIn,

			RelationWithPerson = PersonPartnerIdIn;

		SET TransResult = TransResult + 1;

		INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Partner toegevoegd aan database ID= ', PersonPartnerIdIn),

				TestLogDateTime = NOW();

		-- -> Insert as well Partner field for the other Person (the partner) bot now for this Person as partner

		INSERT INTO relations

		SET RelationName = @RelNameID,

			RelationPerson = PersonPartnerIDIn,

			RelationWithPerson = PersonIDIn;

		SET TransResult = TransResult + 1;

		INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Reverse Partner toegevoegd aan database ID= ', PersonIDIn),

				TestLogDateTime = NOW();

	END IF;

END IF;  

COMMIT;

INSERT INTO humans.testlog

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Transactie afgerond, alle wijzigingen zijn comitted. Calling GetPersonDetails.'),

		TestLogDateTime = NOW();

SELECT CompletedOk;

CALL GetPersonDetails(PersonIdIn);

END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `allpersons`
--

/*!50001 DROP VIEW IF EXISTS `allpersons`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  */
/*!50001 VIEW `allpersons` AS select 1 AS `PersonID`,1 AS `PersonGivvenName`,1 AS `PersonFamilyName`,1 AS `PersonDateOfBirth`,1 AS `PersonPlaceOfBirth`,1 AS `PersonDateOfDeath`,1 AS `PersonPlaceOfDeath`,1 AS `PersonIsMale`,1 AS `PersonPhoto` */;
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

-- Dump completed on 2020-01-28 22:50:02
