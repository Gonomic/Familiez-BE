-- DEV-only migration for Step 18.
-- Take a DEV database backup or be prepared to recreate it from the init files before running.
USE `humans`;

DELIMITER $$
DROP PROCEDURE IF EXISTS `UpdateFunctionRegistry`$$
DROP PROCEDURE IF EXISTS `AddFunctionDependency`$$
DROP PROCEDURE IF EXISTS `GetFunctionCapabilities`$$
DELIMITER ;

ALTER TABLE `function_registry`
    ADD COLUMN `FunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NULL AFTER `FunctionID`;
UPDATE `function_registry`
   SET `FunctionKey` = CONCAT(`Layer`, ':', `FunctionName`)
 WHERE `FunctionKey` IS NULL;
ALTER TABLE `function_registry`
    MODIFY COLUMN `FunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NOT NULL;
ALTER TABLE `function_registry`
    ADD UNIQUE KEY `UQ_FUNCTION_REGISTRY_KEY` (`FunctionKey`);

ALTER TABLE `function_dependencies`
    ADD COLUMN `DependencyKey` VARCHAR(1023) CHARACTER SET ascii COLLATE ascii_bin NULL AFTER `DependencyID`,
    ADD COLUMN `CallerFunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NULL AFTER `CallerFunctionID`,
    ADD COLUMN `CalleeFunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NULL AFTER `CalleeFunctionID`;
UPDATE `function_dependencies` dependency
JOIN `function_registry` caller ON caller.`FunctionID` = dependency.`CallerFunctionID`
JOIN `function_registry` callee ON callee.`FunctionID` = dependency.`CalleeFunctionID`
   SET dependency.`CallerFunctionKey` = caller.`FunctionKey`,
       dependency.`CalleeFunctionKey` = callee.`FunctionKey`,
       dependency.`DependencyKey` = CONCAT(caller.`FunctionKey`, '->', callee.`FunctionKey`);
ALTER TABLE `function_dependencies`
    MODIFY COLUMN `DependencyKey` VARCHAR(1023) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    MODIFY COLUMN `CallerFunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    MODIFY COLUMN `CalleeFunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NOT NULL;

ALTER TABLE `function_registry_audit`
    ADD COLUMN `FunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NULL AFTER `FunctionID`;
UPDATE `function_registry_audit` audit
JOIN `function_registry` registry ON registry.`FunctionID` = audit.`FunctionID`
   SET audit.`FunctionKey` = registry.`FunctionKey`
 WHERE audit.`FunctionKey` IS NULL;
ALTER TABLE `function_registry_audit`
    MODIFY COLUMN `FunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NOT NULL;

ALTER TABLE `function_dependencies`
    DROP FOREIGN KEY `FK_FUNCTION_DEPENDENCIES_CALLER`,
    DROP FOREIGN KEY `FK_FUNCTION_DEPENDENCIES_CALLEE`,
    DROP INDEX `UQ_FUNCTION_DEPENDENCIES_CALLER_CALLEE`,
    DROP PRIMARY KEY,
    DROP COLUMN `DependencyID`,
    DROP COLUMN `CallerFunctionID`,
    DROP COLUMN `CalleeFunctionID`,
    ADD PRIMARY KEY (`DependencyKey`),
    ADD UNIQUE KEY `UQ_FUNCTION_DEPENDENCIES_CALLER_CALLEE` (`CallerFunctionKey`, `CalleeFunctionKey`),
    ADD CONSTRAINT `FK_FUNCTION_DEPENDENCIES_CALLER`
        FOREIGN KEY (`CallerFunctionKey`) REFERENCES `function_registry` (`FunctionKey`) ON DELETE CASCADE,
    ADD CONSTRAINT `FK_FUNCTION_DEPENDENCIES_CALLEE`
        FOREIGN KEY (`CalleeFunctionKey`) REFERENCES `function_registry` (`FunctionKey`) ON DELETE CASCADE;

ALTER TABLE `function_registry_audit`
    DROP FOREIGN KEY `FK_FUNCTION_REGISTRY_AUDIT_FUNCTION`,
    DROP INDEX `IX_FUNCTION_REGISTRY_AUDIT_FUNCTION`,
    DROP COLUMN `FunctionID`,
    ADD KEY `IX_FUNCTION_REGISTRY_AUDIT_FUNCTION` (`FunctionKey`),
    ADD CONSTRAINT `FK_FUNCTION_REGISTRY_AUDIT_FUNCTION`
        FOREIGN KEY (`FunctionKey`) REFERENCES `function_registry` (`FunctionKey`);

ALTER TABLE `function_registry`
    DROP PRIMARY KEY,
    DROP COLUMN `FunctionID`,
    ADD PRIMARY KEY (`FunctionKey`);