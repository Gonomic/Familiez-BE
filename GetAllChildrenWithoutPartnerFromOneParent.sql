DELIMITER $$
CREATE PROCEDURE `GetAllChildrenWithoutPartnerFromOneParent`(IN `ParentIn` int(11))
    SQL SECURITY INVOKER
    COMMENT 'To get all children from a specific parent and without the partner'
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

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetAllChildrenWithoutPartnerFromOneParent(). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN

    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("GetAllChildrenWithoutPartnerFromOneParent");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: GetAllChildrenWithoutPartnerFromOneParent() voor persoon met ID= ', IFNULL(ParentIn, 'null')),

		TestLogDateTime = NOW();

IF ParentIn IS null THEN
	
    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Error SPROC: GetAllChildrenWithoutPartnerFromOneParent(), ParentIn should NOT be null but IS null.'),

		TestLogDateTime = NOW();

ELSE

	SELECT DISTINCT * FROM persons 
	WHERE PersonID IN 
	(SELECT RelationPerson FROM relations
		WHERE RelationWithPerson = ParentIn
        AND (RelationName = 1 OR RelationName = 2));

  SET TransResult = TransResult + 1;

  SET RecCount = FOUND_ROWS();

  INSERT INTO humans.testlog 

  SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC: GetAllChildrenWithoutPartnerFromOneParent() voor persoon met ID= ', ParentIn, '. CompletedOk= ', CompletedOk, '. Children found=', RecCount),

		TestLogDateTime = NOW();
        
END IF;

END;

END$$
DELIMITER ;
