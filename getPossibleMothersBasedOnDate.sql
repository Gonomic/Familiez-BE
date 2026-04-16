CREATE PROCEDURE `getPossibleMothersBasedOnDate`(IN `DateIn` DATE)
    SQL SECURITY INVOKER
    COMMENT 'To get possible mothers based on a certain date'
BEGIN

    DECLARE CompletedOk int;

	DECLARE NewTransNo int;

	DECLARE TransResult int;

	DECLARE RecCount int;

	DECLARE MessageText VARCHAR(1024);

	DECLARE ReturnedSqlState VARCHAR(10);

	DECLARE MySQLErrNo INT;
        
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN

		GET CURRENT DIAGNOSTICS CONDITION 1 MessageText = MESSAGE_TEXT, ReturnedSqlState = RETURNED_SQLSTATE, MySQLErrNo = MYSQL_ERRNO;
        
		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC getPossibleMothersBasedOnDate(). Error occured(M=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySQLErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;

main_proc:

BEGIN

    SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("getPossibleMothersBasedOnDate");

    
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ' START Sproc: getPossibleMothersBasedOnDate(). TransResult= ', IFNULL(TransResult, 'null'), '. Start opbouwen tabel met mogelijke moeders gebaseerd op datum= ', IFNULL(DateIn, 'null')),
			TestLogDateTime = NOW();

   	SELECT DISTINCT

		PersonID, 

		concat(PersonGivvenName, ' ', PersonFamilyName) as PossibleMother,
        
        concat('(', PersonDateOfBirth, ')') as PersonDateOfBirth,
        
        PersonDateOfBirth as SortDate,
        
        PersonDateOfDeath 
        
    FROM persons  

		WHERE YEAR(PersonDateOfBirth) < (YEAR(DateIn) - 10)

		AND YEAR(PersonDateOfBirth) > (YEAR(DateIn) - 65)
        
        AND PersonIsMale = false
        
       ORDER BY SortDate;

    INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. END Sproc: getPOssibleMothersBasedOnDate(). TransResult= ', IFNULL(TransResult, 'null'), '. Lijst met mogelijke moeders afgerond.'),

				TestLogDateTime = NOW();

 END;

END