DELIMITER $$
DROP PROCEDURE IF EXISTS `PublishStackManifest`$$
CREATE PROCEDURE `PublishStackManifest`(
    IN StackBuildNumberIn BIGINT UNSIGNED,
    IN StackManifestSha256In CHAR(64),
    IN ManifestJsonIn LONGTEXT,
    IN CompatibilityStatusIn VARCHAR(10),
    IN CompatibilityErrorsIn LONGTEXT,
    IN ChangedByIn VARCHAR(255)
)
    SQL SECURITY INVOKER
    COMMENT 'Register and activate a validated stack manifest'
BEGIN
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE TransResult INT DEFAULT 200;
    DECLARE StackManifestIDOut BIGINT UNSIGNED DEFAULT NULL;
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
        ROLLBACK;
        SET CompletedOk = 2;
        SET TransResult = 500;
        SET ErrorMessage = LEFT(MessageText, 255);
        INSERT INTO humans.testlog (TestLog, TestLogDateTime) VALUES (
            CONCAT('PublishStackManifest error State=', ReturnedSqlState,
                   ', ErrNo=', MySQLErrNo, ', Msg=', MessageText, ' [ROLLBACK]'), NOW());
        SELECT CompletedOk, TransResult AS Result, ErrorMessage, StackManifestIDOut;
    END;

main_proc: BEGIN
    IF StackBuildNumberIn IS NULL OR StackBuildNumberIn < 1
        OR StackManifestSha256In IS NULL OR CHAR_LENGTH(StackManifestSha256In) <> 64
        OR ManifestJsonIn IS NULL OR JSON_VALID(ManifestJsonIn) = 0
        OR CompatibilityStatusIn IS NULL OR CompatibilityStatusIn NOT IN ('passed', 'failed')
        OR (CompatibilityErrorsIn IS NOT NULL AND JSON_VALID(CompatibilityErrorsIn) = 0) THEN
        SET CompletedOk = 1;
        SET TransResult = 400;
        SET ErrorMessage = 'Invalid stack manifest input';
        LEAVE main_proc;
    END IF;

    IF CompatibilityStatusIn <> 'passed' THEN
        SET CompletedOk = 1;
        SET TransResult = 422;
        SET ErrorMessage = 'Only a compatible stack manifest can be activated';
        LEAVE main_proc;
    END IF;

    START TRANSACTION;
    UPDATE humans.stack_manifests
       SET Status = 'superseded'
     WHERE Status = 'active';

    INSERT INTO humans.stack_manifests
        (StackBuildNumber, StackManifestSha256, ManifestJson, CompatibilityStatus,
         CompatibilityErrors, ActivatedAt, Status)
    VALUES
        (StackBuildNumberIn, StackManifestSha256In, ManifestJsonIn, CompatibilityStatusIn,
         CompatibilityErrorsIn, NOW(6), 'active')
    ON DUPLICATE KEY UPDATE
        ManifestJson = VALUES(ManifestJson),
        CompatibilityStatus = VALUES(CompatibilityStatus),
        CompatibilityErrors = VALUES(CompatibilityErrors),
        ActivatedAt = VALUES(ActivatedAt),
        Status = 'active';

    SET StackManifestIDOut = LAST_INSERT_ID();
    COMMIT;

    SELECT CompletedOk, TransResult AS Result, ErrorMessage, StackManifestIDOut;
END main_proc;
END$$
DELIMITER ;
