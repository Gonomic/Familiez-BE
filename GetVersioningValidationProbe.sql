DELIMITER $$
DROP PROCEDURE IF EXISTS `GetVersioningValidationProbe`$$
CREATE PROCEDURE `GetVersioningValidationProbe`()
    SQL SECURITY INVOKER
    COMMENT 'Return a harmless result for local versioning end-to-end validation'
BEGIN
    SELECT 'versioning-validation-ok' AS ProbeStatus;
END$$
DELIMITER ;