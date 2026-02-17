-- Generated from: Add_status_for_datefields_18042020-1.sql
-- Generated: 2026-02-17T21:55:00Z
ALTER TABLE `humans`.`persons`
ADD COLUMN `PersonDateOfBirthStatus` INT NOT NULL DEFAULT 1 COMMENT 'Status must be filled: 1= birthdate is certain, 2 = birthdate is estimated and 3= birthdate was not known' AFTER `Timestamp`,
ADD COLUMN `PersonDateOfDeathStatus` INT NULL COMMENT 'Status can be filled: 1= birthdate is certain, 2 = birthdate is estimated and 3= birthdate was not known' AFTER `PersonDateOfBirthStatus`;
