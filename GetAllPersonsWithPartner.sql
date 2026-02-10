DELIMITER $$
CREATE PROCEDURE `GetAllPersonsWithPartner`(IN `YearFrom` INT(4), IN `FamilyName` VARCHAR(50))
    SQL SECURITY INVOKER
    COMMENT 'To get all persons with a specific familyname and their partner'
BEGIN

-- CompletedOk defines the result of a database transaction, like this:
    -- 0 = Transaction finished without problems.
    -- 1 = 
    -- 2 = Transaction aborted due to problems during update and rollback performed
    -- ...
    DECLARE CompletedOk int;

    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table
	DECLARE NewTransNo int;

    -- TransResult is used to count the number of seperate database operations and rissen with each step
	DECLARE TransResult int;

    -- RecCount is used to count the number of related records in depended tables.
	DECLARE RecCount int;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET CompletedOk = 2;
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetAllPersonsWithPartner(). Rollback executed. CompletedOk= ", CompletedOk),
				TestLogDateTime = NOW();
		SELECT CompletedOk;
	END;

main_proc:
	BEGIN
		SET CompletedOk = 0;

		SET TransResult = 0;

		SET NewTransNo = GetTranNo("GetAllPersonsWithPartner");

		-- Schrijf start van deze SQL transactie naar log
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: GetAllPersonsWithPartner() voor personen geboren ná: ', YearFrom, ' en met familienaam: ', IFNULL(FamilyName, 'alle')),
			TestLogDateTime = NOW();

		
        SELECT DISTINCT

		CONCAT(P.PersonGivvenName, ' ', P.PersonFamilyName) AS 'Person', 

		P.PersonID as 'PersonID',

		T.Partner as 'Partner',

		T.PartnerID as 'PartnerID'

		

		FROM persons P

		LEFT JOIN (

			SELECT 

				CONCAT(PA.PersonGivvenName, " ", PA.PersonFamilyName) as Partner, 

						PA.PersonID as PartnerID,

						R.RelationPerson, 

						RN.RelationnameName from relations R

						JOIN relationnames RN ON R.RelationName = RN.RelationnameID

						JOIN persons PA on R.RelationWithPerson = PA.PersonID

						WHERE RN.RelationnameName = "Partner") AS T on P.PersonID = T.RelationPerson

				WHERE P.PersonFamilyName LIKE CONCAT(FamilyName, '%')

				AND YEAR(P.PersonDateOfBirth) >= YearFrom

				ORDER BY P.PersonFamilyName, P.PersonDateOfBirth;
         
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC: GetAllPersonsWithPartner()'),
			TestLogDateTime = NOW();       
                

		END;
    END$$
DELIMITER ;
