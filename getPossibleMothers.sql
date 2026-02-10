CREATE PROCEDURE `getPossibleMothers`(IN `PersonIDin` INT(11))
    SQL SECURITY INVOKER
    COMMENT 'To get the possible mothers of a person based on the persons birthdate'
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

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC getPossibleMothers(). Error occured(M=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySqlErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;

main_proc:

BEGIN

    SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("getPossibleMothers");

    
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ' START Sproc: getPossibleMothers(). TransResult= ', TransResult, '. Start opbouwen tabel met mogelijke moeders voor persoon met ID= ', PersonIdIn),
			TestLogDateTime = NOW();

    
    SET BirthDateOfPersonIn = fGetBirthDateOfPerson(PersonIDin);

	SELECT DISTINCT

		PersonID, 

		concat(PersonGivvenName, ' ', PersonFamilyName) as PossibleMother,
        
        concat('(', PersonDateOfBirth, ')') as PersonDateOfBirth,  
        
        PersonDateOfBirth as SortDate,
        
        PersonDateOfDeath 
        
    FROM persons  

		WHERE PersonID <> PersonIDin

		AND YEAR(PersonDateOfBirth) < (YEAR(BirthDateOfPersonIn) - 10)

		AND YEAR(PersonDateOfBirth) > (YEAR(BirthDateOfPersonIn) - 65)
        
        AND PersonIsMale = false
        
       ORDER BY SortDate;

    INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. END Sproc: getPOssibleMothers(). TransResult= ', IFNULL(TransResult, 'null'), '. Lijst met mogelijke moeders afgerond.'),

				TestLogDateTime = NOW();

 END;

END