CREATE DATABASE IF NOT EXISTS `humans`;
USE `humans`;

CREATE TABLE IF NOT EXISTS `component_manifests` (
    `ComponentManifestID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Component` ENUM('FE', 'MW', 'DB') NOT NULL,
    `Version` VARCHAR(32) NOT NULL,
    `DockerImageTag` VARCHAR(255) DEFAULT NULL,
    `SourceCommit` CHAR(64) DEFAULT NULL,
    `ManifestSha256` CHAR(64) NOT NULL,
    `ManifestJson` LONGTEXT NOT NULL,
    `GeneratedAt` DATETIME(6) DEFAULT NULL,
    `RecordedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `Status` ENUM('registered', 'active', 'superseded') NOT NULL DEFAULT 'registered',
    PRIMARY KEY (`ComponentManifestID`),
    UNIQUE KEY `UQ_COMPONENT_MANIFESTS_COMPONENT_HASH` (`Component`, `ManifestSha256`),
    KEY `IX_COMPONENT_MANIFESTS_COMPONENT_STATUS` (`Component`, `Status`),
    CONSTRAINT `CK_COMPONENT_MANIFESTS_JSON` CHECK (JSON_VALID(`ManifestJson`))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `stack_manifests` (
    `StackManifestID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `StackBuildNumber` BIGINT UNSIGNED NOT NULL,
    `StackManifestSha256` CHAR(64) NOT NULL,
    `ManifestJson` LONGTEXT NOT NULL,
    `CompatibilityStatus` ENUM('passed', 'failed') NOT NULL,
    `CompatibilityErrors` LONGTEXT DEFAULT NULL,
    `RecordedAt` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `ActivatedAt` DATETIME(6) DEFAULT NULL,
    `Status` ENUM('registered', 'active', 'superseded') NOT NULL DEFAULT 'registered',
    PRIMARY KEY (`StackManifestID`),
    UNIQUE KEY `UQ_STACK_MANIFESTS_BUILD_HASH` (`StackBuildNumber`, `StackManifestSha256`),
    KEY `IX_STACK_MANIFESTS_STATUS` (`Status`),
    CONSTRAINT `CK_STACK_MANIFESTS_JSON` CHECK (JSON_VALID(`ManifestJson`)),
    CONSTRAINT `CK_STACK_MANIFESTS_ERRORS_JSON` CHECK (`CompatibilityErrors` IS NULL OR JSON_VALID(`CompatibilityErrors`))
) ENGINE=InnoDB;
