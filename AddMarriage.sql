DELIMITER $$
DROP PROCEDURE IF EXISTS `AddMarriage`$$
CREATE PROCEDURE `AddMarriage`(
    IN PersonAIdIn INT(11),
    IN PersonBIdIn INT(11),
    IN StartDateIn DATE
)
    SQL SECURITY INVOKER
    COMMENT 'Backward compatible wrapper without marriage place parameter'
BEGIN
    CALL AddMarriage_v2(PersonAIdIn, PersonBIdIn, StartDateIn, NULL);
END$$
DELIMITER ;