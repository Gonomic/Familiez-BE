-- Ping Database Server Procedure
DELIMITER $$
DROP PROCEDURE IF EXISTS `PingedDbServer`$$
CREATE PROCEDURE `PingedDbServer`(
    IN timestampFErequest DATETIME,
    IN timestampMWrequest DATETIME
)
    SQL SECURITY INVOKER
    COMMENT 'Returns ping timestamps for system health check'
BEGIN
    DECLARE timestampBErequest DATETIME;
    DECLARE timestampBEanswer DATETIME;
    
    SET timestampBErequest = NOW();
    SET timestampBEanswer = NOW();
    
    SELECT 
        timestampFErequest AS datetimeFErequest,
        timestampMWrequest AS datetimeMWrequest,
        timestampBErequest AS datetimeBErequest,
        timestampBEanswer AS datetimeBEanswer;
END$$
DELIMITER ;
