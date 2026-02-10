CREATE PROCEDURE `AddUser`(IN `UserIdIn` INT(11), 
												IN `UserNameIn` VARCHAR(45), 
                                                IN `UserGivvenNameIn` VARCHAR(45), 
                                                IN `UserFamilyNameIn` VARCHAR(45), 
                                                IN `UserEmailAdressIn` VARCHAR(45), 
                                                IN `UserPasswordIn` VARCHAR(45))
    COMMENT 'To insert the details of a specific user'
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

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC AddUser(). Error occured()=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySqlErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),
								 TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;


main_proc:

BEGIN



SET CompletedOk = 0;

SET TransResult = 0;

SET NewTransNo = GetTranNo("AddUser");

INSERT INTO humans.testlog 
	SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, "null"), ", SPROC AddUser(). TransResult= ", IFNULL(TransResult, "null"), ". Start add record for user with username= ", IFNULL(UserNameIn, "null")),
		TestLogDateTime = NOW();
   
transactionBody:BEGIN
	START TRANSACTION;

		INSERT INTO humans.users
			(
				UserName,
                GivvenName,
                FamilyName,
                MayEdit,
                EmailAdress,
                Wachtwoord,
                CreatedOrLastChanged
			)
		VALUES
			(
				UserNameIn, 
                UserGivvenNameIn, 
                UserFamilyNameIn, 
                false,
                UserEmailAdressIn, 
                fGenerateOrCheckIt(UserPasswordIn),
                NOW()
			);
 				
		SET LastRecIdInserted = LAST_INSERT_ID();
        
		SET TransResult = 1;

		SET RecCount = 0;
        
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, "null"), ", SPROC AddUser(). TransResult= ", IFNULL(TransResult, "null"), ". Gegevens zijn toegevoegd, UserId= ", IFNULL(LastRecIdInserted, "null")),
		TestLogDateTime = NOW();

    COMMIT;
    
END transactionBody;
    
INSERT INTO humans.testlog 
	SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, "null"), ", SPROC AddUser(). TransResult= ", IFNULL(transResult, "null"), ". Transactie afgerond, alle wijzigingen zijn comitted. Sending back data that was inserted."),
		TestLogDateTime = NOW();

SELECT 	UserId, UserName, GivvenName, FamilyName, EmailAdress, CreatedOrLastChanged from humans.users WHERE UserId = LastRecIdInserted;

END;

END