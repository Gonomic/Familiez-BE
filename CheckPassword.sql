CREATE PROCEDURE `CheckPassword`(IN `UserIdIn` INT(11), 
													IN `UserPasswordIn` VARCHAR(45))
    COMMENT 'To check the password of a user'
BEGIN
	

    DECLARE CompletedOk int;

    
	DECLARE NewTransNo int;

    
	DECLARE TransResult int;

    
	DECLARE RecCount int;
    
    DECLARE UserPasswordToCheck VARCHAR(45);
    
	DECLARE MessageText CHAR;

	DECLARE ReturnedSqlState INT;

	DECLARE MySQLErrNo INT;
        
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN

		GET CURRENT DIAGNOSTICS CONDITION 1 MessageText = message_text, ReturnedSqlState = RETURNED_SQLSTATE, MySqlErrNo = MYSQL_ERRNO;
        
		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC CheckPassword(). Error occured()=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySqlErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),
								 TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;


main_proc:

BEGIN

	SET CompletedOk = 0;

	SET TransResult = 0;

	SET NewTransNo = GetTranNo("CheckPassword");

	INSERT INTO humans.testlog 
		SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, "null"), ", SPROC CheckPassword(). TransResult= ", IFNULL(TransResult, "null"), ". Start check password for user= ", IFNULL(UserIdIn, "null")),
			TestLogDateTime = NOW();
	
	SELECT Wachtwoord FROM humans.users WHERE UserId=UserIdIn INTO UserPasswordToCheck;

	IF fGenerateOrCheckIt(UserPasswordIn) = UserPasswordToCheck THEN
    	INSERT INTO humans.testlog 
		SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, "null"), ", SPROC CheckPassword(). TransResult= ", IFNULL(TransResult, "null"), ". Users password= OK"),
			TestLogDateTime = NOW();
		SELECT true as Result;
	ELSE
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, "null"), ", SPROC CheckPassword(). TransResult= ", IFNULL(TransResult, "null"), ". Users password= NOK"),
			TestLogDateTime = NOW();
		SELECT false as Result;
	END IF;

	SET TransResult = 1;

	SET RecCount = 0;

	INSERT INTO humans.testlog 
		SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, "null"), ", SPROC CheckPassword(). TransResult= ", IFNULL(TransResult, "null"), ". End check password."),
		TestLogDateTime = NOW();

	END;
END