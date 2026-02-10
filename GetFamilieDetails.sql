DELIMITER $$
CREATE PROCEDURE `GetFamilieDetails`(IN `PersonIdIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'To get the family details (Father, Mother, Partner & Children) of a person based on the person''s PersonID.'
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

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetFamilyDetails(). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN

    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("GetFamilyDetails");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: GetFamilyDetails() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    CALL GetFather(PersonIdIn);

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. SPROC: GetFamilyDetails(), Vader opgehaald via GetFather() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();

    

    CALL GetMother(PersonIdIn);

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. SPROC: GetFamilyDetails(), Moeder opgehaald via GetMother() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    CALL GetPartner(PersonIdIn);

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. SPROC: GetFamilyDetails(), Partner opgehaald via GetPartner() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    CALL GetAllChildrenWithoutPartnerFromOneParent(PersonIdIn);

    SET TransResult = TransResult + 1;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. SPROC: GetFamilyDetails(), Kinderen opgehaald via GettAllChildrenWithoutPartnerFromOneParent() voor persoon met ID= ', PersonIdIn),

		TestLogDateTime = NOW();



    SELECT CompletedOk;

END ;

END$$
DELIMITER ;
