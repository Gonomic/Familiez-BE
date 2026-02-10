DELIMITER $$
CREATE PROCEDURE `AddPerson`(IN `PersonIdIn` INT(11), 
												IN `PersonGivvenNameIn` VARCHAR(25), 
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

END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `ChangePerson`(IN `PersonIdIn` INT(11), 
												IN `PersonGivvenNameIn` VARCHAR(25), 
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
    SQL SECURITY INVOKER
    COMMENT 'To update the details of a specific person'
BEGIN
	

    DECLARE CompletedOk int;

    
	DECLARE NewTransNo int;

    
	DECLARE TransResult int;

    
	DECLARE RecCount int;

    
	DECLARE LastRecIdInserted INT(11);
    
     DECLARE RelationIdOfMother int;
    
    DECLARE RelationIdOfFather int;
    
    DECLARE RelationIdOfPartner int;

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
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC ChangePerson(). Error occured()=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySqlErrNo, "null"), "). Rollback executed. CompletedOk= ", IFNULL(CompletedOk, 'null')),
								 TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;


main_proc:

BEGIN

SET CompletedOk = 0;

SET TransResult = 0;

SET NewTransNo = GetTranNo("ChangePerson");

INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ", SPROC ChangePerson(). TransResult= ", IFNULL(transResult, null), '. Start change record for person with name ', IFNULL(PersonGivvenNameIn, 'null'), ' ', IFNULL(PersonFamilyNameIn, 'null')),
		TestLogDateTime = NOW();
        
 INSERT INTO humans.testlog 
	SET TestLog = concat('TransAction-', IFNULL(NewTransNo, 'null'), ', SPROC ChangePerson() ',
							  'Wijzigen bestaande persoon=> ', 
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

	SET RelationIdOfMother = fGetRelationId("Moeder");
    
    SET RelationIdOfFather = fGetRelationId("Vader");
    
    SET RelationIdOfPartner = fGetRelationId("Partner");

transactionBody:BEGIN
	START TRANSACTION;
		UPDATE humans.persons
			SET
				PersonGivvenName = PersonGivvenNameIn, 

				PersonFamilyName = PersonFamilyNameIn, 

				PersonFamilyName = PersonFamilyNameIn, 

				PersonPlaceOfBirth = PersonPlaceOfBirthIn, 

				PersonDateOfDeath = PersonDateOfDeathIn, 

				PersonPlaceOfDeath = PersonPlaceOfDeathIn, 

				PersonIsMale = PersonIsMaleIn,
                
                PersonDateOfBirthStatus = PersonDateOfBirthStatusIn,
                
                PersonDateOfDeathStatus = PersonDateOfDeathStatusIn,
                    
                Timestamp = NOW()
                
			WHERE
            
				PersonID = PersonIdIn;

		SET TransResult = 1;

		SET RecCount = 0;

		IF PersonMotherIdIn = '' OR PersonMotherIdIn IS null THEN
			INSERT INTO humans.testlog
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Moeder NIET in transactie aanwezig, als moeder in de database aanwezig is wordt ze verwijderd als moeder'),
				TestLogDateTime = NOW();
                IF fGetMother(PersonIdIn) IS NOT null THEN
					DELETE FROM humans.relations WHERE RelationPerson = PersonIdIn AND RelationName = RelationIdOfMother;
                    INSERT INTO humans.testlog
                    SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Moeder was in de database aanwezig  en is verwijderd als moeder uit de database.'),
						TestLogDateTime = NOW();
                END IF;
        ELSE
			IF fGetMother(PersonIdIn) IS null THEN
                INSERT INTO humans.relations
					(RelationName, 
					RelationPerson,
					RelationWithPerson)
			    VALUES
			        (RelationIdOfMother,
					PersonIdIn,
					PersonMotherIdIn);
				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Moeder in transactie aanwezig maar niet in de database, moeder wordt in de database toegevoegd. Moeder ID wordt: ', IFNULL(PersonMotherIdIn, 'null')),
						TestLogDateTime = NOW();
				SET TransResult = TransResult + 1;
			ELSE
				UPDATE humans.relations 
					SET RelationWithPerson = PersonMotherIdIn
					WHERE RelationPerson = PersonIdIn
					AND RelationName = RelationIdOfMother;
				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Moeder in transactie en in de database aanwezig, moeder wordt gewijzigd. Moeder ID wordt: ', IFNULL(PersonMotherIdIn, 'null')),
						TestLogDateTime = NOW();
				SET TransResult = TransResult + 1;  
			END IF;
		END IF;

		IF PersonFatherIdIn = '' OR PersonFatherIdIn IS null THEN
			INSERT INTO humans.testlog
			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Vader NIET in transactie aanwezig, als vader in de database aanwezig is wordt hij verwijderd als vader'),
				TestLogDateTime = NOW();
			IF fGetFather(PersonIdIn) IS NOT null THEN
				DELETE FROM humans.relations WHERE RelationPerson = PersonIdIn AND RelationName = RelationIdOfFather;
                INSERT INTO humans.testlog
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Vader was in de database aanwezig  en is verwijderd als vader uit de database.'),
					TestLogDateTime = NOW();
			END IF;
        ELSE
			IF fGetFather(PersonIdIn) IS null THEN
                INSERT INTO humans.relations
					(RelationName, 
					RelationPerson,
					RelationWithPerson)
			    VALUES
			        (RelationIdOfFather,
					PersonIdIn,
					PersonFatherIdIn);
				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Vader in transactie aanwezig maar niet in de database, vader wordt in de database toegevoegd. Vader ID wordt: ', IFNULL(PersonMotherIdIn, 'null')),
						TestLogDateTime = NOW();
				SET TransResult = TransResult + 1;
			ELSE
				UPDATE humans.relations 
					SET RelationWithPerson = PersonFatherIdIn
					WHERE RelationPerson = PersonIdIn
					AND RelationName = RelationIdOfFather;
				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Vader in transactie en in de database aanwezig, vader wordt gewijzigd. Vader ID wordt: ', IFNULL(PersonFatherIdIn, 'null')),
						TestLogDateTime = NOW();
			END IF;
		END IF;
        
		IF PersonPartnerIdIn = '' OR PersonPartnerIdIn IS null THEN
			INSERT INTO humans.testlog
				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partner NIET in transactie aanwezig, als partner in de database aanwezig is wordt deze verwijderd uit de database.'),
					TestLogDateTime = NOW();
			IF fGetPartner(PersonIdIn) IS NOT null THEN
				DELETE FROM humans.relations
					WHERE RelationPerson = PersonIdIn AND RelationName = RelationIdOfPartner;
                DELETE FROM humans.relations 
					WHERE RelationWithPerson = PersonIdIn AND RelationName = RelationIdOfPartner;
				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partners in de database aanwezig en verwijderd als partners uit de database.'),
						TestLogDateTime = NOW();
			ELSE 
				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partners was al niet in de database aanwezig, geen verdere actie.'),
						TestLogDateTime = NOW();            
			END IF;
		ELSE
			IF fGetPartner(PersonIdIn) IS null THEN
				INSERT INTO humans.relations
						(RelationName, 
						RelationPerson,
						RelationWithPerson)
					VALUES
						(RelationIdOfPartner,
						PersonIdIn,
						PersonPartnerIdIn);
					INSERT INTO humans.testlog
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partner in transactie aanwezig maar niet in de database, partner wordt in de database toegevoegd. Partner ID wordt: ', IFNULL(PersonMotherIdIn, 'null')),
							TestLogDateTime = NOW();
					SET TransResult = TransResult + 1;
				INSERT INTO humans.relations
						(RelationName, 
						RelationPerson,
						RelationWithPerson)
					VALUES
						(RelationIdOfPartner,
                        PersonPartnerIdIn,
						PersonIdIn);
					INSERT INTO humans.testlog
						SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. (Omgegekeerde toevoeging:) Partner in transactie aanwezig maar niet in de database, partner wordt in de database toegevoegd. Partner ID wordt: ', IFNULL(PersonMotherIdIn, 'null')),
							TestLogDateTime = NOW();
					SET TransResult = TransResult + 1;
			ELSE 
				UPDATE humans.relations 
					SET RelationWithPerson = PersonPartnerIdIn
						WHERE RelationPerson = PersonIdIn
						AND RelationName = RelationIdOfPartner;
				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partner in transactie en in database aanwezig. Partner in database gewijzigd. Persoon= ', IFNULL(PersonIdIn, 'null'), ' en Partner ID= ', IFNULL(PersonPartnerIdIn, 'null')),
						TestLogDateTime = NOW();              
                
				UPDATE humans.relations 
					SET RelationWithPerson = PersonIdIn 
						WHERE RelationPerson = PersonPartnerIdIn
						AND RelationName = RelationIdOfPartner;                
				INSERT INTO humans.testlog
					SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Partner in transactie en in de database aanwezig. Partner in database gewijzigd. Partner ID= ', IFNULL(PersonPartnerIdIn, 'null'), ' en Persoon= ', IFNULL(PersonIdIn, 'null')),
						TestLogDateTime = NOW();
			END IF;
		END IF;
	
    COMMIT;
	END transactionBody;
		
	INSERT INTO humans.testlog
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Transactie afgerond, alle wijzigingen zijn comitted. Calling GetPersonDetails.'),
			TestLogDateTime = NOW();

	CALL GetPersonDetails(PersonIdIn);

	END;

END$$
DELIMITER ;
