DELIMITER $$
CREATE PROCEDURE `GetMother`(IN `PersonIdIn` INT)
    SQL SECURITY INVOKER
    COMMENT 'To get the mother of a person based on the persons ID'
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

		INSERT INTO humans.testLog 

			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: GetMother(). Rollback executed. CompletedOk= ", CompletedOk),

				TestLogDateTime = NOW();

		SELECT CompletedOk;

	END;



main_proc:

BEGIN

    SET CompletedOk = 0;



    SET TransResult = 0;



    SET NewTransNo = GetTranNo("GetMother");



    -- Schrijf start van deze SQL transactie naar log

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Start SPROC: GetMother() voor persoon met ID= ', IFNULL(PersonIdIn, 'null')),

		TestLogDateTime = NOW();


IF PersonIdIn IS null THEN

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Error end SPROC GetMother(), PersonIdIn should NOT be null but IS null.'),

		TestLogDateTime = NOW();

ELSE
	SELECT DISTINCT

    P.PersonID as MotherId, 

    concat(P.PersonGivvenName, ' ', P.PersonFamilyName) as Mother
    
    FROM persons P 

    WHERE P.PersonID = 

		(SELECT DISTINCT 

         RelationWithPerson

		 FROM relations R

		 JOIN (relationnames RN, persons P)

		 ON (R.RelationName = RN.RelationnameID AND 

			 P.PersonID = R.RelationPerson AND 

			 RN.RelationnameName = "Moeder")

		 WHERE P.PersonID = PersonIdIn);

    SET TransResult = TransResult + 1 ;

    SET RecCount = FOUND_ROWS();

# 	Commented out on 24-11-2019 in order to only return result set (empty or not) and no accompanying seperate metadata anymore
#   This in order to simplify handlig of the result in API middlware and/or end user apps (as far as the later consumes the result directly
#    SELECT CompletedOk, RecCount as MoederGevonden;

    INSERT INTO humans.testlog 

	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC: GetMother() voor persoon met ID= ', PersonIdIn, '. CompletedOk= ', CompletedOk, '. Moeder gevonden=', RecCount),

		TestLogDateTime = NOW();
END IF;

 END;

END$$
DELIMITER ;
