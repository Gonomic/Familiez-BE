DELIMITER $$
DROP PROCEDURE IF EXISTS `UpdateMarriageStartDate`$$
CREATE PROCEDURE `UpdateMarriageStartDate`(
    IN MarriageIdIn INT(11),
    IN PersonAIdIn INT(11),
    IN PersonBIdIn INT(11),
    IN StartDateIn DATE
)
    SQL SECURITY INVOKER
    COMMENT 'Backward compatible wrapper without marriage place parameter'
BEGIN
    CALL UpdateMarriageStartDate_v2(MarriageIdIn, PersonAIdIn, PersonBIdIn, StartDateIn, NULL);
END$$
DELIMITER ;
