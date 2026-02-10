CREATE FUNCTION `fGetGenderOfPerson`(PersonIdIn INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to get the gender of a person.'
BEGIN

    DECLARE RetVal INT;
    DECLARE NewTranNo INT;
    
    SET NewTranNo = GetTranNo("fGetGenderOfPerson");

	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: fGetGenderOfPerson() voor persoon: ', IFNULL(PersonIdIn, '')),
		TestLogDateTime = NOW();
        
    select PersonIsMale INTO RetVal from humans.persons where PersonID = PersonIdIn; 
    
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: fGetGenderOfPerson() voor persoon: ', IFNULL(PersonIdIn, ''), '. Gender= ', IFNULL(RetVal, 'null')),
		TestLogDateTime = NOW();    
   
	RETURN RetVal; 
   
END