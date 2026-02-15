CREATE PROCEDURE `ChangeUser`(IN `UserIdIn` INT(11), 
												IN `UserNameIn` VARCHAR(45), 
                                                IN `UserGivvenNameIn` VARCHAR(45), 
                                                IN `UserFamilyNameIn` VARCHAR(45), 
                                                IN `UserEmailAdressIn` VARCHAR(45), 
                                                IN `UserPasswordIn` VARCHAR(45))
    COMMENT 'To edit the details of a specific user'
BEGIN
	



    DECLARE CompletedOk int;

    
	DECLARE NewTransNo int;

    
	DECLARE TransResult int;

    
	DECLARE RecCount int;
    
	DECLARE LastRecIdInserted INT(11);

	DECLARE MessageText CHAR;

	DECLARE ReturnedSqlState INT;

	DECLARE MySQLErrNo INT;
        
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN

		GET CURRENT DIAGNOSTICS CONDITION 1 MessageText = message_text, ReturnedSqlState = RETURNED_SQLSTATE, MySqlErrNo = MYSQL_ERRNO;
        
		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC ChangeUser(). Error occured()=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySqlErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),
								 TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;


main_proc:

BEGIN



SET CompletedOk = 0;

SET TransResult = 0;

SET NewTransNo = GetTranNo("ChangeUser");

INSERT INTO humans.testlog 
	SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, "null"), ", SPROC ChangeUser(). TransResult= ", IFNULL(TransResult, "null"), ". Start change record for user with username= ", IFNULL(UserNameIn, "null")),
		TestLogDateTime = NOW();
   
         
           
transactionBody:BEGIN
	START TRANSACTION;
		UPDATE humans.users
			SET
				UserName = UserNameIn,
                GivvenName = UserGivvenNameIn,
                FamilyName = UserFamilyNameIn,
                EmailAdress = UserEmailAdressIn,
                Wachtwoord = fGenerateOrCheckIt(UserPasswordIn),
                CreatedOrLastChanged = NOW()
                WHERE UserId = UserIdIn;
	COMMIT;
        
	SET TransResult = 1;

	SET RecCount = 0;
	
	INSERT INTO humans.testlog 
		SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, "null"), ", SPROC ChangeUser(). TransResult= ", IFNULL(TransResult, "null"), ". Gegevens van user met UserId= ", IFNULL(UserIdIn, "null"), " zijn bijgewerkt."),
		TestLogDateTime = NOW();

END transactionBody;
    
SELECT CompletedOk;

SELECT 	UserId, UserName, GivvenName, FamilyName, EmailAdress, CreatedOrLastChanged from humans.users WHERE UserId = UserIdIn;

END;

END