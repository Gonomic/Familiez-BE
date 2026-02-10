DELIMITER $$
CREATE PROCEDURE `AbstractDBtoAPInfo`()
    DETERMINISTIC
    SQL SECURITY INVOKER
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
    
    -- Number of records in the result set
    DECLARE n INT;
    
    -- Counter to go from first record to last record
    DECLARE i INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET CompletedOk = 2;
		INSERT INTO humans.testlog 
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: AbstractDBtoAPInfo(). Rollback executed. CompletedOk= ", CompletedOk),
				TestLogDateTime = NOW();
		SELECT CompletedOk;
	END;

main_proc:
BEGIN
    SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("AbstractDBtoAPInfo");
    
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). TransResult= ', TransResult, '. Start SPROC: AbstractDBtoAPInfo().'),
		TestLogDateTime = NOW();

	select count(*) from mysql.proc where Db="humans" and type="PROCEDURE" into n;
    
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Opslaan aantal sprocs in n, n= ', n),
		TestLogDateTime = NOW();

    set i=0;
    
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Startwaarde van teller i= ', i),
		TestLogDateTime = NOW();


    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Start deletion of all records in the APItoDB table.'),
		TestLogDateTime = NOW();
        
	truncate table humans.APItoDB;
    
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Start get names of all SPROCs in the humans DB.'),
		TestLogDateTime = NOW();
    
    insert into humans.APItoDB (APItoDBRoute) select name as APItoDBRoute from mysql.proc where Db="humans" and type="PROCEDURE";
    
    WHILE i<n do
    
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). Looping, i= ', i, ', n= ', n),
			TestLogDateTime = NOW();
		 
		select APItoDBRoute, APItoDB_id into @NameOfRecordToUpdate, @IDofRecordToUpdate  from humans.APItoDB limit i,1; 
		 
		INSERT INTO humans.testlog 
		SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. In AbstractDBtoAPinfo(). In loop. Name of record to update= ', @NameOfRecordToUpdate, ', IDofRecordToUpdate= ', @IDofRecordToUpdate),
			TestLogDateTime = NOW();
            
            update humans.APItoDB set SpoFieldNamesAndTypes = GetParmNamesandTypes(@NameOfRecordToUpdate, NewTransNo) where humans.APItoDB.APItoDB_id = @IDofRecordToUpdate;

			set i=i+1;
    end while;
    
    
    
  SET TransResult = TransResult + 1;
    
  SET RecCount = n;

  SELECT CompletedOk, RecCount AS APItoDBRecsGevonden;

  INSERT INTO humans.testlog 
  SET TestLog = CONCAT('TransAction-', IFNULL(NewTransNo, 'null'), '. TransResult= ', TransResult, '. Einde SPROC: AbstractDBtoAPInfo(). CompletedOk= ', CompletedOk, '. APItoDB records aangemaakt=', RecCount),
	  TestLogDateTime = NOW();

END;
END$$
DELIMITER ;
