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
-- Table structure for table `fe_releases`
--

DROP TABLE IF EXISTS `fe_release_changes`;
DROP TABLE IF EXISTS `fe_releases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fe_releases` (
  `ReleaseID` int(11) NOT NULL AUTO_INCREMENT,
  `ReleaseNumber` varchar(20) NOT NULL,
  `ReleaseDate` datetime NOT NULL,
  `Description` text,
  PRIMARY KEY (`ReleaseID`),
  KEY `IDX_FE_RELEASE_DATE` (`ReleaseDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Frontend release history';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fe_release_changes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fe_release_changes` (
  `ChangeID` int(11) NOT NULL AUTO_INCREMENT,
  `ReleaseID` int(11) NOT NULL,
  `ChangeDescription` text NOT NULL,
  `ChangeType` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ChangeID`),
  KEY `IDX_FE_RELEASE_CHANGE_RELEASE` (`ReleaseID`),
  CONSTRAINT `FK_FE_RELEASE_CHANGE_RELEASE` FOREIGN KEY (`ReleaseID`) REFERENCES `fe_releases` (`ReleaseID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Frontend release changes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mw_releases`
--

DROP TABLE IF EXISTS `mw_release_changes`;
DROP TABLE IF EXISTS `mw_releases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mw_releases` (
  `ReleaseID` int(11) NOT NULL AUTO_INCREMENT,
  `ReleaseNumber` varchar(20) NOT NULL,
  `ReleaseDate` datetime NOT NULL,
  `Description` text,
  PRIMARY KEY (`ReleaseID`),
  KEY `IDX_MW_RELEASE_DATE` (`ReleaseDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Middleware release history';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mw_release_changes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mw_release_changes` (
  `ChangeID` int(11) NOT NULL AUTO_INCREMENT,
  `ReleaseID` int(11) NOT NULL,
  `ChangeDescription` text NOT NULL,
  `ChangeType` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ChangeID`),
  KEY `IDX_MW_RELEASE_CHANGE_RELEASE` (`ReleaseID`),
  CONSTRAINT `FK_MW_RELEASE_CHANGE_RELEASE` FOREIGN KEY (`ReleaseID`) REFERENCES `mw_releases` (`ReleaseID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Middleware release changes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `be_releases`
--

DROP TABLE IF EXISTS `be_release_changes`;
DROP TABLE IF EXISTS `be_releases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `be_releases` (
  `ReleaseID` int(11) NOT NULL AUTO_INCREMENT,
  `ReleaseNumber` varchar(20) NOT NULL,
  `ReleaseDate` datetime NOT NULL,
  `Description` text,
  PRIMARY KEY (`ReleaseID`),
  KEY `IDX_BE_RELEASE_DATE` (`ReleaseDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Backend release history';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `be_release_changes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `be_release_changes` (
  `ChangeID` int(11) NOT NULL AUTO_INCREMENT,
  `ReleaseID` int(11) NOT NULL,
  `ChangeDescription` text NOT NULL,
  `ChangeType` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ChangeID`),
  KEY `IDX_BE_RELEASE_CHANGE_RELEASE` (`ReleaseID`),
  CONSTRAINT `FK_BE_RELEASE_CHANGE_RELEASE` FOREIGN KEY (`ReleaseID`) REFERENCES `be_releases` (`ReleaseID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Backend release changes';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-19
