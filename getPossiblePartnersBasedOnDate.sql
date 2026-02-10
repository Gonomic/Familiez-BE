CREATE PROCEDURE `getPossiblePartnersBasedOnDate`(IN `DateIn` DATE)
    SQL SECURITY INVOKER
    COMMENT 'To get possible partners based on a certain date'
BEGIN

    DECLARE CompletedOk int;

	DECLARE NewTransNo int;

	DECLARE TransResult int;

	DECLARE RecCount int;


	DECLARE MessageText CHAR;

	DECLARE ReturnedSqlState INT;

	DECLARE MySQLErrNo INT;
        
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN

		GET CURRENT DIAGNOSTICS CONDITION 1 MessageText = message_text, ReturnedSqlState = RETURNED_SQLSTATE, MySqlErrNo = MYSQL_ERRNO;
        
		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC getPossiblePartnersBasedOnDate(). Error occured(M=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySqlErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;

main_proc:

BEGIN

	SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("getPossiblePartnersBasedOnDate");

    
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ' START Sproc: getPossiblePartnersBasedOnDate(). TransResult= ', IFNULL(TransResult, 'null'), '. Start opbouwen tabel met mogelijke partners gebaseerd op datum= ', IFNULL(DateIn, 'null')),
			TestLogDateTime = NOW();


    SELECT DISTINCT

        P.PersonID as PersonID, 

		concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as PossiblePartner,

		concat('(', P.PersonDateOfBirth, ')') as PersonDateOfBirth,
        
        P.PersonDateOfBirth as SortDate,
        
		P.PersonDateOfDeath

		FROM persons P 

		WHERE 
			YEAR(P.PersonDateOfBirth) > (YEAR(DateIn) - 25)
    
			AND YEAR(P.PersonDateOfBirth) < (YEAR(DateIn) + 25)

		ORDER BY SortDate;    

	INSERT INTO humans.testlog

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. END Sproc: getPOssiblePartnersBasedOnDate(). TransResult= ', IFNULL(TransResult, 'null'), '. Lijst met mogelijke partners afgerond.'),

				TestLogDateTime = NOW();
 END;
 
 END