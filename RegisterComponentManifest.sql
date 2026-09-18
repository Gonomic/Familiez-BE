DELIMITER $$
DROP PROCEDURE IF EXISTS `RegisterComponentManifest`$$
CREATE PROCEDURE `RegisterComponentManifest`(
    IN ComponentIn VARCHAR(3),
    IN VersionIn VARCHAR(32),
    IN DockerImageTagIn VARCHAR(255),
    IN SourceCommitIn CHAR(64),
    IN ManifestSha256In CHAR(64),
    IN ManifestJsonIn LONGTEXT,
    IN GeneratedAtIn DATETIME(6),
    IN ChangedByIn VARCHAR(255)
)
    SQL SECURITY INVOKER
    COMMENT 'Register an immutable FE, MW or DB component manifest'
BEGIN
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE TransResult INT DEFAULT 200;
    DECLARE ManifestIDOut BIGINT UNSIGNED DEFAULT NULL;
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
            CONCAT('RegisterComponentManifest error State=', ReturnedSqlState,
                   ', ErrNo=', MySQLErrNo, ', Msg=', MessageText, ' [ROLLBACK]'), NOW());
        SELECT CompletedOk, TransResult AS Result, ErrorMessage, ManifestIDOut AS ComponentManifestID;
    END;

main_proc: BEGIN
    IF ComponentIn IS NULL OR ComponentIn NOT IN ('FE', 'MW', 'DB')
        OR VersionIn IS NULL OR NULLIF(TRIM(VersionIn), '') IS NULL
        OR ManifestSha256In IS NULL OR CHAR_LENGTH(ManifestSha256In) <> 64
        OR ManifestJsonIn IS NULL OR JSON_VALID(ManifestJsonIn) = 0 THEN
        SET CompletedOk = 1;
        SET TransResult = 400;
        SET ErrorMessage = 'Invalid component manifest input';
        LEAVE main_proc;
    END IF;

    START TRANSACTION;
    SELECT ComponentManifestID INTO ManifestIDOut
      FROM humans.component_manifests
     WHERE Component = ComponentIn AND ManifestSha256 = ManifestSha256In
     FOR UPDATE;

    IF ManifestIDOut IS NULL THEN
        INSERT INTO humans.component_manifests
            (Component, Version, DockerImageTag, SourceCommit, ManifestSha256,
             ManifestJson, GeneratedAt, Status)
        VALUES
            (ComponentIn, VersionIn, DockerImageTagIn, SourceCommitIn, ManifestSha256In,
             ManifestJsonIn, GeneratedAtIn, 'registered');
        SET ManifestIDOut = LAST_INSERT_ID();
    END IF;
    COMMIT;

    SELECT CompletedOk, TransResult AS Result, ErrorMessage,
           ManifestIDOut AS ComponentManifestID;
END main_proc;
END$$
DELIMITER ;
