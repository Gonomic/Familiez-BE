DELIMITER $$
DROP PROCEDURE IF EXISTS `AddFunctionDependency`$$
CREATE PROCEDURE `AddFunctionDependency`(
    IN `CallerFunctionIDIn` INT UNSIGNED,
    IN `CalleeFunctionIDIn` INT UNSIGNED,
    IN `RequiredMinVersionIn` INT UNSIGNED
)
    SQL SECURITY INVOKER
    COMMENT 'Insert or update a direct function dependency'
BEGIN
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE TransResult INT DEFAULT 200;
    DECLARE NewTransNo INT DEFAULT NULL;
    DECLARE DependencyIDOut INT UNSIGNED DEFAULT NULL;
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
                '. SPROC AddFunctionDependency() failed. State=', IFNULL(ReturnedSqlState, 'null'),
                ', ErrNo=', IFNULL(MySQLErrNo, 'null'),
                ', Msg=', IFNULL(MessageText, 'null'),
                '. Rollback executed. CompletedOk=', CompletedOk
            ),
                TestLogDateTime = NOW();

        SELECT CompletedOk AS CompletedOk,
               TransResult AS Result,
               ErrorMessage AS ErrorMessage,
               DependencyIDOut AS DependencyID;
    END;

main_proc:
BEGIN
    SET NewTransNo = GetTranNo('AddFunctionDependency');

    IF CallerFunctionIDIn IS NULL
        OR CalleeFunctionIDIn IS NULL
        OR CallerFunctionIDIn = CalleeFunctionIDIn
        OR RequiredMinVersionIn IS NULL
        OR RequiredMinVersionIn < 1 THEN
        SET CompletedOk = 1;
        SET TransResult = 400;
        SET ErrorMessage = 'Invalid function dependency input';
        LEAVE main_proc;
    END IF;

    INSERT INTO humans.testlog
        SET TestLog = CONCAT(
            'TransAction-', IFNULL(NewTransNo, 'null'),
            '. Start SPROC AddFunctionDependency(). CallerFunctionID=', CallerFunctionIDIn,
            ', CalleeFunctionID=', CalleeFunctionIDIn
        ),
            TestLogDateTime = NOW();

    START TRANSACTION;

    SELECT COUNT(*)
      INTO ExistingCount
      FROM humans.function_dependencies
     WHERE CallerFunctionID = CallerFunctionIDIn
       AND CalleeFunctionID = CalleeFunctionIDIn;

    IF ExistingCount = 0 THEN
        INSERT INTO humans.function_dependencies
            (CallerFunctionID, CalleeFunctionID, RequiredMinVersion)
        VALUES
            (CallerFunctionIDIn, CalleeFunctionIDIn, RequiredMinVersionIn);

        SET DependencyIDOut = LAST_INSERT_ID();
    ELSE
        SELECT DependencyID
          INTO DependencyIDOut
          FROM humans.function_dependencies
         WHERE CallerFunctionID = CallerFunctionIDIn
           AND CalleeFunctionID = CalleeFunctionIDIn
         FOR UPDATE;

        UPDATE humans.function_dependencies
           SET RequiredMinVersion = RequiredMinVersionIn
         WHERE DependencyID = DependencyIDOut;
    END IF;

    COMMIT;

    INSERT INTO humans.testlog
        SET TestLog = CONCAT(
            'TransAction-', IFNULL(NewTransNo, 'null'),
            '. End SPROC AddFunctionDependency(). CompletedOk=', CompletedOk,
            ', Result=', TransResult,
            ', DependencyID=', IFNULL(DependencyIDOut, 'null')
        ),
            TestLogDateTime = NOW();
END;

SELECT CompletedOk AS CompletedOk,
       TransResult AS Result,
       ErrorMessage AS ErrorMessage,
       DependencyIDOut AS DependencyID;
END$$
DELIMITER ;