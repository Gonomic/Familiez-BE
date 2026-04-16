CREATE PROCEDURE `deletePerson`(IN `PersonIdIn` INT, IN MotherIdIn INT, IN FatherIdIn INT, IN PartnerIdIn INT, IN TimestampInAsString CHAR(30))
    SQL SECURITY INVOKER
    COMMENT 'To delete a Person from the database, incl. links from Family to this Person.'
BEGIN

	-- CompletedOk defines the result of a database transaction, like this:

    -- 0 = Transaction finished without problems.

    -- 1 = Transaction aborted due to Person's details changed in the mean time

    -- 2 = Transaction aborted due to problems during update and rollback performed

    -- ...

	DECLARE TimestampIn timestamp;

    DECLARE CompletedOk int;
    
    DECLARE Result CHAR(40);
    
    DECLARE RelationIdOfMother int;
    
    DECLARE RelationIdOfFather int;
    
    DECLARE RelationIdOfPartner int;

    -- NewTransNo is autonumber counter fetched from a seperate table and used for logging in a seperate log table
	DECLARE NewTransNo int;

    -- TransResult is used to count the number of seperate database operations and rissen with each step
	DECLARE TransResult int;

    -- RecCount is used to count the number of related records in depended tables.
	DECLARE RecCount int;

	DECLARE MessageText TEXT;

	DECLARE ReturnedSqlState VARCHAR(10);

	DECLARE MySQLErrNo INT;
        
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
 	BEGIN

		GET CURRENT DIAGNOSTICS CONDITION 1 MessageText = MESSAGE_TEXT, ReturnedSqlState = RETURNED_SQLSTATE, MySQLErrNo = MYSQL_ERRNO;
        
		ROLLBACK;

		SET CompletedOk = 2;
        
        SET Result = "Error";

		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), " SPROC deletePerson(). Error occured()=", 
								 IFNULL(MessageText, "null"), "/State=", IFNULL(ReturnedSqlState, "null"), "/ErrNo=", IFNULL(MySQLErrNo, "null"), "). Rollback executed. CompletedOk= ", CompletedOk),
								 TestLogDateTime = NOW();

		SELECT CompletedOk, Result;

	END;
    
    SET TimestampIn = STR_TO_DATE(TimestampInAsString, "%Y-%m-%d %T");
    
    SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("deletePerson");

    -- Schrijf start van deze SQL transactie naar log
    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. Start SPROC: deletePerson() voor persoon met ID= ', PersonIdIn),
		TestLogDateTime = NOW();
  
	SET RelationIdOfMother = fGetRelationId("Moeder");
    
    SET RelationIdOfFather = fGetRelationId("Vader");
    
    SET RelationIdOfPartner = fGetRelationId("Partner");
  
  transactionBody:BEGIN

	START TRANSACTION;
    
    IF NOT fPersonExists(PersonIdIn) THEN
    
		SET CompletedOk = CompletedOk + 1;
        
        SET Result = "RecordDoesNotExistAnyMore";
        
	    INSERT INTO humans.testlog 
		    SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". TransResult= ", TransResult, ". Record does not exist anymore. Deletion aborted."),
			    TestLogDateTime = NOW();

	    LEAVE transactionBody;

    END IF;
    
    
    IF RecordHasBeenChangedBySomebodyElse(PersonIdIn, TimeStampIn) THEN

	    SET CompletedOk = 1;
        
        SET Result = "RecordHasBeenChangedBySomebodyElse";
        
	    INSERT INTO humans.testlog 
		    SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". TransResult= ", TransResult, ". Records has been changed in mean time by somebody else. Deletion aborted."),
			    TestLogDateTime = NOW();

	    LEAVE transactionBody;

    END IF;

    -- First delete ALL relations where this person appears (as parent, child, or partner)
    DELETE FROM humans.relations 
        WHERE RelationPerson = PersonIdIn 
           OR RelationWithPerson = PersonIdIn;
    
    SET TransResult = TransResult + 1;
    INSERT INTO humans.testlog
        SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ', TransResult= ', IFNULL(TransResult, 'null'), '. Alle relaties van persoon met ID= ', IFNULL(PersonIdIn, 'null'), ' zijn verwijderd uit de database.'),
            TestLogDateTime = NOW();
    
    -- Lastly delete Person itself 
    DELETE FROM persons
	WHERE PersonID = PersonIdIn AND Timestamp = TimestampIn;
    
    COMMIT;

    INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), ', TransResult= ', IFNULL(TransResult, 'null'), '. Persoon met ID= ', IFNULL(PersonIdIn, 'null'), ' is verwijderd uit de database.'),
	 	TestLogDateTime = NOW();

    SET Result = "DeletionWasSuccesful";
    
END ;

SELECT CompletedOk, Result;

INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', IFNULL(TransResult, 'null'), '. SPROC DeletePerson afgerond. CompletedOk= ', IFNULL(CompletedOk, 'null')),
	TestLogDateTime = NOW();

END