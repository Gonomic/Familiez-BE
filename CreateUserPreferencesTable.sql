CREATE TABLE IF NOT EXISTS `humans`.`familiez_user_preferences` (
  `username` VARCHAR(100) NOT NULL,
  `linked_person_id` INT NULL,
  `generations_up` INT NOT NULL DEFAULT 3,
  `generations_down` INT NOT NULL DEFAULT 3,
  `auto_show_tree` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`username`),
  KEY `IX_user_preferences_linked_person` (`linked_person_id`),
  CONSTRAINT `FK_user_preferences_person`
    FOREIGN KEY (`linked_person_id`)
    REFERENCES `humans`.`persons` (`PersonID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
COMMENT='Per-user settings for linked person and default tree rendering';
