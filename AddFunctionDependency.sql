DELIMITER $$
DROP PROCEDURE IF EXISTS `AddFunctionDependency`$$
CREATE PROCEDURE `AddFunctionDependency`(
    IN `CallerFunctionKeyIn` VARCHAR(511),
    IN `CalleeFunctionKeyIn` VARCHAR(511),
    IN `RequiredMinVersionIn` INT UNSIGNED
)
    SQL SECURITY INVOKER
    COMMENT 'Insert or update a direct function dependency'
BEGIN
    DECLARE CompletedOk INT DEFAULT 0;
    DECLARE TransResult INT DEFAULT 200;
    DECLARE NewTransNo INT DEFAULT NULL;
    DECLARE DependencyKeyOut VARCHAR(1023) DEFAULT NULL;
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
               DependencyKeyOut AS DependencyKey;
    END;

main_proc:
BEGIN
    SET NewTransNo = GetTranNo('AddFunctionDependency');

    IF CallerFunctionKeyIn IS NULL
        OR CalleeFunctionKeyIn IS NULL
        OR NULLIF(TRIM(CallerFunctionKeyIn), '') IS NULL
        OR NULLIF(TRIM(CalleeFunctionKeyIn), '') IS NULL
        OR CallerFunctionKeyIn = CalleeFunctionKeyIn
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
            '. Start SPROC AddFunctionDependency(). CallerFunctionKey=', CallerFunctionKeyIn,
            ', CalleeFunctionKey=', CalleeFunctionKeyIn
        ),
            TestLogDateTime = NOW();

    START TRANSACTION;

    SELECT COUNT(*)
      INTO ExistingCount
      FROM humans.function_dependencies
         WHERE CallerFunctionKey = CallerFunctionKeyIn
             AND CalleeFunctionKey = CalleeFunctionKeyIn;

    IF ExistingCount = 0 THEN
        INSERT INTO humans.function_dependencies
                        (DependencyKey, CallerFunctionKey, CalleeFunctionKey, RequiredMinVersion)
        VALUES
                        (CONCAT(CallerFunctionKeyIn, '->', CalleeFunctionKeyIn), CallerFunctionKeyIn, CalleeFunctionKeyIn, RequiredMinVersionIn);

                SET DependencyKeyOut = CONCAT(CallerFunctionKeyIn, '->', CalleeFunctionKeyIn);
    ELSE
                SELECT DependencyKey
                    INTO DependencyKeyOut
          FROM humans.function_dependencies
                 WHERE CallerFunctionKey = CallerFunctionKeyIn
                     AND CalleeFunctionKey = CalleeFunctionKeyIn
         FOR UPDATE;

        UPDATE humans.function_dependencies
           SET RequiredMinVersion = RequiredMinVersionIn
                 WHERE DependencyKey = DependencyKeyOut;
    END IF;

    COMMIT;

    INSERT INTO humans.testlog
        SET TestLog = CONCAT(
            'TransAction-', IFNULL(NewTransNo, 'null'),
            '. End SPROC AddFunctionDependency(). CompletedOk=', CompletedOk,
            ', Result=', TransResult,
            ', DependencyKey=', IFNULL(DependencyKeyOut, 'null')
        ),
            TestLogDateTime = NOW();
END;

SELECT CompletedOk AS CompletedOk,
       TransResult AS Result,
       ErrorMessage AS ErrorMessage,
    DependencyKeyOut AS DependencyKey;
END$$
DELIMITER ;