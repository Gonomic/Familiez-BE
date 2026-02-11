-- Ping Database Server Procedure
DELIMITER $$
DROP PROCEDURE IF EXISTS `PingedDbServer`$$
CREATE PROCEDURE `PingedDbServer`(
    IN timestampFErequest DATETIME(6),
    IN timestampMWrequest DATETIME(6)
)
    SQL SECURITY INVOKER
    COMMENT 'Returns ping timestamps for system health check'
BEGIN
    DECLARE timestampBErequest DATETIME(6);
    DECLARE timestampBEanswer DATETIME(6);
    
    SET timestampBErequest = NOW(6);
    SET timestampBEanswer = NOW(6);
    
    SELECT 
        CONCAT(DATE_FORMAT(timestampFErequest, '%Y-%m-%dT%H:%i:%S.'), LPAD(FLOOR(MICROSECOND(timestampFErequest) / 1000), 3, '0')) AS datetimeFErequest,
        CONCAT(DATE_FORMAT(timestampMWrequest, '%Y-%m-%dT%H:%i:%S.'), LPAD(FLOOR(MICROSECOND(timestampMWrequest) / 1000), 3, '0')) AS datetimeMWrequest,
        CONCAT(DATE_FORMAT(timestampBErequest, '%Y-%m-%dT%H:%i:%S.'), LPAD(FLOOR(MICROSECOND(timestampBErequest) / 1000), 3, '0')) AS datetimeBErequest,
        CONCAT(DATE_FORMAT(timestampBEanswer, '%Y-%m-%dT%H:%i:%S.'), LPAD(FLOOR(MICROSECOND(timestampBEanswer) / 1000), 3, '0')) AS datetimeBEanswer;
END$$
DELIMITER ;
