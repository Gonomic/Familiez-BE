DELIMITER $$
CREATE FUNCTION `fGetPartner`(PersonIdIn INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to get the PersonId of the parner of a person with PersonIdIn.'
BEGIN

    DECLARE Partner INT;
    DECLARE NewTranNo INT;
    
    SET NewTranNo = GetTranNo("fGetPartner");

	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: fGetPartner() voor persoon: ', IFNULL(PersonIdIn, '')),
		TestLogDateTime = NOW();
        
    select RelationWithPerson INTO Partner from relations where RelationPerson= PersonIdIn and RelationName = "3"; 
    
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: fGetPartner() voor persoon: ', IFNULL(PersonIdIn, ''), '. Partner found= ',IFNULL(Partner, '')),
		TestLogDateTime = NOW();    
    
	RETURN Partner; 
    
END$$
DELIMITER ;
