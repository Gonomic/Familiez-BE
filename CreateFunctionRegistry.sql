CREATE DATABASE IF NOT EXISTS `humans`;
USE `humans`;

CREATE TABLE IF NOT EXISTS `function_registry` (
    `FunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `Layer` ENUM('FE', 'MW', 'BE') NOT NULL,
    `FunctionName` VARCHAR(255) NOT NULL,
    `Version` INT UNSIGNED NOT NULL DEFAULT 1,
    `SignatureHash` CHAR(64) NOT NULL,
    `LastChangedCommit` VARCHAR(64) DEFAULT NULL,
    `LastChangedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Status` ENUM('active', 'deprecated', 'removed') NOT NULL DEFAULT 'active',
    PRIMARY KEY (`FunctionKey`),
    UNIQUE KEY `UQ_FUNCTION_REGISTRY_LAYER_NAME` (`Layer`, `FunctionName`),
    KEY `IX_FUNCTION_REGISTRY_STATUS` (`Status`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `function_dependencies` (
    `DependencyKey` VARCHAR(1023) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `CallerFunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `CalleeFunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `RequiredMinVersion` INT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`DependencyKey`),
    UNIQUE KEY `UQ_FUNCTION_DEPENDENCIES_CALLER_CALLEE` (`CallerFunctionKey`, `CalleeFunctionKey`),
    CONSTRAINT `FK_FUNCTION_DEPENDENCIES_CALLER`
        FOREIGN KEY (`CallerFunctionKey`) REFERENCES `function_registry` (`FunctionKey`)
        ON DELETE CASCADE,
    CONSTRAINT `FK_FUNCTION_DEPENDENCIES_CALLEE`
        FOREIGN KEY (`CalleeFunctionKey`) REFERENCES `function_registry` (`FunctionKey`)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `function_registry_audit` (
    `AuditID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `FunctionKey` VARCHAR(511) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `OldVersion` INT UNSIGNED DEFAULT NULL,
    `NewVersion` INT UNSIGNED NOT NULL,
    `BumpReason` VARCHAR(64) NOT NULL,
    `ChangedBy` VARCHAR(255) DEFAULT NULL,
    `ChangedAt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`AuditID`),
    KEY `IX_FUNCTION_REGISTRY_AUDIT_FUNCTION` (`FunctionKey`),
    CONSTRAINT `FK_FUNCTION_REGISTRY_AUDIT_FUNCTION`
        FOREIGN KEY (`FunctionKey`) REFERENCES `function_registry` (`FunctionKey`)
) ENGINE=InnoDB;