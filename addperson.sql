CREATE PROCEDURE `AddPerson`(IN `PersonIdIn` INT(11), 
												IN `PersonGivvenNameIn` VARCHAR(50), 
                                                IN `PersonFamilyNameIn` VARCHAR(50), 
                                                IN `PersonDateOfBirthIn` DATE, 
                                                IN `PersonPlaceOfBirthIn` VARCHAR(50), 
                                                IN `PersonDateOfDeathIn` DATE, 
                                                IN `PersonPlaceOfDeathIn` VARCHAR(50), 
                                                IN `PersonIsMaleIn` TINYINT(1), 
                                                IN `PersonMotherIdIn` INT(11),
                                                IN `PersonFatherIdIn` INT(11),
                                                IN `PersonPartnerIdIn` INT(11),
                                                IN `PersonDateOfBirthStatusIn` INT(11),
                                                IN `PersonDateOfDeathStatusIn` INT(11))
    COMMENT 'To update the details of a specific person'
BEGIN
	

    DECLARE CompletedOk int;

    
	DECLARE NewTransNo int;

    
	DECLARE TransResult int;

    
	DECLARE RecCount int;
    
    
    DECLARE IdOfInsertedPerson INT;

    
	DECLARE LastRecIdInserted INT(11);

	DECLARE FullNamePerson varchar(100);

	DECLARE MessageText CHAR;

	DECLARE ReturnedSqlState INT;

	DECLARE MySQLErrNo INT;
        
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN

		GET CURRENT DIAGNOSTICS CONDITION 1 MessageText = message_text, ReturnedSqlState = RETURNED_SQLSTATE, MySqlErrNo = MYSQL_ERRNO;
        
		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC AddPerson(). Error occured()=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySqlErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),
								 TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;


main_proc:

BEGIN

SET CompletedOk = 0;

SET TransResult = 0;

SET NewTransNo = GetTranNo("AddPerson");

INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ", SPROC AddPerson(). TransResult= ", IFNULL(transResult, null), '. Start add record for person with name ', PersonGivvenNameIn, ' ', PersonFamilyNameIn),
		TestLogDateTime = NOW();
        
 INSERT INTO humans.testlog 
	SET TestLog = concat('TransAction-', IFNULL(NewTransNo, 'null'), ', SPROC AddPerson() ',
							  'Toevoegen nieuwe persoon=> ', 
                              'PersonIdIn= ', IFNULL(PersonIdIn, 'null'), ', ',
							  'PersonGivvenNameIn= ', IFNULL(PersonGivvenNameIn, 'null'), ', ',
							  'PersonFamilyNameIn= ', IFNULL(PersonFamilyNameIn, 'null'), ', ',
							  'PersonDateOfBirthIn= ', IFNULL(PersonDateOfBirthIn, 'null'), ', ',
							  'PersonPlaceOfBirthIn= ', IFNULL(PersonPlaceOfBirthIn, 'null'), ', ',
							  'PersonDateOfDeathIn= ', IFNULL(PersonDateOfDeathIn, 'null'), ', ',
							  'PersonPlaceOfDeathIn= ',  IFNULL(PersonPlaceOfDeathIn, 'null'), ', ',
							  'PersonIsMaleIn= ', IFNULL(PersonIsMaleIn, 'null'), ', ',
							  'PersonPartnerIdIn= ', IFNULL(PersonPartnerIdIn, 'null'), ', ',
							  'PersonFatherIdIn= ',  IFNULL(PersonFatherIdIn, 'null'), ', ',
							  'PersonMotherIdIn= ',  IFNULL(PersonMotherIdIn, 'null'), '. '),
	TestLogDateTime = NOW();

