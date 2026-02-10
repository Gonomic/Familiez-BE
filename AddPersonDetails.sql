DELIMITER $$
CREATE PROCEDURE `AddPersonDetails`(IN `PersonGivvenNameIn` VARCHAR(25), IN `PersonFamilyNameIn` VARCHAR(50), IN `PersonDateOfBirthIn` DATETIME, IN `PersonPlaceOfBirthIn` VARCHAR(50), IN `PersonDateOfDeathIn` DATETIME, IN `PersonPlaceOfDeathIn` VARCHAR(50), IN `PersonIsMaleIn` TINYINT(1), IN `PersonPhotoIn` LONGBLOB, IN `TimestampIn` TIMESTAMP, IN `PersonPartnerIdIn` INT(11), IN `PersonPartnerIn` VARCHAR(50), IN `PersonFatherIdIn` INT(11), IN `PersonFatherIn` VARCHAR(50), IN `PersonMotherIdIn` INT(11), IN `PersonMotherIn` VARCHAR(50))
    SQL SECURITY INVOKER
    COMMENT 'To add a specific person'
BEGIN

	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = Transaction aborted due to intermediate changes (possibly from other users) in the mean time

    -- 2 = Transaction aborted due to problems during update and rollback performed

    DECLARE CompletedOk INT;



    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table

	DECLARE NewTransNo INT;



    -- TransResult is used to count the number of seperate database operations and rissen with each step

	DECLARE TransResult INT;



    -- RecCount is used to count the number of related records in depended tables.

	DECLARE RecCount int;



    -- LastRecInserted is the autonumber ID value for each addition

	DECLARE LastRecIdInserted INT(11);



	DECLARE FullNamePerson varchar(100);

-- 	DECLARE MessageText text;

-- 	DECLARE ReturnedSqlState int;

-- 	DECLARE MySqlErrNo int;

	

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN

		-- SET MessageText = MESSAGE_TEXT;

		-- SET ReturnedSqlState = RETURNED_SQLSTATE;

		-- SET MySQLErrNo = MYSQL_ERRNO;

		-- GET CURRENT DIAGNOSTICS CONDITION 1 MessageText : MESSAGE_TEXT, ReturnedSqlState : RETURNED_SQLSTATE, MySqlErrNo : MYSQL_ERRNO;

		ROLLBACK;

		SET CompletedOk = 2;

		INSERT INTO humans.testlog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured. Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN



START TRANSACTION;



SET CompletedOk = 0;



SET TransResult = 0;



SET NewTransNo = GetTranNo("NewPersonDetails");



INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start insert for person.'),
    TestLogDateTime = NOW();
        

/*
FDE03111963
Commented out because this SPO is copied and paste from the update sproc where you take into account other can have 
edited the record in the mean time. Which is not the case for completely new records
IF RecordHasBeenChangedBySomebodyElse(PersonIdIn, TimeStampIn) THEN

	SET CompletedOk = 1;

	INSERT INTO humans.testLog 

		SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Records has been changed in mean time. Update aborted."),

			TestLogDateTime = NOW();

	SELECT CompletedOk;

	CALL GetPersonDetails(PersonIdIn);

	LEAVE main_proc;

END IF;
*/


INSERT INTO humans.persons  (
    PersonGivvenName,
    PersonFamilyName,
    PersonDateOfBirth,
    PersonPlaceOfBirth,
    PersonDateOfDeath,
    PersonPlaceOfDeath,
    PersonIsMale)
VALUES
    (PersonGivvenNameIn,
     PersonFamilyNameIn,
     PersonDateOfBirthIn,
     PersonPlaceOfBirthIn,
     PersonDateOfDeathIn,
     PersonPlaceOfDeathIn,
     PersonIsMaleIn);
 
SET LastRecIdInserted = LAST_INSERT_ID();

COMMIT;

SET TransResult = 1;

INSERT INTO humans.testlog 
	SET TestLog = concat("TransAction-", IFNULL(NewTransNo, "null"), ". ",
		"Adding new person=> ", 
        "PersonIdIn= ", LastRecIdInserted, ", ",
		"PersonGivvenNameIn= ", IFNULL(PersonGivvenNameIn, "null"), ", ",
		"PersonFamilyNameIn= ", IFNULL(PersonFamilyNameIn, "null"), ", ",
		"PersonDateOfBirthIn= ", IFNULL(PersonDateOfBirthIn, "null"), ", ",
		"PersonPlaceOfBirthIn= ", IFNULL(PersonPlaceOfBirthIn, "null"), ", ",
		"PersonDateOfDeathIn= ", IFNULL(PersonDateOfDeathIn, "null"), ", ",
		"PersonPlaceOfDeathIn= ",  IFNULL(PersonPlaceOfDeathIn, "null"), ", ",
		"PersonIsMaleIn= ", IFNULL(PersonIsMaleIn, "null"), ", ",
		"PersonPhotoIn= ", IFNULL(PersonPhotoIn, "null"), ", ",
		"PersonPartnerIdIn= ", IFNULL(PersonPartnerIdIn, "null"), ", ",
		"PersonPartnerIn= ",  IFNULL(PersonPartnerIn, "null"), ", ",
		"PersonFatherIdIn= ",  IFNULL(PersonFatherIdIn, "null"), ", ",
		"PersonFatherIn= ",  IFNULL(PersonFatherIn, "null"), ", ",
		"PersonMotherIdIn= ",  IFNULL(PersonMotherIdIn, "null"), ", ",
		"PersonMotherIn= ", IFNULL(PersonMotherIn, "null"), "."),
		TestLogDateTime = NOW();


SET RecCount = 0;

INSERT INTO humans.testlog 

	SET TestLog = CONCAT("TransAction-", IFNULL(NewTransNo, 'null'), ". TransResult= ", TransResult, ". Gegevens zijn toegevoegd van Persoon ID= ", LastRecIdInserted),
		TestLogDateTime = NOW();

SELECT CompletedOk, LastRecIdInserted;

CALL GetPersonDetails(LastRecIdINserted);

END;

END$$
DELIMITER ;