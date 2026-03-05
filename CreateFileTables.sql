-- ===================================================================
-- File Management Tables for Familiez
-- Created: 2026-03-05
-- Purpose: Store metadata for uploaded files and link them to persons/families
-- ===================================================================

USE humans;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `person_files`;
DROP TABLE IF EXISTS `family_files`;
DROP TABLE IF EXISTS `files`;

CREATE TABLE `files` (
  `FileID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique file identifier',
  `FilePath` varchar(500) NOT NULL COMMENT 'Relative path from storage base to file',
  `FileName` varchar(255) NOT NULL COMMENT 'Generated unique filename with extension',
  `OriginalFileName` varchar(255) DEFAULT NULL COMMENT 'Original filename as uploaded by user',
  `DocumentType` varchar(50) NOT NULL COMMENT 'Type of document: portret, familiefoto, geboorteakte, etc.',
  `Year` int(4) DEFAULT NULL COMMENT 'Optional year associated with the document',
  `FileSize` bigint NOT NULL DEFAULT 0 COMMENT 'File size in bytes',
  `MimeType` varchar(100) DEFAULT NULL COMMENT 'MIME type of the file',
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when file was uploaded',
  `UploadedBy` varchar(100) DEFAULT NULL COMMENT 'Username of person who uploaded the file',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification timestamp',
  PRIMARY KEY (`FileID`),
  KEY `IDX_FILES_DOCUMENT_TYPE` (`DocumentType`),
  KEY `IDX_FILES_YEAR` (`Year`),
  KEY `IDX_FILES_CREATED_AT` (`CreatedAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Metadata for uploaded files and documents';

--
-- Table structure for table `person_files`
--

CREATE TABLE `person_files` (
  `PersonFileID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for person-file link',
  `PersonID` int(11) NOT NULL COMMENT 'Reference to person',
  `FileID` int(11) NOT NULL COMMENT 'Reference to file',
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this link was created',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification timestamp',
  PRIMARY KEY (`PersonFileID`),
  UNIQUE KEY `UQ_PERSON_FILE` (`PersonID`, `FileID`),
  KEY `IDX_PERSON_FILES_PERSON` (`PersonID`),
  KEY `IDX_PERSON_FILES_FILE` (`FileID`),
  CONSTRAINT `FK_PERSON_FILES_PERSON` FOREIGN KEY (`PersonID`) REFERENCES `persons` (`PersonID`) ON DELETE CASCADE,
  CONSTRAINT `FK_PERSON_FILES_FILE` FOREIGN KEY (`FileID`) REFERENCES `files` (`FileID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Links files to persons';

--
-- Table structure for table `family_files`
--

CREATE TABLE `family_files` (
  `FamilyFileID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for family-file link',
  `FatherID` int(11) NOT NULL COMMENT 'Reference to father in the family',
  `MotherID` int(11) NOT NULL COMMENT 'Reference to mother in the family',
  `FileID` int(11) NOT NULL COMMENT 'Reference to file',
  `CreatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When this link was created',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last modification timestamp',
  PRIMARY KEY (`FamilyFileID`),
  UNIQUE KEY `UQ_FAMILY_FILE` (`FatherID`, `MotherID`, `FileID`),
  KEY `IDX_FAMILY_FILES_FATHER` (`FatherID`),
  KEY `IDX_FAMILY_FILES_MOTHER` (`MotherID`),
  KEY `IDX_FAMILY_FILES_FILE` (`FileID`),
  CONSTRAINT `FK_FAMILY_FILES_FATHER` FOREIGN KEY (`FatherID`) REFERENCES `persons` (`PersonID`) ON DELETE CASCADE,
  CONSTRAINT `FK_FAMILY_FILES_MOTHER` FOREIGN KEY (`MotherID`) REFERENCES `persons` (`PersonID`) ON DELETE CASCADE,
  CONSTRAINT `FK_FAMILY_FILES_FILE` FOREIGN KEY (`FileID`) REFERENCES `files` (`FileID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Links files to families (parent couples)';

-- ===================================================================
-- Indexes are already created above, but documenting the rationale:
--
-- files table:
--   - IDX_FILES_DOCUMENT_TYPE: Fast filtering by document type
--   - IDX_FILES_YEAR: Fast filtering by year
--   - IDX_FILES_CREATED_AT: Chronological queries
--
-- person_files table:
--   - IDX_PERSON_FILES_PERSON: Fast lookup of all files for a person
--   - IDX_PERSON_FILES_FILE: Fast lookup of all persons linked to a file
--   - UQ_PERSON_FILE: Prevent duplicate links
--
-- family_files table:
--   - IDX_FAMILY_FILES_FATHER: Fast lookup by father
--   - IDX_FAMILY_FILES_MOTHER: Fast lookup by mother
--   - IDX_FAMILY_FILES_FILE: Fast lookup of all families linked to a file
--   - UQ_FAMILY_FILE: Prevent duplicate links
-- ===================================================================
