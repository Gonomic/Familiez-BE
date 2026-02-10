DELIMITER $$
CREATE PROCEDURE `API_GetAPItoDBDetails`()
    SQL SECURITY INVOKER
    COMMENT 'To get the details of SPROCs which can be reached through API'
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
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: API_GetAPItoDBDetails(). Rollback executed. CompletedOk= ", CompletedOk),
				TestLogDateTime = NOW();
		SELECT CompletedOk;
	END;

main_proc:
BEGIN
    SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("API_GetAPItoDBDetails");

    -- Schrijf start van deze SQL transactie naar log
    INSERT INTO humans.testlog 
	SET TestLog = CONCAT('===> Start Transaction= TransAction-', IFNULL(NewTransNo, 'null')), TestLogDateTime = NOW();

	-- SELECT CompletedOk, APItoDBRoute, SpoFieldNamesAndTypes from APItoDB where APItoDBRoute like 'API_%';
   	SELECT CompletedOk, APItoDBRoute, SpoFieldNamesAndTypes from APItoDB;
    
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('<=== End Transaction= TransAction-', IFNULL(NewTransNo, 'null'), 'Select all from APItoDB succesful'), TestLogDateTime = NOW();

END ;
END$$
DELIMITER ;