transactionBody:BEGIN
	START TRANSACTION;

		INSERT INTO humans.persons

					(PersonGivvenName, 

					PersonFamilyName, 

					PersonDateOfBirth, 

					PersonPlaceOfBirth, 

					PersonDateOfDeath, 

					PersonPlaceOfDeath, 

					PersonIsMale,
                    
                    PersonDateOfBirthStatus,
                    
                    PersonDateOfDeathStatus,
                    
                    Timestamp)

				VALUES
				
					(PersonGivvenNameIn,

					PersonFamilyNameIn,

					PersonDateOfBirthIn,

					PersonPlaceOfBirthIn,

					PersonDateOfDeathIn,

					PersonPlaceOfDeathIn,

					PersonIsMaleIn,
                    
                    PersonDateOfBirthStatusIn,
                    
                    PersonDateOfDeathStatusIn,
                    
                    NOW());
				
		SET IdOfInsertedPerson = LAST_INSERT_ID();

		SET TransResult = 1;

		SET RecCount = 0;

		INSERT INTO humans.testlog 
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Gegevens zijn toegevoegd van Persoon met naam= ', PersonGivvenNameIn, ' ', PersonFamilyNameIn, '. Assigned autoincrement id= ', IFNULL(IdOfInsertedPerson, null)),
				TestLogDateTime = NOW();

		IF PersonMotherIdIn <=> '' OR PersonMotherIdIn <=> null THEN
			INSERT INTO humans.testlog
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Moeder NIET in transactie aanwezig, moeder wordt niet toegevoegd'),
				TestLogDateTime = NOW();
        
        ELSE
			INSERT INTO humans.testlog
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Moeder in transactie aanwezig, moeder wordt toegevoegd. Moeder ID= ', IFNULL(PersonMotherIdIn, 'null')),
				TestLogDateTime = NOW();

			SET @RelNameID = fGetRelationId("Moeder");
            
			INSERT INTO humans.relations

				(RelationName, 

				RelationPerson,

				RelationWithPerson)
			
            VALUES
				
                (@RelNameID,

				IdOfInsertedPerson,
                
                PersonMotherIdIn);

			SET TransResult = TransResult + 1;

			INSERT INTO humans.testlog
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Toegevoegd in database moeder met ID= ', IFNULL(PersonMotherIdIn, 'null'), ' voor persoon: ', IFNULL(PersonGivvenNameIn, null), ' ', IFNULL(PersonFamilyNameIn, null) ),
				TestLogDateTime = NOW();

		END IF;

		IF PersonFatherIdIn <=> '' OR PersonFatherIdIn <=> null THEN
			INSERT INTO humans.testlog
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Vader NIET in transactie aanwezig, vader wordt niet toegevoegd'),
				TestLogDateTime = NOW();
        
        ELSE
			INSERT INTO humans.testlog
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Vader in transactie aanwezig, vader wordt toegevoegd. Vader ID= ', IFNULL(PersonFatherIdIn, 'null')),
				TestLogDateTime = NOW();

			SET @RelNameID = fGetRelationId("Vader");
            
			INSERT INTO humans.relations

				(RelationName, 

				RelationPerson,

				RelationWithPerson)
			
            VALUES
				
                (@RelNameID,

				IdOfInsertedPerson,
                
                PersonFatherIdIn);

			SET TransResult = TransResult + 1;

			INSERT INTO humans.testlog
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Toegevoegd in database vader met ID= ', IFNULL(PersonFatherIdIn, 'null'), ' voor persoon: ', IFNULL(PersonGivvenNameIn, null), ' ', IFNULL(PersonFamilyNameIn, null) ),
				TestLogDateTime = NOW();

		END IF;

		IF PersonPartnerIdIn <=> '' OR PersonPartnerIdIn <=> null THEN
			INSERT INTO humans.testlog
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partner NIET in transactie aanwezig, er wordt geen partner toegevoegd'),
				TestLogDateTime = NOW();
        
        ELSE
			INSERT INTO humans.testlog
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partner in transactie aanwezig, partner wordt toegevoegd. Partner ID= ', IFNULL(PersonPartnerIdIn, 'null')),
				TestLogDateTime = NOW();

			SET @RelNameID = fGetRelationId("Partner");
            
            IF fCheckPersonAlreadyExistsAsPartner(PersonPartnerIdIn) THEN
				INSERT INTO humans.testlog
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Dubbele registratie! Opgegeven partner was al als partner geregistreerd en wordt NIET opnieuw geregistreerd als partner. Partner ID= ', IFNULL(PersonPartnerIdIn, 'null')),
					TestLogDateTime = NOW();

            ELSE
            
				INSERT INTO humans.relations

					(RelationName, 

					RelationPerson,

					RelationWithPerson)
				
				VALUES
					
					(@RelNameID,

					IdOfInsertedPerson,
					
					PersonPartnerIdIn);

				SET TransResult = TransResult + 1;

				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Toegevoegd in database partner met ID= ', IFNULL(PersonPartnerIdIn, 'null'), ' voor persoon: ', IFNULL(PersonGivvenNameIn, null), ' ', IFNULL(PersonFamilyNameIn, null) ),
					TestLogDateTime = NOW();

				INSERT INTO humans.relations

					(RelationName, 

					RelationPerson,

					RelationWithPerson)
				
				VALUES
					
					(@RelNameID,
                    
					PersonPartnerIdIn,
                    
					IdOfInsertedPerson
					
					);

				SET TransResult = TransResult + 1;

				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Toegevoegd in database partner ', IFNULL(PersonGivvenNameIn, null), ' ', IFNULL(PersonFamilyNameIn, null), ' voor persoon met ID= ', IFNULL(PersonPartnerIdIn, 'null'), '.'),
					TestLogDateTime = NOW();
			END IF;
            
		END IF;
	
    COMMIT;
    
END transactionBody;
    

INSERT INTO humans.testlog

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Transactie afgerond, alle wijzigingen zijn comitted. Calling GetPersonDetails.'),
		TestLogDateTime = NOW();

CALL GetPersonDetails(IdOfInsertedPerson);

END;

END