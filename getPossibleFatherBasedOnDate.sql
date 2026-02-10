CREATE PROCEDURE `getPossibleFathersBasedOnDate`(IN `DateIn` DATE)
    SQL SECURITY INVOKER
    COMMENT 'To get possible fathers based on a certain date'
BEGIN

    DECLARE CompletedOk int;

	DECLARE NewTransNo int;

	DECLARE TransResult int;

	DECLARE RecCount int;

	DECLARE FullNamePerson varchar(100);

	DECLARE BirthDateOfPersonIn date;
    
	DECLARE MessageText CHAR;

	DECLARE ReturnedSqlState INT;

	DECLARE MySQLErrNo INT;
        
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN

		GET CURRENT DIAGNOSTICS CONDITION 1 MessageText = message_text, ReturnedSqlState = RETURNED_SQLSTATE, MySqlErrNo = MYSQL_ERRNO;
        
		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC getPossibleFathersBasedOnDate(). Error occured(M=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySqlErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;

main_proc:

BEGIN

    SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("getPossibleFathersBasedOnDate");

    
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ' START Sproc: getPossibleFathersBasedOnDate(). TransResult= ', TransResult, '. Start opbouwen tabel met mogelijke vaders op basis van datum= ', DateIn),
			TestLogDateTime = NOW();
    
    	SELECT DISTINCT

		PersonID, 

		concat(PersonGivvenName, ' ', PersonFamilyName) as PossibleFather,
        
        concat('(', PersonDateOfBirth, ')') as PersonDateOfBirth,
        
        PersonDateOfBirth as SortDate,
        
        PersonDateOfDeath 
    
    FROM persons  

		WHERE YEAR(PersonDateOfBirth) < (YEAR(DateIn) - 10)

		AND YEAR(PersonDateOfBirth) > (YEAR(DateIn) - 65)
        
        AND PersonIsMale = true

       ORDER BY SortDate;

    INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. END Sproc: getPossibleFathersBasedOnDate(). TransResult= ', IFNULL(TransResult, 'null'), '. Lijst met mogelijke vades afgerond.'),

				TestLogDateTime = NOW();

 END;

END