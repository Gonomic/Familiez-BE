DELIMITER $$
DROP PROCEDURE IF EXISTS `UpdateFunctionRegistry`$$
CREATE PROCEDURE `UpdateFunctionRegistry`(
    IN `LayerIn` VARCHAR(10),
    IN `FunctionNameIn` VARCHAR(255),
    IN `VersionIn` INT UNSIGNED,
    IN `SignatureHashIn` CHAR(64),
    IN `LastChangedCommitIn` VARCHAR(64),
    IN `StatusIn` VARCHAR(20),
    IN `BumpReasonIn` VARCHAR(64),
    IN `ChangedByIn` VARCHAR(255)
)
    SQL SECURITY INVOKER
    COMMENT 'Insert or update a function registry entry and record version changes'
BEGIN
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE TransResult INT DEFAULT 200;
    DECLARE NewTransNo INT DEFAULT NULL;
    DECLARE FunctionKeyOut VARCHAR(511) DEFAULT NULL;
    DECLARE ExistingVersion INT UNSIGNED DEFAULT NULL;
    DECLARE ExistingSignatureHash CHAR(64) DEFAULT NULL;
    DECLARE ExistingCount INT DEFAULT 0;
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

        INSERT INTO humans.testlog
            SET TestLog = CONCAT(
                'TransAction-', IFNULL(NewTransNo, 'null'),
                '. SPROC UpdateFunctionRegistry() failed. State=', IFNULL(ReturnedSqlState, 'null'),
                ', ErrNo=', IFNULL(MySQLErrNo, 'null'),
                ', Msg=', IFNULL(MessageText, 'null'),
                '. Rollback executed. CompletedOk=', CompletedOk
            ),
                TestLogDateTime = NOW();

        SELECT CompletedOk AS CompletedOk,
               TransResult AS Result,
               ErrorMessage AS ErrorMessage,
               FunctionKeyOut AS FunctionKey;
    END;

main_proc:
BEGIN
    SET NewTransNo = GetTranNo('UpdateFunctionRegistry');

    IF LayerIn IS NULL OR LayerIn NOT IN ('FE', 'MW', 'BE')
        OR FunctionNameIn IS NULL OR NULLIF(TRIM(FunctionNameIn), '') IS NULL
        OR VersionIn IS NULL OR VersionIn < 1
        OR SignatureHashIn IS NULL OR CHAR_LENGTH(SignatureHashIn) <> 64
        OR StatusIn IS NULL OR StatusIn NOT IN ('active', 'deprecated', 'removed')
        OR BumpReasonIn IS NULL OR NULLIF(TRIM(BumpReasonIn), '') IS NULL THEN
        SET CompletedOk = 1;
        SET TransResult = 400;
        SET ErrorMessage = 'Invalid function registry input';
        LEAVE main_proc;
    END IF;

    INSERT INTO humans.testlog
        SET TestLog = CONCAT(
            'TransAction-', IFNULL(NewTransNo, 'null'),
            '. Start SPROC UpdateFunctionRegistry(). Layer=', LayerIn,
            ', FunctionName=', FunctionNameIn
        ),
            TestLogDateTime = NOW();

    START TRANSACTION;

    SELECT COUNT(*)
      INTO ExistingCount
      FROM humans.function_registry
     WHERE Layer = LayerIn
       AND FunctionName = FunctionNameIn;

    IF ExistingCount = 0 THEN
        SET FunctionKeyOut = CONCAT(LayerIn, ':', FunctionNameIn);

        INSERT INTO humans.function_registry
            (FunctionKey, Layer, FunctionName, Version, SignatureHash, LastChangedCommit, LastChangedAt, Status)
        VALUES
            (FunctionKeyOut, LayerIn, FunctionNameIn, VersionIn, SignatureHashIn, LastChangedCommitIn, NOW(), StatusIn);

        INSERT INTO humans.function_registry_audit
            (FunctionKey, OldVersion, NewVersion, BumpReason, ChangedBy, ChangedAt)
        VALUES
            (FunctionKeyOut, NULL, VersionIn, BumpReasonIn, ChangedByIn, NOW());
    ELSE
        SELECT FunctionKey, Version, SignatureHash
          INTO FunctionKeyOut, ExistingVersion, ExistingSignatureHash
          FROM humans.function_registry
         WHERE Layer = LayerIn
           AND FunctionName = FunctionNameIn
         FOR UPDATE;

        UPDATE humans.function_registry
           SET Version = VersionIn,
               SignatureHash = SignatureHashIn,
               LastChangedCommit = LastChangedCommitIn,
               LastChangedAt = IF(
                   VersionIn <> ExistingVersion OR SignatureHashIn <> ExistingSignatureHash,
                   NOW(),
                   LastChangedAt
               ),
               Status = StatusIn
         WHERE FunctionKey = FunctionKeyOut;

        IF VersionIn <> ExistingVersion OR SignatureHashIn <> ExistingSignatureHash THEN
            INSERT INTO humans.function_registry_audit
                (FunctionKey, OldVersion, NewVersion, BumpReason, ChangedBy, ChangedAt)
            VALUES
                (FunctionKeyOut, ExistingVersion, VersionIn, BumpReasonIn, ChangedByIn, NOW());
        END IF;
    END IF;

    COMMIT;

    INSERT INTO humans.testlog
        SET TestLog = CONCAT(
            'TransAction-', IFNULL(NewTransNo, 'null'),
            '. End SPROC UpdateFunctionRegistry(). CompletedOk=', CompletedOk,
            ', Result=', TransResult,
            ', FunctionKey=', IFNULL(FunctionKeyOut, 'null')
        ),
            TestLogDateTime = NOW();
END;

SELECT CompletedOk AS CompletedOk,
       TransResult AS Result,
       ErrorMessage AS ErrorMessage,
    FunctionKeyOut AS FunctionKey;
END$$
DELIMITER ;