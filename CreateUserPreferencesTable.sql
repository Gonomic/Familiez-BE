CREATE TABLE IF NOT EXISTS `humans`.`familiez_user_preferences` (
  `username` VARCHAR(100) NOT NULL,
  `linked_person_id` INT NULL,
  `generations_up` INT NOT NULL DEFAULT 3,
  `generations_down` INT NOT NULL DEFAULT 3,
  `auto_show_tree` TINYINT(1) NOT NULL DEFAULT 0,
  `last_added_person_id` INT NULL,
  PRIMARY KEY (`username`),
  KEY `IX_user_preferences_linked_person` (`linked_person_id`),
  KEY `IX_user_preferences_last_added_person` (`last_added_person_id`),
  CONSTRAINT `FK_user_preferences_person`
    FOREIGN KEY (`linked_person_id`)
    REFERENCES `humans`.`persons` (`PersonID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `FK_user_preferences_last_added_person`
    FOREIGN KEY (`last_added_person_id`)
    REFERENCES `humans`.`persons` (`PersonID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
COMMENT='Per-user settings for linked person, default tree rendering, and last added person';

-- Migration logic for existing databases
SET @dbname = DATABASE();
SET @tablename = 'familiez_user_preferences';
SET @columnname = 'last_added_person_id';
SET @preexists = (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = @dbname
    AND TABLE_NAME = @tablename
    AND COLUMN_NAME = @columnname
);

SET @query = IF(@preexists = 0,
  'ALTER TABLE `humans`.`familiez_user_preferences` ADD COLUMN `last_added_person_id` INT NULL, ADD KEY `IX_user_preferences_last_added_person` (`last_added_person_id`), ADD CONSTRAINT `FK_user_preferences_last_added_person` FOREIGN KEY (`last_added_person_id`) REFERENCES `humans`.`persons` (`PersonID`) ON DELETE SET NULL ON UPDATE CASCADE;',
  'SELECT "Column last_added_person_id already exists" AS Status;'
);

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
