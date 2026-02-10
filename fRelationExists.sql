CREATE FUNCTION `fRelationExists`(Child INT, RelationType INT, Parent INT) RETURNS tinyint(1)
    READS SQL DATA
    DETERMINISTIC
    COMMENT 'Function to test if a relation exists between a certain Child and Parent.'
BEGIN

    DECLARE RetVal boolean;
    DECLARE NewTranNo INT;
    
    SET NewTranNo = GetTranNo("fRelationExists");

	SET RetVal = false;
    
	-- Schrijf start van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. Start FUNC: fRelationExists() for child= ', IFNULL(Child, 'null'), ' and parent= ', IFNULL(Parent, 'null')),
		TestLogDateTime = NOW();
        
    select true INTO RetVal from humans.relations 
		WHERE RelationName = RelationType AND
				RelationPerson = Child AND
                RelationWithPerson = Parent; 
    
	-- Schrijf einde van deze SQL transactie naar log 
	INSERT INTO humans.testlog 
	SET TestLog = CONCAT('TransAction-', IFNULL(NewTranNo, 'null'), '. End FUNC: fRelationExists() for child= ', IFNULL(Child, 'null'), ' and parent= ', IFNULL(Parent, 'null'), '. Relation exists= ', IFNULL(RetVal, 'null')),
		TestLogDateTime = NOW();    
   
	RETURN RetVal; 
   
END