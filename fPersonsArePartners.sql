CREATE FUNCTION `fPersonsArePartners`(PersonIn1 INT, PersonIn2 INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function returns true if two persons are eachothers partner'
BEGIN

    DECLARE NewTranNo INT;
    DECLARE RecCount INT;
    DECLARE ArePartners BOOL;
    
    SET NewTranNo = GetTranNo("PersonsArePartners");

	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: PersonsArePartners() voor persoon: ', IFNULL(PersonIn1, 'null'), ' en voor persoon: ', IFNULL(PersonIn2, 'null')),
		TestLogDateTime = NOW();
        
    select count(*) from relations where RelationPerson= PersonIn1 and RelationWithPerson = PersonIn2 and RelationName = "3" into RecCount;
    
    IF RecCount > 0 THEN
		SET ArePartners = true;
	ELSE
		SET ArePartners = false;
	END IF;
       
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: PersonsArePartners(). Persoon ', IFNULL(PersonIn1, ''), ' en persoon ',IFNULL(PersonIn2, ''), ' zijn partners= ', IFNULL(ArePartners, 'null')),
		TestLogDateTime = NOW();    
    
	RETURN ArePartners; 
    
END