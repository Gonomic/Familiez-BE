DELIMITER $$
CREATE FUNCTION `fGetMother`(PersonIdIn INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to get the PersonId of the Mother of a person with PersonIdIn.'
BEGIN

    DECLARE RetVal INT;
    DECLARE NewTranNo INT;
    
    SET NewTranNo = GetTranNo("fGetMother");

	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: fGetMother() voor persoon: ', IFNULL(PersonIdIn, '')),
		TestLogDateTime = NOW();
        
    select RelationWithPerson INTO RetVal from relations where RelationPerson= PersonIdIn and RelationName = "2"; 
    
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: fGetMother() voor persoon: ', IFNULL(PersonIdIn, ''), '. Mother found= ',IFNULL(RetVal, '')),
		TestLogDateTime = NOW();    
   
	RETURN RetVal; 
   
END$$
DELIMITER ;
