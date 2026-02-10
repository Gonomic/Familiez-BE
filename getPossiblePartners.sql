CREATE PROCEDURE `getPossiblePartners`(IN `PersonIDin` INT(11))
    SQL SECURITY INVOKER
    COMMENT 'To get the possible partners of a person based on the persons birth date'
BEGIN

    DECLARE CompletedOk int;

 	DECLARE NewTransNo int;

	DECLARE TransResult int;

	DECLARE RecCount int;
    
    DECLARE PersonIDinBirthdate date;

	DECLARE MessageText CHAR;

	DECLARE ReturnedSqlState INT;

	DECLARE MySQLErrNo INT;
        
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN

		GET CURRENT DIAGNOSTICS CONDITION 1 MessageText = message_text, ReturnedSqlState = RETURNED_SQLSTATE, MySqlErrNo = MYSQL_ERRNO;
        
		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC getPossiblePartners(). Error occured(M=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySqlErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;

main_proc:

BEGIN

	SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("getPossiblePartners");

    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ' START Sproc: getPossiblePartners(). TransResult= ', IFNULL(TransResult, 'null'), '. Start opbouwen tabel met mogelijke partners gebaseerd op persoon: ', IFNULL(PersonIDin, 'null')),
			TestLogDateTime = NOW();
            
	SET PersonIDinBirthdate = fGetBirthDateOfPerson(PersonIDin);
    
    SELECT DISTINCT
    
		P.PersonID as PersonID, 

		concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossiblePartner,

		concat('(', P.PersonDateOfBirth, ')') as PersonDateOfBirth,
        
        P.PersonDateOfBirth as SortDate,
        
		P.PersonDateOfDeath

		FROM persons P 

        WHERE P.PersonID <> PersonIDin

		AND YEAR(P.PersonDateOfBirth) > YEAR(PersonIDinBirthdate) - 25

		AND YEAR(P.PersonDateOfBirth) < YEAR(PersonIDinBirthdate) + 25
	
 		AND P.PersonID NOT IN 

    		(SELECT RelationWithPerson

				FROM relations R

				JOIN (relationnames RN, persons P)

				ON (R.RelationName = RN.RelationnameID 
                
                AND P.PersonID = R.RelationPerson 
                
                AND (RN.RelationnameName = "Vader" OR RN.RelationnameName = "Moeder")))


		ORDER BY SortDate;    

	INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. END Sproc: getPOssiblePartners(). TransResult= ', IFNULL(TransResult, 'null'), '. Lijst met mogelijke partners afgerond.'),

				TestLogDateTime = NOW();

 END;
 END