DELIMITER $$
CREATE PROCEDURE `InsertPersonDetails`(IN `PersonGivvenNameIn` VARCHAR(25), IN `PersonFamilyNameIn` VARCHAR(50), IN `PersonDateOfBirthIn` DATETIME, IN `PersonPlaceOfBirthIn` VARCHAR(50), IN `PersonDateOfDeathIn` DATETIME, IN `PersonPlaceOfDeathIn` VARCHAR(50), IN `PersonIsMaleIn` TINYINT(1), IN `PersonPhotoIn` LONGBLOB, IN `PersonPartnerIdIn` INT(11), IN `PersonPartnerIn` VARCHAR(50), IN `PersonFatherIdIn` INT(11), IN `PersonFatherIn` VARCHAR(50), IN `PersonMotherIdIn` INT(11), IN `PersonMotherIn` VARCHAR(50))
    SQL SECURITY INVOKER
    COMMENT 'To update the details of a specific person'
BEGIN

		DECLARE CompletedOk INT;

		DECLARE NewTransNo INT;

		DECLARE TransResult INT;

		DECLARE RecCount INT;

		DECLARE RelationName INT;

		DECLARE RelNameId INT;

		DECLARE FullNamePerson VarChar(100);

		

		DECLARE EXIT HANDLER FOR SQLEXCEPTION

		BEGIN

		-- SET MessageText = MESSAGE_TEXT;

		-- SET ReturnedSqlState = RETURNED_SQLSTATE;

		-- SET MySQLErrNo = MYSQL_ERRNO;

		-- GET CURRENT DIAGNOSTICS CONDITION 1 MessageText : MESSAGE_TEXT, ReturnedSqlState : RETURNED_SQLSTATE, MySqlErrNo : MYSQL_ERRNO;

			ROLLBACK;

			SET CompletedOk = 2;

		-- INSERT INTO TestLog SELECT concat('SQLException occurred. Rollback performed. Errorinfo: Message= ', MessageText, '. State= ', ReturnedSqlState, '. ErrNo= ', MySqlErrNo);

			INSERT INTO humans.testlog 

			SET TestLog = CONCAT('Transaction-', IFNULL(NewTransNo, 'null'), ". Error occured. Rollback executed."),

				 TestLogDateTime = NOW();

			SELECT CompletedOk, FullNamePerson;	 

		END;

		

		START TRANSACTION;

		

			 SET CompletedOk = 0;

		

			 SET NewTransNo = GetTranNo("InsertPersonDetails");

			 

 			 INSERT INTO humans.testlog 

 			 SET TestLog = concat('TransAction-', IFNULL(NewTransNo, 'null'), '. ',

			  							  'Nieuwe persoon wordt toegevoegd=> ', 

			  							  'PersonGivvenNameIn= ', IFNULL(PersonGivvenNameIn, 'null'), ', ',

 										  'PersonFamilyNameIn= ', IFNULL(PersonFamilyNameIn, 'null'), ', ',

 										  'PersonDateOfBirthIn= ', IFNULL(PersonDateOfBirthIn, 'null'), ', ',

 										  'PersonPlaceOfBirthIn= ', IFNULL(PersonPlaceOfBirthIn, 'null'), ', ',

 										  'PersonDateOfDeathIn= ', IFNULL(PersonDateOfDeathIn, 'null'), ', ',

 										  'PersonPlaceOfDeathIn= ',  IFNULL(PersonPlaceOfDeathIn, 'null'), ', ',

 										  'PersonIsMaleIn= ', IFNULL(PersonIsMaleIn, 'null'), ', ',

 										  'PersonPhotoIn= ', IFNULL(PersonPhotoIn, 'null'), ', ',

 										  'PersonPartnerIdIn= ', IFNULL(PersonPartnerIdIn, 'null'), ', ',

 										  'PersonPartnerIn= ',  IFNULL(PersonPartnerIn, 'null'), ', ',

 										  'PersonFatherIdIn= ',  IFNULL(PersonFatherIdIn, 'null'), ', ',

 										  'PersonFatherIn= ',  IFNULL(PersonFatherIn, 'null'), ', ',

 										  'PersonMotherIdIn= ',  IFNULL(PersonMotherIdIn, 'null'), ', ',

 										  'PersonMotherIn= ', IFNULL(PersonMotherIn, 'null'), '.'),

 					 TestLogDateTime = NOW();

			

			INSERT INTO humans.persons

			SET PersonGivvenName=PersonGivvenNameIn,

				PersonFamilyName=PersonFamilyNameIn,

				PersonDateOfBirth=PersonDateOfBirthIn,

				PersonPlaceOfBirth=PersonPlaceOfBirthIn,

				PersonDateOfDeath=PersonDateOfDeathIn,

				PersonPlaceOfDeath=PersonPlaceOfDeathIn,

				PersonIsMale=PersonIsMaleIn,

				PersonPhoto = null;

			SET RelNameID = LAST_INSERT_ID();

			SET FullNamePerson = CONCAT(PersonGivvenNameIn, " ", PersonFamilyNameIn);	

	  

			SET TransResult = 1;

			SET RecCount = 0;

	      

	

			INSERT INTO humans.testlog 

			SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Persoon is toegevoegd, ID= ', RelNameID),

				 TestLogDateTime = NOW();

			

			-- Based on if Mother params are filled do either nothing or insert Mother

			-- -------------------------------------------------

			-- If Mother params are filled

			-- INSERT Mother 

			IF PersonMotherIn <> '' OR PersonMotherIn <> null THEN

				-- First search for RelationName (= content of field RelationnameID in table RELATIONNAMES where RelationnaneName = "Moeder")

				SELECT RelationnameID INTO RelationName FROM humans.relationnames WHERE RelationnameName = "Moeder";

				INSERT INTO relations

				SET RelationName = RelationName,

					RelationPerson = RelNameID,

					RelationWithPerson = PersonMotherIdIn;

				SET TransResult = TransResult + 1;	

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, ', Moeder met ID= ', PersonMotherIdIn, ' is toegevoegd aan Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();

			ELSE

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Geen ingave voor Moeder dus geen Moeder toegevoegd voor Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();		 

			END IF;

			

			

			-- Based on if Father params are filled do either nothing or insert Father

			-- --------------------------------------------------

			-- If Father param is filled

			-- INSERT Father 

			IF PersonFatherIn <> '' OR PersonFatherIn <> null THEN

				-- First search for RelationName (= content of field RelationnameID in table RELATIONNAMES where RelationnaneName = "Vader")

				SELECT RelationnameID INTO RelationName FROM humans.relationnames WHERE RelationnameName = "Vader";

				INSERT INTO relations

				SET RelationName = RelationName,

					RelationPerson = RelNameID,

					RelationWithPerson = PersonFatherIdIn;

				SET TransResult = TransResult + 1;	

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, ', Vader met ID= ', PersonFatherIdIn, ' is toegevoegd aan Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();

			ELSE

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Geen ingave voor Vader dus geen Vader toegevoegd voor Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();		 

			END IF;

			

			

			-- Based on if Partner params are filled do either nothing or insert Partner

			-- ----------------------------------------------------

			-- If Partner param is filled

			-- INSERT Partner, if Person does not yet have Partner

			IF PersonPartnerIn <> '' OR PersonPartnerIn <> null THEN

			-- First search for RelationName (= content of field RelationnameID in table RELATIONNAMES where RelationnaneName = "Partner")

				SELECT RelationnameID INTO RelationName FROM humans.relationnames WHERE RelationnameName = "Partner";

				INSERT INTO relations

				SET RelationName = Relationname,

					RelationPerson = RelNameID,

					RelationWithPerson = PersonPartnerIdIn;

				SET TransResult = TransResult + 1;

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, ', Partner met ID= ', PersonPartnerIdIn, ' is toegevoegd aan Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();

				-- -> Insert as well Partner field for the other Person (the partner) but now for this Person as partner

				INSERT INTO relations

				SET RelationName = Relationname,

					RelationPerson = PersonPartnerIdIn,

					RelationWithPerson = RelNameID;

				SET TransResult = TransResult + 1;

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, ', Persoon met ID= ', RelNameID, ' is ook als Partner toegevoegd aan ID: ', PersonPartnerIdIn),

					 TestLogDateTime = NOW();

			ELSE

				INSERT INTO humans.testlog 

				SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. Geen ingave voor Partner dus geen Partner toegevoegd voor Persoon met ID= ', RelNameID),

					 TestLogDateTime = NOW();		 

			END IF;

		

		COMMIT;

		SET CompletedOk = 1;

		

		

	    INSERT INTO humans.testlog

		 SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. SPROC insertPersonDetails succesvol afgesloten. CompletedOk= ', CompletedOk),

				 TestLogDateTime = NOW();

	

		 SELECT CompletedOk, FullNamePerson, RelNameID as PersonID; 

 END$$
DELIMITER ;
