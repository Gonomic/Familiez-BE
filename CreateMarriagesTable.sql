USE humans;

CREATE TABLE IF NOT EXISTS `marriages` (
  `MarriageID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Marriage identifier',
  `PartnerAID` int(11) NOT NULL COMMENT 'Normalized lower person id in marriage pair',
  `PartnerBID` int(11) NOT NULL COMMENT 'Normalized higher person id in marriage pair',
  `StartDate` date NOT NULL COMMENT 'Marriage start date',
  `MarriagePlace` varchar(100) DEFAULT NULL COMMENT 'Place where marriage took place',
  `EndDate` date DEFAULT NULL COMMENT 'Marriage end date, null means active',
  `EndReason` enum('scheiding','overlijden_een_partner','overlijden_beide_partners','onbekend') DEFAULT NULL COMMENT 'Why the marriage ended',
  `CreatedAt` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Creation timestamp',
  `UpdatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Last update timestamp',
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Compatibility timestamp column',
  PRIMARY KEY (`MarriageID`),
  UNIQUE KEY `UQ_MARRIAGES_PAIR_STARTDATE` (`PartnerAID`,`PartnerBID`,`StartDate`),
  KEY `IDX_MARRIAGES_PARTNERA_ENDDATE` (`PartnerAID`,`EndDate`),
  KEY `IDX_MARRIAGES_PARTNERB_ENDDATE` (`PartnerBID`,`EndDate`),
  KEY `IDX_MARRIAGES_ACTIVE_LOOKUP` (`EndDate`,`PartnerAID`,`PartnerBID`),
  CONSTRAINT `FK_MARRIAGES_PARTNERA_PERSONID` FOREIGN KEY (`PartnerAID`) REFERENCES `persons` (`PersonID`),
  CONSTRAINT `FK_MARRIAGES_PARTNERB_PERSONID` FOREIGN KEY (`PartnerBID`) REFERENCES `persons` (`PersonID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Explicit marriage registrations with history';