CREATE FUNCTION `fGetParmNamesAndTypes`(`SpecificNameIn` CHAR(60), `TransNoIn` INT) RETURNS text CHARSET utf8
    DETERMINISTIC
    SQL SECURITY INVOKER
    COMMENT 'Function to return parameter names and type of a specific SPROC'
BEGIN
	DECLARE done INT default FALSE;
	DECLARE ReturnValue text;
    DECLARE ParmName, ParmType CHAR(20);
   
    DECLARE Cursor1 CURSOR for select PARAMETER_NAME,  DATA_TYPE from information_schema.parameters where SPECIFIC_NAME =  SpecificNameIn;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    INSERT INTO humans.testlog 
    SET TestLog = CONCAT('TransAction-', IFNULL(TransNoIn, 'null'), 'In GetParmNamesAndTypes(). SpecificNameIn= ', SpecificNameIn), TestLogDateTime = NOW();

	OPEN Cursor1;

	SET ReturnValue="{'parms':";

	read_loop: LOOP
		FETCH cursor1 INTO ParmName, ParmType;
		IF done THEN
		  LEAVE read_loop;
		END IF;
		SET ReturnValue = concat(ReturnValue, '{"Name":"', ParmName, '" , "type":"', ParmType, '"},');
        SET ParmName= "";
        SET ParmType= "";
	  END LOOP;
      
      SET ReturnValue = SUBSTR(ReturnValue, 1, LENGTH(ReturnValue)-1);
      SET ReturnValue = concat(ReturnValue, '}');

	RETURN ReturnValue; 

END