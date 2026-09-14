DELIMITER $$
DROP PROCEDURE IF EXISTS `GetFunctionCapabilities`$$
CREATE PROCEDURE `GetFunctionCapabilities`()
    SQL SECURITY INVOKER
    COMMENT 'Read the function registry and direct dependency graph as one JSON result'
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
        INSERT INTO humans.testlog
            SET TestLog = CONCAT(
                'SPROC GetFunctionCapabilities() failed. State=', IFNULL(ReturnedSqlState, 'null'),
                ', ErrNo=', IFNULL(MySQLErrNo, 'null'),
                ', Msg=', IFNULL(MessageText, 'null')
            ),
                TestLogDateTime = NOW();
        SELECT CompletedOk AS CompletedOk,
               TransResult AS Result,
               ErrorMessage AS ErrorMessage,
               JSON_OBJECT('functions', JSON_ARRAY(), 'dependencies', JSON_ARRAY()) AS Capabilities;
    END;

    SELECT CompletedOk AS CompletedOk,
           TransResult AS Result,
           ErrorMessage AS ErrorMessage,
           JSON_OBJECT(
               'functions', COALESCE((
                   SELECT JSON_ARRAYAGG(JSON_OBJECT(
                       'key', FunctionKey,
                       'layer', Layer,
                       'name', FunctionName,
                       'version', CONCAT('v', Version),
                       'signatureHash', SignatureHash,
                       'lastChangedCommit', LastChangedCommit,
                       'lastChangedAt', LastChangedAt,
                       'status', Status
                   ))
                   FROM humans.function_registry
                  WHERE Status = 'active'
               ), JSON_ARRAY()),
               'dependencies', COALESCE((
                   SELECT JSON_ARRAYAGG(JSON_OBJECT(
                       'key', DependencyKey,
                       'callerFunctionKey', CallerFunctionKey,
                       'calleeFunctionKey', CalleeFunctionKey,
                       'requiredMinVersion', CONCAT('v', RequiredMinVersion)
                   ))
                                     FROM humans.function_dependencies d
                                    JOIN humans.function_registry caller
                                        ON caller.FunctionKey = d.CallerFunctionKey
                                     AND caller.Status = 'active'
                                    JOIN humans.function_registry callee
                                        ON callee.FunctionKey = d.CalleeFunctionKey
                                     AND callee.Status = 'active'
               ), JSON_ARRAY())
           ) AS Capabilities;
END$$
DELIMITER ;