DELIMITER $$
DROP PROCEDURE IF EXISTS `GetActiveStackManifest`$$
CREATE PROCEDURE `GetActiveStackManifest`()
    SQL SECURITY INVOKER
    COMMENT 'Read the active compatible stack manifest as JSON'
BEGIN
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE TransResult INT DEFAULT 200;
    DECLARE ErrorMessage VARCHAR(255) DEFAULT NULL;
    DECLARE MessageText VARCHAR(1024);
    DECLARE ReturnedSqlState VARCHAR(10);
    DECLARE MySQLErrNo INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET CURRENT DIAGNOSTICS CONDITION 1
            MessageText = MESSAGE_TEXT,
            ReturnedSqlState = RETURNED_SQLSTATE,
            MySQLErrNo = MYSQL_ERRNO;
        SET CompletedOk = 2;
        SET TransResult = 500;
        SET ErrorMessage = LEFT(MessageText, 255);
        INSERT INTO humans.testlog (TestLog, TestLogDateTime) VALUES (
            CONCAT('GetActiveStackManifest error State=', ReturnedSqlState,
                   ', ErrNo=', MySQLErrNo, ', Msg=', MessageText), NOW());
        SELECT CompletedOk, TransResult AS Result, ErrorMessage, NULL AS StackManifest;
    END;

    SELECT CompletedOk, TransResult AS Result, ErrorMessage,
           COALESCE((
               SELECT ManifestJson
                 FROM humans.stack_manifests
                WHERE Status = 'active'
                  AND CompatibilityStatus = 'passed'
                ORDER BY StackBuildNumber DESC, StackManifestID DESC
                LIMIT 1
           ), JSON_OBJECT()) AS StackManifest;
END$$
DELIMITER ;
