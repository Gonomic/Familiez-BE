CREATE PROCEDURE `Test_Get_SPROC_Info`()
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
			SET TestLog = CONCAT("Transaction-", IFNULL(NewTransNo, "null"), ". ", "Error occured in SPROC: Test_Get_SPROC_Info(). Rollback executed. CompletedOk= ", CompletedOk),
				TestLogDateTime = NOW();
		SELECT CompletedOk;
	END;

    SET CompletedOk = 0;

    SET TransResult = 0;

    SET NewTransNo = GetTranNo("Test_Get_SPROC_Info'");

	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('===> START Transaction= TransAction-', IFNULL(NewTransNo, 'null'), ' Test_Get_SPROC_Info'), TestLogDateTime = NOW();
	
    select r.routine_schema as database_name,
		   r.specific_name as routine_name,
		   r.routine_type AS type,
		   p.parameter_name,
		   p.data_type,
		   case when p.parameter_mode is null and p.data_type is not null
				then 'RETURN'
				else parameter_mode end as parameter_mode,
		   p.character_maximum_length as char_length,
		   p.numeric_precision,
		   p.numeric_scale
	from information_schema.routines r
	left join information_schema.parameters p
			  on p.specific_schema = r.routine_schema
			  and p.specific_name = r.specific_name
	where r.routine_schema not in ('sys', 'information_schema',
								   'mysql', 'performance_schema')
		and r.routine_schema = 'humans' 
	order by r.routine_schema,
			 r.specific_name,
			 p.ordinal_position;
             
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('<=== End Transaction= TransAction-', IFNULL(NewTransNo, 'null'), 'Test_Get_SPROC_Info'), TestLogDateTime = NOW();
END